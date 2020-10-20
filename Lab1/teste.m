%%% Script para testar o controlador%%%
clear all, close, clc

load arxdata.mat


Ref= [2*ones(200,1); 4*ones(200,1); 3*ones(200,1); 4.5*ones(200,1); 3*ones(200,1)]; % Sinal de referência
Ts=  0.08; % Definir intervalo de amostragem
usbinit% Inicialização da placa de aquisição
na = size(A)-1;
nk= length((find(B==0)));
nb=length(B)-nk;
[F,G]=tuning(A); % Parâmetros do controlador
disp('Em modo controlo!')
u = zeros(Nmax,1);
y=zeros(Nmax,1);
P = 1;
Q = 1;
R = 0.44;
for index= 1:length(Ref)
    y(index,1)= usbread(0);
    tic% Inicia cronómetro
    if index<= max(na,nb+nk)
        u(index,1) = Ref(index);
    else
        u(index,1)=ctrlq(B, F, G, P, Q, R, u(index-1, 1), u(index-2, 1), u(index-3,1), y(index,1), y(index-1,1), Ref(index)) ;  % Função do controlador
    end
    u(index,1) = max(min(u(index,1),5),0); % Saturação [0;5]V
    usbwrite(u(index),0); % Actuasobre o processo
    Dt= toc; % Stop cronómetro
    pause(Ts-Dt) % Temporização
end
usbwrite(0,0)
save expdata.mat Ref u y -mat