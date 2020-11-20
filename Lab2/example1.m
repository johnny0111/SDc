close all, clear all, clc
disp('Sky diving - Example 1')
ro = 1.225; % Air density
Cd = 1; % Drag coefficient 
A = 0.7; % Skydiver's cross-sectional area [m^2]
m = 90;

a1 = ro*Cd*A/(2*m);

F = @(t,x)[x(2);a1*(x(2))^2-9.81];
L = @(t,xl)[xl(2);-9.81];
tmax = 15;
x00 = [1000 0]';
x0 = x00;
xl0 = x00;
time = 0 : tmax;

for t = 1 : tmax % Nonlinear model simulation
tspan = [t-1 t];    
S = ode45(F,tspan,x0);
Sl = ode45(L,tspan,xl0);
x0 = deval(S,t);
xl0 = deval(Sl,t);
x(:,t) = x0;
xl(:,t) = xl0;
end % for

% Discretization 
Ac = [0 1;0 0];Bc = [0 -1]'; Cc = [1 0];
sysc = ss(Ac,Bc,Cc,0);
Ts = 1; % Sampling time 1 s
sysd=c2d(sysc,Ts,'zoh');
[A,B,C,D,K] = ssdata(sysd);

% Discrete Kalman filter
xm = [1000 0]';
hk(1,1)= xm(1,1);

W = [70 0;0 20]; % Process noise variance
V = 15; % Measurement noise variance

Pk = 20*eye(2); % Initialisation of P
z = [1000 x(1,:)+V*randn(1,length(x))]; % Noisy readings

for k = 2:tmax+1 % Kalman filter implementation
xm =  A*xm + B*9.81;
xl1(:,k) = xm;
xma(k) = xm(1,1);
Pk = A*Pk*A'+ W;
K = Pk*C'*(C*Pk*C'+V)^-1;
xm= xm + K*(z(k)-xm(1));
Pk = (eye(2)-K*C)*Pk;
hk(:,k) = xm(1,1);
end

xl1(:,1) = [1000 0]';

for k = 2:tmax+1 % Linear model simulation
xl1(:,k) = A*xl1(:,k-1) + B*9.81;

end

plot(time(1:end),z(1:end),'o'), hold on
plot(time,[x00(1,1) x(1,:)])
plot(time,[x00(1,1) xl(1,:)],'-.')
plot(time,xl1(1,:),'*')
plot(time,hk,'+')
axis([0 tmax 250 1050])
title({'Sky Diving Simulations'},'Interpreter','latex')
xlabel({'Time [$s$]'},'Interpreter','latex')
ylabel({'$h$ [$m$]'},'Interpreter','latex')
legend('Altimeter','Nonlinear cont.','Linear. cont.','Lin. Discreto','KF estimate','Location','best')
