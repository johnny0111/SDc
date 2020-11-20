% Sistemas de decisao - NOVA.FCT/DEEC
% Controlador optimo de seguimento em tempo discreto
% Exemplo Out. 2020 - Paulo Gil
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear all, close, clc
load PEM.mat
load dataset.mat
load ssmodel2.mat
model.A = A;
model.B = B;
model.C = C;
S=30*eye(size(C,1));
Q=20*eye(size(C,1));
R=0.1*eye(size(B,2));
r = [2*ones(1,150) 4*ones(1,150) 3*ones(1,150) 4.5*ones(1,150) 3*ones(1,150)]; % Sinal de referência
kfinal=length(r);
P(:,:,kfinal+1)=C'*S*C;          % Matriz de covariancia
m(:,:,kfinal+1)=C'*S*r(kfinal);% Vector de avanço
% x(:,1)=zeros(size(A,1),1); % Estado inicial nulo -> y(0) = 0
% y(:,1) = C*x(:,1);
lambda = 0.95;
xk(:,:,kfinal+1) = zeros(3,1);
x(:,:,kfinal+1) = zeros(3,1);
pk(:,:,kfinal+1) = eye(3);
V = var(Ye);
%W = 1*eye(3);
u(:,kfinal+1) = zeros(1);
% Cálculo de K e Kf em diferido
for k=kfinal:-1:1
   P(:,:,k)=A'*P(:,:,k+1)*(eye(size(A,1))-B*inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1))*A+C'*Q*C;
   m(:,k)=(A'-A'*P(:,:,k+1)*B*inv(B'*P(:,:,k+1)*B+R)*B')*m(:,k+1)+C'*Q*r(k);
   K(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1)*A;
   Kf(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B';
end

% Simulacao da resposta do sistema

for k=1:kfinal
   if k < 2
        u(:,k) = r(k); 
   else
       x(:,k)=A*x(:,k-1)+B*u(:,k-1); %estado real
       y(:,k)=C*x(:,:,k);

       W = (1/lambda - 1) * pk(:,:,k);
       xk(:,:,k) = A*xk(:,:,k-1) + B*u(:,k-1);
       pk(:,:, k) = A*pk(:,:,k-1)*A' + W;
       KalmanG = pk(:,:, k)*C'*(C*pk(:,:, k)*C'+V)^-1;
       xk(:,:,k) = xk(:,:,k) + KalmanG*(y(:,k)-C*xk(:,:,k));
       pk(:,:,k) = (eye(numel(xk(:,:,k)))-KalmanG*C) * pk(:,:,k);

       u(:,k)=-K(:,:,k)*xk(:,:,k)+Kf(:,:,k)*m(:,:,k);
       u(:,k) = max(min(u(:,k),5),0);
    end

end

subplot(2,1,1),plot(y(2:end)), hold on, plot(r(1:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(2:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')


