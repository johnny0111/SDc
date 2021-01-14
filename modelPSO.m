close all; clear all; clc;

% dctr;
% yreal;

% Load modelData; % File with data collected from the plant

load dataset.mat

% yreal = Ye; % dados reais do processo
dctr = Ue;
yreal = Ye;

%limites para os parâmetros ai, bi
% ARX(3,2,1) -> no. de parâmetros do modelo
UB = [5 5 5 5 5];
LB = [-5 -5 -5 -5 -5];

% Adjustment parameters PSO
c1 = 1.49; % Default SelfAdjustment
c2 = 1.49; % Default SocialAdjustment

options = optimoptions(@particleswarm,'MaxIter',300,'SelfAdjustment',c1,...
    'SocialAdjustment',c2,'SwarmSize',500,'Display','iter');

fun = @(theta)modelFitness(theta,dctr,yreal);

[theta,fval] = particleswarm(fun,5,LB,UB,options)

clc

save modelpar.mat theta -mat

modelsimul

theta
