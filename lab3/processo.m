%%% Script para testar o controlador%%%
clear all, close,clc
load ctrlpar.mat

r = [2*ones(150,1);4*ones(150,1);3*ones(150,1); 4.5*ones(150,1);3*ones(150,1)]; 
%r = [3*ones(450,1)];
Ts =  0.08; % Definir intervalo de amostragem
usbinit% Inicialização da placa de aquisição

% *************************************************
N = length(r);
u = zeros(N,1);
ek = zeros(N,1);


for index= 1:N
    y(index,1)= usbread(0)
    tic% Inicia cronómetro
     if index<= 2
         u(index,1) = r(index);
     else
        u(index,1) = uctrl(u(index-1,1), ek(index,1), ek(index-1,1), ek(index-2,1), Ks(1), Ks(2), Ks(3), Ts);
        ek(index,1) = r(index,1) - y(index,1);
     end
        u(index,1) = max(min(u(index,1),5),0); % Saturação da excitação
        usbwrite(u(index),0)
        Dt = toc; % Stop cronómetro
        pause(Ts-Dt)
end
usbwrite(0,0)

erro = sumsqr(ek);
    

subplot(2,1,1), plot(y(1:end),'r'),hold on, plot(r(1:end),'g'),hold off,
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(1:end))
title('Actuação')
ylabel('Acção de controlo'), xlabel('Amostra')

save expdata.mat r u y -mat