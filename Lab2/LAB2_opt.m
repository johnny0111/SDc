%%% Controlo óptimo de Seguimento %%%
%%%        Pseudocódigo           %%%
clear all, close, clc
load ssmodel2.mat
load dataset.mat
model.A = A;
model.B = B;
model.C = C;
usbinit;
Ts = 0.08;
for index = 1:1000
    usbwrite(1,0);
    pause(0.05);
    yvv(index,1) = usbread(0);
end
ycut = yvv(50:end);
V = var(ycut-mean(ycut));
V = 0.0016;
S=30*eye(size(C,1));
Q=20*eye(size(C,1));
R=0.1*eye(size(B,2));
r = [2*ones(1,150) 4*ones(1,150) 3*ones(1,150) 4.5*ones(1,150) 3*ones(1,151)]; % Sinal de referência
%r = [2*ones(1,150)]; % Sinal de referência
kfinal=length(r);
P(:,:,kfinal+1)=C'*S*C;          % Matriz de covariancia
m(:,:,kfinal+1)=C'*S*r(kfinal);% Vector de avanço
% x(:,1)=zeros(size(A,1),1); % Estado inicial nulo -> y(0) = 0
% y(:,1) = C*x(:,1);

xk(:,1) = zeros(3,1);
x(:,1) = zeros(3,1);
pk = 10*eye(3);
%V = var(Ye);
lambda = 0.95;
u(:,kfinal+1) = zeros(1);
 % Inicialização da placa de aquisição
disp('Em modo controlo!')

for k=kfinal:-1:1
   P(:,:,k)=A'*P(:,:,k+1)*(eye(size(A,1))-B*inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1))*A+C'*Q*C;
   m(:,k)=(A'-A'*P(:,:,k+1)*B*inv(B'*P(:,:,k+1)*B+R)*B')*m(:,k+1)+C'*Q*r(k);
   K(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1)*A;
   Kf(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B';
end

for k = 1:kfinal-1
   if k < 2
    u(:,k) = r(k); 
   else
    y(k,1)= usbread(0);
    tic % Inicia cronómetro
    
   %FILTRO DE KALMAN
       W = (1/lambda - 1) * pk;
       xk(:,k) = A*xk(:,k-1) + B*u(:,k-1);
       pk = A*pk*A' + W;
       KalmanG = pk*C'*(C*pk*C'+V)^-1;
       xk(:,k) = xk(:,k) + KalmanG*(y(k,1)-C*xk(:,k));
       pk = (eye(numel(xk(:,k)))-KalmanG*C) * pk;

       %accao de controlo
       u(:,k)=-K(:,:,k)*xk(:,k)+Kf(:,:,k)*m(:,:,k+1);
       u(:,k) = max(min(u(:,k),5),0);

    usbwrite(u(:,k),0); % Actua sobre o processo
    Dt= toc; % Stop cronómetro
    pause(Ts-Dt) % Temporização
   end
end
usbwrite(0,0)
save expdataOPT.mat r u y -mat


subplot(2,1,1),plot(y(2:end)), hold on, plot(r(1:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(2:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')


