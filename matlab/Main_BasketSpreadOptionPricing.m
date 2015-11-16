%% Basekt Spread Option Pricing
% Author: Daniel Wälchli
% November 2015


seed = 1337;
rng(seed);

r = 0.05;

%% Numerical Experiments from Mulit-asset spread Option Pricing
K = 30;
T = 0.25;

e = [1 -1 -1];
a = [1 1 1];
S0 = [150 60 50];
sigma = [0.3 0.3 0.3];
rho = [1 0.2 0.8; 0.2 1 0.4; 0.8 0.4 1];

V_sb = priceBasketSpreadOption_SecondOrderBoundaryApprox(K,r,T,e,a,S0,sigma,rho)
V_HybMMICUB = priceBasketSpreadOption_HybMMICUB(K,r,T,e,a,S0,sigma,rho)
V_mc = priceBasketSpreadOption_MonteCarlo(K,r,T,e,a,S0,sigma,rho,1e4,3e3);


% %% Numerical Experiments from Pricing and Hedging Asian Basket Spread Options
% K = 15;
% T = 1;
% 
% e = [1 -1 -1];
% a = [1 1 1];
% S0 = [100 24 46];
% sigma = [0.4 0.22 0.3];
% rho = [1 0.17 0.91; 0.17 1 0.41; 0.91 0.41 1];
% V_mc = priceBasketSpreadOption_MonteCarlo(K,r,T,e,a,S0,sigma,rho,'MC',1e6,3e3);


