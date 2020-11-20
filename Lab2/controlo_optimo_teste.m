% Sistemas de decisao - NOVA.FCT/DEEC
% Controlador optimo de seguimento em tempo discreto
% Exemplo Out. 2020 - Paulo Gil
% +++++++++++++++++++++++++++++++++++++++++++++++++++++++

clear all, close, clc
load dataset.mat;
%load PEM.mat
%load ssmodel2.mat
%load model.mat
load ss2.mat
A = ss2.A;
B = ss2.B;
C = ss2.C;
S=100*eye(size(C,1));
Q=500*eye(size(C,1));
R=1*eye(size(B,2));

r=[2*ones(1,150) 4*ones(1,150) 3*ones(1,150) 4.5*ones(1,150) 3*ones(1,150)]; % Sinal de referência
kfinal=length(r);
P(:,:,kfinal+1)=C'*S*C;          % Matriz de covariancia
m(:,:,kfinal+1)=C'*S*r(kfinal);% Vector de avanço
x(:,1)=zeros(size(A,1),1); % Estado inicial nulo -> y(0) = 0
y(:,1) = C*x(:,1);
pk = 3 * eye(4);
% Cálculo de K e Kf em diferido
[K_ricatti,Kf,m] = retroacao( A,B,C,P,Q,R,m,kfinal,r);
V = var(Ye);
w = 3;

% Simulacao da resposta do sistema

for k=1:kfinal
   u(:,k)=-K_ricatti(:,:,k)*x(:,:,k)+Kf(:,:,k)*m(:,:,k+1);
   %x(:,k+1)=A*x(:,k)+B*u(:,k);
   x(:,:,k+1) = A*x(:,:,k) + B*u(:,k);
   pk = A*pk*A' + w;
   K = pk*C'*(C*pk*C'+V)^-1;
   y(:,k+1)=C*x(:,:,k+1);
   x(:,:,k+1) = x(:,:,k+1) + K*(y(:,k+1)-C*x(:,:,k+1));
   pk = (eye(numel(x(:,:,k+1)))-K*C) * pk;
end

subplot(2,1,1),plot(y(2:end)), hold on, plot(r(1:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('saida'), xlabel('amostra')
subplot(2,1,2), plot(u(2:end))
title('actuacao')
ylabel('accao de controlo'), xlabel('amostra')


