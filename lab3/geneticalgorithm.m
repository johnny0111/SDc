A = [-1 -1];
b = -1;
Aeq = [-1 1];
beq = 5;

lb = [1 -3];
ub = [6 8];
IPM = [100 2];
niter = 100;

options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf, 'CrossoverFraction', 0.85, 'SelectionFcn','selectionroulette', 'MaxGenerations', niter, 'InitialPopulationMatrix',IPM);

rng default % For reproducibility
fun = @ps_example;
x = ga(fun,2,A,b,Aeq,beq,[],[],[],options)