fun = @(x)-sqrt(x(1)).*sin(x(1)).*sqrt(x(2)).*sin(x(2)); % Maximization (multiplied by -1) rng default % For reproducibility (random number generator)
nvars = 2;
lb=[0 0];
ub = [10 10];
options = optimoptions('ga','PopulationType','doubleVector','PopulationSize',500, 'CrossoverFraction', 0.85,'Generations',40,'SelectionFcn',@selectionroulette, 'PlotFcns',@gaplotbestf);
[x,fval] = ga(fun,nvars,[],[],[],[],lb,ub,[],[],options)
xb=x;
fprintf('Optimal Value: (%4.2f,%4.2f) \n',x(1),x(2))
fprintf('Optimal Function Value: %4.2f\n',-fval)
close
[x,y] = meshgrid(0:.1:10);
Z = sqrt(x).*sin(x).*sqrt(y).*sin(y);
mesh(x,y,Z)
hold on
plot3(xb(1), xb(2), -fval, 'r*', 'MarkerSize', 10)
