%% Basekt Spread Option Pricing
%% Replicating Pricing and hedging Asian basket spread options
%% Table6

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


%Params
K = [-5 -10 -20 -30 -40 -50 -60];
nK = length(K);
T = 1;

e4=[1,-1,-1,-1];
a4=[1,1,1,1];
S04=[100,60,40,30];
sigma4=[0.16,0.23,0.32,0.43];
rho4=[1,0.42,0.5,0.3;0.42,1,0.24,0.42;0.5,0.24,1,0.35;0.3,0.42,0.35,1];

%Pricing
Vsob4 = zeros(1,nK);
tsob4 = zeros(1,nK);
VhybMMICUB4 = zeros(1,nK);
thybMMICUB4 = zeros(1,nK);

for i = 1:nK
    [Vsob4(i),tsob4(i)] = priceBasketSpreadOptionSOB(K(i),r,T,e4,a4,S04,sigma4,rho4);
    [VhybMMICUB4(i),thybMMICUB4(i)] = priceBasketSpreadOptionHybMMICUB(K(i),r,T,e4,a4,S04,sigma4,rho4,eps);
end

[Vmc4_1,tmc_1] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_2,tmc_2] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_3,tmc_3] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_4,tmc_4] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_5,tmc_5] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_6,tmc_6] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);
[Vmc4_7,tmc_7] = priceBasketSpreadOptionMonteCarlo(K,r,T,e4,a4,S04,sigma4,rho4,nPaths,nSteps,M);

printRun('PnHABSO_Table6.txt',4,1,'custom','custom',sigma4,'custom',rho4,r,K,T,seed,nPaths,nSteps,M,eps,...
    'SOB',Vsob4,tsob4,'HybMMICUB',VhybMMICUB4,thybMMICUB4,...
    'MC',Vmc4_1,tmc_1,'MC',Vmc4_2,tmc_2,'MC',Vmc4_3,tmc_3,'MC',Vmc4_4,tmc_4,...
    'MC',Vmc4_5,tmc_5,'MC',Vmc4_6,tmc_6,'MC',Vmc4_7,tmc_7);
