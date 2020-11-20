subplot(2,1,1),plot(y(2:end)), hold on, plot(r(1:end)),hold off;
title('Resposta do sistema em anel fechado')
ylabel('Saída'), xlabel('Amostra')
subplot(2,1,2), plot(u(2:end))
title('Actuação')
ylabel('Acçãode controlo'), xlabel('Amostra')