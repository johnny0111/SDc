load dataset.mat
load modelpar2
N = length(Ye);
y = zeros(N);

Ne = length(Ue);
yme = zeros(Ne,1);
kmax = Ne;
Ts = 0.08;
erro = zeros(Ne,1);

for  index = 4 : Ne 
    
    yme(index) = -theta(1)*yme(index-1) - theta(2)*yme(index-2) - theta(3)*yme(index-3)...
        + theta(4)*dctr(index-2) + theta(5)*dctr(index-3);
    erro(index) = Ye(index) - yme(index);

end
error = sumsqr(erro)

figure
plot((1:kmax)*Ts, Ye,'k',(1:kmax)*Ts,yme,'b')
legend('Real','Simulation')
title('Estimation dataset: Model vs. REal data')
xlabel({'Time [s]'}, 'Interpreter', 'latex')
ylabel({'Output [V]'}, 'Interpreter', 'latex')