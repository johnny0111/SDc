%%% Controlo óptimo de Seguimento %%%
%%%        Pseudocódigo           %%%
clear all, close, clc
Ref= [] % Definir o sinal de referência
Ts =  ; % Definir intervalo de amostragem
A = [ ... ];  B = [ ... ]; C = [ ... ]; % Modelo no E.E.
    Q = [ ... ];  R = [ ... ]; S = [ ... ]; % Matrizes de penalização
    kfinal = length(Ref); Horizonte de controlo
    P(:,:,kfinal+1)=C'*S*C;  % Inicialização da matriz de Riccati
    m(:,:,kfinal+1)=C'*S*r(kfinal+1); % Inicialização do vector de avanço
    W = [ ]; % Variância do ruído do processo -Filtro de Kalman
    V = ; %  % Variância do ruído sobre a saída - Filtro de Kalman
    Pfk = [ ... ]; % Initialização de P - Filtro de Kalman
    [m, K, Kf ] = controlador();  % Obter K, Kf e m em diferido
    usbinit % Inicialização da placa de aquisição
    disp(‘Em modo controlo!’)
for index = 1:kfinal
    y(index,1)= usbread(0);
    tic % Inicia cronómetro
    [x, Pfk] = kffiltro(A, B, C, Pfk, uk, yk, lambda); % Estima estado
    uopt = ucontrol(K, Kf, m, x); % Calcula a acção de controlo
    u(index,1) = max(min(uopt,5),0) % Saturação [0;5] V
    usbwrite(u(índex,1),0); % Actua sobre o processo
    Dt= toc; % Stop cronómetro
    pause(Ts-Dt) % Temporização
    if index == kfinal
        y(index+1,1)= usbread(0);
    end
end
usbwrite(0,0)
save expdata.mat Ref u y -mat

