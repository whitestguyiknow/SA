%% Basekt Spread Option Pricing
%% Replicating Numerical Experiments from Mulit-asset spread Option Pricing
%% Table3, Panel B
% Author: Daniel Waelchli
% November 2015

format long;

% seed
seed = 133001;
rng(seed);

% MC settings
nPaths = 1e2;
nSteps = 1e2;
M = 1e1;

% adaptive Simpson's rule
eps = 1e-5;

% interest rate
r = 0.05;

% Params
K = [0 5 10 15 20];
nK = length(K);
T = 0.25;

[e50,a50,S050,sigma50,rho50] = generateMarketParams(5,1,'charged','constant',0.4,'constant',0);

%Pricing
Vsob50 = zeros(1,nK);
tsob50 = zeros(1,nK);
VhybMMICUB50 = zeros(1,nK);
thybMMICUB50 = zeros(1,nK);

for i = 1:nK
    [Vsob50(i),tsob50(i)] = priceBasketSpreadOptionSOB(K(i),r,T,e50,a50,S050,sigma50,rho50);
    [VhybMMICUB50(i),thybMMICUB50(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,e50,a50,S050,sigma50,rho50,eps);
end

[Vmc50_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_6,tmc_6] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);
[Vmc50_7,tmc_7] = priceBasketSpreadOptionMonteCarlo(K,r,T,e50,a50,S050,sigma50,rho50,nPaths,nSteps,M);

printRun('MASOP_Table3B.txt',5,1,'charged','constant',0.4,'constant',0,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob50,tsob50,'HybMMICUB',VhybMMICUB50,thybMMICUB50,...
    'MC',Vmc50_1,tmc_1,'MC',Vmc50_2,tmc_2,'MC',Vmc50_3,tmc_3,'MC',Vmc50_4,tmc_4,...
    'MC',Vmc50_5,tmc_5,'MC',Vmc50_6,tmc_6,'MC',Vmc50_7,tmc_7);
