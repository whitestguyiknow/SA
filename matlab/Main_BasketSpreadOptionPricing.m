%% Basekt Spread Option Pricing
% Author: Daniel Waelchli
% November 2015

format long;

str_now = char(date);
diary(['data/output_', str_now, '.txt']);

seed = 133781;
rng(seed);

nPaths = 1e4;
nSteps = 1e2;
eps = 1e-5;
r = 0.05;

%% Numerical Experiments from Mulit-asset spread Option Pricing
K = [0 5 10 15 20];
T = 0.25;

[e50,a50,S050,sigma50,rho50] = generateMarketParams(5,1,'charged','constant',0.4,'descending',0);

%Vsob50 = priceBasketSpreadOptionSOB(K(i),r,T,e50,a50,S050,sigma50,rho50)
%VhybMMICUB50 = priceBasketSpreadOptionHybMMICUB(K(i),r,T,e50,a50,S050,sigma50,rho50,eps)
Vmc50 = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps)




