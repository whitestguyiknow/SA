%% Basekt Spread Option Pricing
% Author: Daniel W??lchli
% November 2015

%clear all;

str_now = char(datetime('now'));
diary(['data/output_', str_now, '.txt']);

seed = 133781;
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

V_sb1 = priceBasketSpreadOption_SecondOrderBoundaryApprox(K,r,T,e,a,S0,sigma,rho)
V_HybMMICUB1 = priceBasketSpreadOption_HybMMICUB(K,r,T,e,a,S0,sigma,rho,1e-6)
V_mc1 = priceBasketSpreadOption_MonteCarlo(K,r,T,e,a,S0,sigma,rho,1e7,3.3e3)


%% Numerical Experiments from Pricing and Hedging Asian Basket Spread Options
K = 15;
T = 1;

e = [1 -1 -1];
a = [1 1 1];
S0 = [100 24 46];
sigma = [0.4 0.22 0.3];
rho = [1 0.17 0.91; 0.17 1 0.41; 0.91 0.41 1];
V_sb2 = priceBasketSpreadOption_SecondOrderBoundaryApprox(K,r,T,e,a,S0,sigma,rho)
V_HybMMICUB2 = priceBasketSpreadOption_HybMMICUB(K,r,T,e,a,S0,sigma,rho,1e-5)
V_mc2 = priceBasketSpreadOption_MonteCarlo(K,r,T,e,a,S0,sigma,rho,1e7,3.3e3)


