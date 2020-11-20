% Sistemas de decisao - NOVA.FCT/DEEC
% Controlador optimo de seguimento em tempo discreto
% Exemplo Out. 2020 - Paulo Gil
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear all, close, clc
A=[1 1;0 1];
B=[0.05 0.1]';
C=[1 0];
S=10*eye(size(C,1));
Q=5*eye(size(C,1));
R=10*eye(size(B,2));
kfinal=60;
t=0:kfinal;
r=sin(0.1*t')+ones(length(t),1); % Sinal de referência
P(:,:,kfinal+1)=C'*S*C;          % Matriz de covariancia
m(:,:,kfinal+1)=C'*S*r(kfinal+1);% Vector de avanço
x(:,1)=zeros(size(A,1),1); % Estado inicial nulo -> y(0) = 0
y(:,1) = C*x(:,1);
% Cálculo de K e Kf em diferido
for k=kfinal:-1:1
   P(:,:,k)=A'*P(:,:,k+1)*(eye(size(A,1))-B*inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1))*A+C'*Q*C;
   m(:,k)=(A'-A'*P(:,:,k+1)*B*inv(B'*P(:,:,k+1)*B+R)*B')*m(:,k+1)+C'*Q*r(k);
   K(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1)*A;
   Kf(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B';
end

% Simulacao da resposta do sistema

for k=1:kfinal
   u(:,k)=-K(:,:,k)*x(:,k)+Kf(:,:,k)*m(:,:,k+1);
   x(:,k+1)=A*x(:,k)+B*u(:,k);
   y(:,k+1)=C*x(:,k+1);
end

subplot(2,1,1),plot(t,y,'-',t,r,'-. k')
title('\textbf{Resposta em anel fechado}','Interpreter','latex')
legend('saída','Referência')
ylabel({'$y(k)$'},'Interpreter','latex')
xlabel('Tempo $[s]$','Interpreter','latex')
subplot(2,1,2),stairs(t(1:end-1),u,'r-')
xlabel('Tempo $[s]$','Interpreter','latex')
ylabel({'$u(k)$'},'Interpreter','latex')

