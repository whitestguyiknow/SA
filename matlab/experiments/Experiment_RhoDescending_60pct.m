%% Basekt Spread Option Pricing
%% Experiment rho descending
% Author: Daniel Waelchli
% November 2015

clear all;
format long;
addpath('..');

% seed
seed = 911627;
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
K = [50 60 70 80 90];
nK = length(K);
T = 1;

%% Numerical Experiment: rho alternating, N=10

% Market Params
nAssets = 10;
nPositive = 5;
S0type = 'charged';
sigmaType = 'constant';
sigma = 0.6;
rhoType = 'descending';
rho = 0.0;

[eD,aD,S0D,sigmaD,rhoD] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

%Pricing
VsobD = zeros(1,nK);
tsobD = zeros(1,nK);
VhybMMICUBD = zeros(1,nK);
thybMMICUBD = zeros(1,nK);

for i = 1:nK
    [VsobD(i),tsobD(i)] = priceBasketSpreadOptionSOB(K(i),r,T,eD,aD,S0D,sigmaD,rhoD);
    [VhybMMICUBD(i),thybMMICUBD(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,eD,aD,S0D,sigmaD,rhoD,eps);
end

[VmcD_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);

printRun('data/RhoDescending10_60pct.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',VsobD,tsobD,'HybMMICUB',VhybMMICUBD,thybMMICUBD,...
    'MC',VmcD_1,tmc_1,'MC',VmcD_2,tmc_2,'MC',VmcD_3,tmc_3,'MC',VmcD_4,tmc_4,...
    'MC',VmcD_5,tmc_5);

%% Numerical Experiment: rho alternating, N=50

% Params
nAssets = 50;

[eD,aD,S0D,sigmaD,rhoD] = generateMarketParams(nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho);

%Pricing
VsobD = zeros(1,nK);
tsobD = zeros(1,nK);
VhybMMICUBD = zeros(1,nK);
thybMMICUBD = zeros(1,nK);

for i = 1:nK
    [VsobD(i),tsobD(i)] = priceBasketSpreadOptionSOB(K(i),r,T,eD,aD,S0D,sigmaD,rhoD);
    [VhybMMICUBD(i),thybMMICUBD(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,eD,aD,S0D,sigmaD,rhoD,eps);
end

[VmcD_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);
[VmcD_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,eD,aD,S0D,sigmaD,rhoD,nPaths,nSteps,M);

printRun('data/RhoDescending50_60pct.txt',nAssets,nPositive,S0type,sigmaType,sigma,rhoType,rho,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',VsobD,tsobD,'HybMMICUB',VhybMMICUBD,thybMMICUBD,...
    'MC',VmcD_1,tmc_1,'MC',VmcD_2,tmc_2,'MC',VmcD_3,tmc_3,'MC',VmcD_4,tmc_4,...
    'MC',VmcD_5,tmc_5);
