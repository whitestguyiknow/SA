%% Basekt Spread Option Pricing
%% Experiment rho alternating
% Author: Daniel Waelchli
% November 2015

clear all;
format long;
addpath('..');

% seed
seed = 6117833;
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
K = [50 60 70 80 90];
nK = length(K);
T = 1;

%% Numerical Experiment: rho alternating, N=10

% Matket Params
nAssets = 10;
nPositive = 5;
S0type = 'charged';
sigmaType = 'constant';
sigma = 0.3;
rhoType = 'alternating';
rho = 0.4;

[eA,aA,S0A,sigmaA,rhoA] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

% Pricing
VsobA = zeros(1,nK);
tsobA = zeros(1,nK);
VhybMMICUBA = zeros(1,nK);
thybMMICUBA = zeros(1,nK);

for i = 1:nK
    [VsobA(i),tsobA(i)] = priceBasketSpreadOptionSOB(K(i),r,T,eA,aA,S0A,sigmaA,rhoA);
    [VhybMMICUBA(i),thybMMICUBA(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,eA,aA,S0A,sigmaA,rhoA,eps);
end

[VmcA_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);

printRun('data/RhoAlternating10.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',VsobA,tsobA,'HybMMICUB',VhybMMICUBA,thybMMICUBA,...
    'MC',VmcA_1,tmc_1,'MC',VmcA_2,tmc_2,'MC',VmcA_3,tmc_3,'MC',VmcA_4,tmc_4,...
    'MC',VmcA_5,tmc_5);

%% Numerical Experiment: rho alternating, N=50


% Market Params
nAssets = 50;
nPositive = 5;
S0type = 'charged';
sigmaType = 'constant';
sigma = 0.3;
rhoType = 'alternating';
rho = 0.4;

[eA,aA,S0A,sigmaA,rhoA] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

% Pricing
VsobA = zeros(1,nK);
tsobA = zeros(1,nK);
VhybMMICUBA = zeros(1,nK);
thybMMICUBA = zeros(1,nK);

for i = 1:nK
    [VsobA(i),tsobA(i)] = priceBasketSpreadOptionSOB(K(i),r,T,eA,aA,S0A,sigmaA,rhoA);
    [VhybMMICUBA(i),thybMMICUBA(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,eA,aA,S0A,sigmaA,rhoA,eps);
end

[VmcA_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);
[VmcA_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,eA,aA,S0A,sigmaA,rhoA,nPaths,nSteps,M);

printRun('data/RhoAlternating50.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',VsobA,tsobA,'HybMMICUB',VhybMMICUBA,thybMMICUBA,...
    'MC',VmcA_1,tmc_1,'MC',VmcA_2,tmc_2,'MC',VmcA_3,tmc_3,'MC',VmcA_4,tmc_4,...
    'MC',VmcA_5,tmc_5);
