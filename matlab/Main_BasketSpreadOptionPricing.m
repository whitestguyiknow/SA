%% Basekt Spread Option Pricing
% Author: Daniel Wälchli
% November 2015


seed = 1337;
rng(seed);

K = 15;
r = 0.05;
T = 1;

e = [1 -1 -1];
a = [1 1 1];
S0 = [100 24 46];
sigma = [0.4 0.22 0.3];
rho = [1 0.17 0.91; 0.17 1 0.41; 0.91 0.41 1];


V_sb = priceBasketSpreadOption(K,r,T,e,a,S0,sigma,rho,'SB')

%V_mc = priceBasketSpreadOption(K,r,T,e,a,S0,sigma,rho,'MC',1e6,3e3);


