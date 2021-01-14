% Testing particleswarm function ALPINE2
clc, clear, close all
fun = @(x)-sqrt(x(1)).*sin(x(1)).*sqrt(x(2)).*sin(x(2)); % Maximization (multiplied by -1)
rng default  % For reproducibility (random number generator)
nvars = 2;
options = optimoptions('particleswarm','SwarmSize',800,'MaxIterations',...
    800*nvars,'SelfAdjustmentWeight',1.49,'SocialAdjustmentWeight',1.49,...
    'HybridFcn',@fmincon,'PlotFcn','pswplotbestf','Display','iter');
lb = [0 0];
ub = [10 10];
[x,fval,exitflag,output] = particleswarm(fun,nvars,lb,ub,options);
xb = x;
clc,
%close all
%formatSpec = 'Optimal Value: %4.2f -> Fuction Value: %4.3f \n';
formatSpec = 'Optimal Value: (%4.2f,%4.2f) \n';
fprintf(formatSpec,x(1),x(2))
fprintf('Optimal Function Value: %4.2f\n',-fval)
close
[x,y] = meshgrid(0:.1:10);
Z = sqrt(x).*sin(x).*sqrt(y).*sin(y);
mesh(x,y,Z)
hold on
plot3(xb(1), xb(2), -fval, 'r*', 'MarkerSize', 10);
