clc;
clear all;
load data_e_seg;
load data_v_seg;
load arx2_4_1;

A = arx241.A;
b = arx241.B;
B = [b(2:end) 0];
P = 1;
Q = 1;
R = 0.44;
[F,G] = tuning(A);
Ref= [2*ones(200,1); 4*ones(200,1); 3*ones(200,1); 4.5*ones(200,1); 3*ones(200,1)]; % Sinal de referência
Ni = max(2,4+1);
Nmax= length(Ref);
U = zeros(Nmax,1);
u = zeros(Nmax,1);
y = zeros(Nmax,1);
disp('Em modo controlo!')
for index= Ni:Nmax
    uc= ctrlq(B, F, G, P, Q, R, u(index-1, 1), u(index-2, 1), u(index-3,1), y(index,1), y(index-1,1), Ref(index)) ; 
    u(index,1) = max(min(uc,5),0);
    y(index+1,1) = B(1)*u(index,1) + B(2)*u(index-1,1) + B(3)*u(index-2,1) + B(4)*u(index-3,1) - G(1)*y(index) - G(2)*y(index-1,1);
end
subplot(2,1,1),plot(y(Ni:end)), hold on, plot(Ref(Ni:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(Ni:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')