%% Basekt Spread Option Pricing
%% Replicating Numerical Experiments from Mulit-asset spread Option Pricing
%% by S.J. Deng, M. Li, J. Zhou. (2007)

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
M = 1e3;

% adaptive Simpson's rule
eps = 1e-5;

% interest rate
r = 0.05;

% Params
K = [30 35 40 45 50];
nK = length(K);
T = 0.25;

% Market Params
sigma = [0.3 0.3 0.3];
rho = [1, 0.2 0.8; 0.2 1 0.4; 0.8, 0.4, 1];
S0 = [150, 60, 50];
e = [1 -1 -1];
a = [1 1 1];


% Pricing
Vsob = zeros(1,nK);
tsob = zeros(1,nK);
Vhy = zeros(1,nK);
thyb = zeros(1,nK);

% SOB & HybMMICUB
for i = 1:nK
    [Vsob(i),tsob(i)] = priceBasketSpreadOptionSOB(K(i),r,T,e,a,S0,sigma,rho);
    [Vhy(i),thyb(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,e,a,S0,sigma,rho,eps);
end

% Mnte Carlo
[Vmc_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);

printRun('MASOP50_Table1.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob,tsob,'HybMMICUB',Vhy,thyb,...
    'MC',Vmc_1,tmc_1,'MC',Vmc_2,tmc_2,'MC',Vmc_3,tmc_3,'MC',Vmc_4,tmc_4,...
    'MC',Vmc_5,tmc_5);

% new Market Params
sigma = [0.6 0.6 0.6];

Vsob = zeros(1,nK);
tsob = zeros(1,nK);
Vhy = zeros(1,nK);
thyb = zeros(1,nK);

% SOB & HybMMICUB
for i = 1:nK
    [Vsob(i),tsob(i)] = priceBasketSpreadOptionSOB(K(i),r,T,e,a,S0,sigma,rho);
    [Vhy(i),thyb(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,e,a,S0,sigma,rho,eps);
end

% Monte Carlo
[Vmc_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);
[Vmc_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,e,a,S0,sigma,rho,nPaths,nSteps,M);

printRun('MASOP50_60pct_Table1.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob,tsob,'HybMMICUB',Vhy,thyb,...
    'MC',Vmc_1,tmc_1,'MC',Vmc_2,tmc_2,'MC',Vmc_3,tmc_3,'MC',Vmc_4,tmc_4,...
    'MC',Vmc_5,tmc_5);
