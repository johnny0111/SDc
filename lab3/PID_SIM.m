clear all, clc, close all;

load ctrlpar.mat
load modelpar.mat

r = [2*ones(150,1); 4*ones(150,1); 3*ones(150,1); 4.5*ones(150,1); 3*ones(150,1)];
N = length(r);
y = zeros(N,1);
ek = zeros(N,1);
u = zeros(N,1);
f = 0; 







for  index = 3 : N-1
    u(index,1) = uctrl(u(index-1,1), ek(index,1), ek(index-1,1), ek(index-2,1), Ks(1), Ks(2), Ks(3), 0.08);
    y(index+1,1) = -theta(1)*y(index,1) - theta(2)*y(index-1,1) - theta(3)*y(index-2)...
            + theta(4)*u(index,1) + theta(5)*u(index-1,1) ;
    ek(index+1,1) = r(index+1,1) - y(index+1,1);
   
    
end
erro = sumsqr(ek);
subplot(2,1,1),plot(y(2:end)), hold on, plot(r(1:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(2:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')
