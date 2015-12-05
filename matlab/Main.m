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
nPaths = 1e4;
nSteps = 1e4;
M = 1e2;

% adaptive Simpson's rule
eps = 1e-5;

% interest rate
r = 0.05;

% Params
K = [0 5 10 15 20];
nK = length(K);
T = 0.25;

% Market Params
nAssets = 50;
nPositive = 1;
S0type = 'charged';
sigmaType = 'constant';
sigma = 0.3;
rhoType = 'constant';
rho = 0.4;

[e50,a50,S050,sigma50,rho50] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

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

printRun('MASOP50_Table3B.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob50,tsob50,'HybMMICUB',VhybMMICUB50,thybMMICUB50,...
    'MC',Vmc50_1,tmc_1,'MC',Vmc50_2,tmc_2,'MC',Vmc50_3,tmc_3,'MC',Vmc50_4,tmc_4,...
    'MC',Vmc50_5,tmc_5,'MC',Vmc50_6,tmc_6,'MC',Vmc50_7,tmc_7);

% Market Params
sigma = 0.6;
[e50,a50,S050,sigma50,rho50] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

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

printRun('MASOP50_60pct_Table3B.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob50,tsob50,'HybMMICUB',VhybMMICUB50,thybMMICUB50,...
    'MC',Vmc50_1,tmc_1,'MC',Vmc50_2,tmc_2,'MC',Vmc50_3,tmc_3,'MC',Vmc50_4,tmc_4,...
    'MC',Vmc50_5,tmc_5,'MC',Vmc50_6,tmc_6,'MC',Vmc50_7,tmc_7);
