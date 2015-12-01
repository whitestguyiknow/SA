%% Runtime plots of HybMMICUB Method and SOB Method 
% Author: Daniel Waelchli
% November 2015

M = 8;
N = 2.^(1:M);
epsilon = 10^-5;

K = 10;
r = 0.05;
T = 1;

tH = zeros(2,M);
tS = zeros(2,M);
for i=1:M
[e_C,a_C,S0_C,sigma_C,rho_C] = generateMarketParams(N(i),N(i)/2,'charged','constant',0.4,'constant',0.3);
[e_DA,a_DA,S0_DA,sigma_DA,rho_DA] = generateMarketParams(N(i),N(i)/2,'charged','descending',0.4,'alternating',0.3);
tic
priceBasketSpreadOption_HybMMICUB(K,r,T,e_C,a_C,S0_C,sigma_C,rho_C,epsilon);
tH(1,i) = toc;
tic
priceBasketSpreadOption_HybMMICUB(K,r,T,e_DA,a_DA,S0_DA,sigma_DA,rho_DA,epsilon);
tH(2,i) = toc;
tic
priceBasketSpreadOption_SOB(K,r,T,e_C,a_C,S0_C,sigma_C,rho_C);
tS(1,i) = toc;
tic
priceBasketSpreadOption_SOB(K,r,T,e_DA,a_DA,S0_DA,sigma_DA,rho_DA);
tS(2,i) = toc;
end

figure(1)
plot(N,tH)
figure(2)
plot(N,tS)