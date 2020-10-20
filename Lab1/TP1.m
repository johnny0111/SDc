




%%% Script para testar o controlador %%%
clear all, close all, clc;
load arx231;
Ref= [2*ones(200,1);4*ones(200,1);3*ones(200,1);4.5*ones(200,1);3*ones(200,1)]; % Sinal de referência
A = arx231.A; %Polinómio A
B = arx231.B; % Polinómio B
[F,G]=tuning(A);  % Parâmetros do controlador
Ni = max(2,3+1);
Nmax= length(Ref);
U = zeros(Nmax,1);
disp('Em modo controlo!')
u = zeros(Nmax,1);
y = zeros(Nmax,1);
for index= Ni:Nmax
    uc= ctrlq(B,0.1,u(index-1,1),u(index-2,1),y(index,1),y(index-1,1),Ref(index ),G); % Função do controlador
    u(index,1) = max(min(uc,5),0); % Saturação da excitação
    y(index+1,1) = -G(1)*y(index,1)-G(2)*y(index-1,1) + B(2)*u(index,1) + B(3)*u(index-1,1) + B(4)*u(index-2,1);
end
subplot(2,1,1), plot(y(Ni:end)), hold on, plot(Ref(Ni:end)),hold off ;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')




function [F,G] = tuning(A)
    ONE = eye(1,numel(A));4
    [F,Resto] = deconv(A,ONE);
    G  = Resto(1,2:numel(Resto));
end

function uc = ctrlq(B,r0,u_1,u_2,y,y_1,ref,G)
    b0 = B(2);
    t % P = 1
    Q = 1;
    F = [1 0 0];
    R = r0*[1 0 0];%r0 * [1 -1 0]
    Baux = B(1, 2:numel(B));
    Auxuk = conv(conv(P,Baux),F) + r0/b0*R;
    Auxyk = - conv(P,G);
    uc = (Auxuk(1)^-1)*(-Auxuk(2)*u_1 -Auxuk(3)*u_2 -Auxyk(1)*y -Auxyk(2)*y_1 + Q  *ref);
end
