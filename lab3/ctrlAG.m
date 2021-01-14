 close all; clear all; clc;

% dctr;
% yreal;

% Load modelData; % File with data collected from the plant

load dataset.mat
load modelpar.mat
load weightsctrl.mat

% yreal = Ye; % dados reais do processo
%dctr = Ue;
r = [2*ones(150,1); 4*ones(150,1); 3*ones(150,1); 4.5*ones(150,1); 3*ones(150,1)];

%limites para os parâmetros ai, bi
% ARX(3,2,1) -> no. de parâmetros do modelo
UB = [5 5 5];
LB = [0.1 0.1 0.01];
nv = 3;
%niter = 100;
% p = weights(1);
% q = weights(2);
% w = weights(3);
p = 15;
q = 2;
w = 0.1;

% Adjustment parameters PSO

c1 = 0.85; % Default SelfAdjustment
%c2 = 1.49; % Default SocialAdjustment

%options = optimoptions(@particleswarm,'MaxIter',300,'SelfAdjustment',c1,...
    %'SocialAdjustment',c2,'SwarmSize',500,'Display','iter');
    
 
    
%options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf, 'CrossoverFraction', c1, 'SelectionFcn','selectionroulette', 'MaxGenerations', niter,  'PopulationType', 'doubleVector');
%options = optimoptions('ga','ConstraintTolerance',1e-6,'PlotFcn', @gaplotbestf, 'CrossoverFraction', c1, 'SelectionFcn','selectionroulette', 'MaxGenerations', niter, 'InitialPopulationMatrix',[100 3],  'PopulationType', 'doubleVector');


fun = @(Ks)ctrlFitness(Ks, theta,r, p,q,w);

options = gaoptimset(@ga);
options = gaoptimset('PopulationType', 'doubleVector', 'PopulationSize', 300, 'CrossoverFraction', c1, 'Generations', 100, 'SelectionFcn', @selectionroulette, 'PlotFcns', @gaplotbestf);

[Ks,fval] = ga(fun,3,[],[],[],[],LB,UB,[],[],options);


clc

save ctrlpar.mat Ks -mat

%modelsimul

Ks
