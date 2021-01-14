 close all; clear all; clc;

% dctr;
% yreal;

% Load modelData; % File with data collected from the plant

load dataset.mat
load modelpar.mat
load ctrlpar.mat


r = [2*ones(150,1); 4*ones(150,1); 3*ones(150,1); 4.5*ones(150,1); 3*ones(150,1)];

%limites para os parâmetros ai, bi
% ARX(3,2,1) -> no. de parâmetros do modelo
UB = [50 50 50];
LB = [-50 -50 -50];
nv = 3;


c1 = 0.85; % Default SelfAdjustment


fun = @(weights)weightsFitness(weights, theta,r, Ks);

options = gaoptimset(@ga);
options = gaoptimset('PopulationType', 'doubleVector', 'PopulationSize', 200, 'CrossoverFraction', c1, 'Generations', 50, 'SelectionFcn', @selectionroulette, 'PlotFcns', @gaplotbestf);

[weights,fval] = ga(fun,3,[],[],[],[],LB,UB,[],[],options);


clc

save weightsctrl.mat weights -mat

%modelsimul

weights
