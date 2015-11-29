%% Testing influence of epsilon in HybMMICUB Method
% Author: Daniel Waelchli
% November 2015

format long;

str_now = char(date);
diary(['data/output_', str_now, '.txt']);


K = 10;
r = 0.05;
T = 1;

%% Market Params
[e_0,a_0,S0_0,sigma_0,rho_0] = generateMarketParams(4,2,'charged','constant',0.4,'constant',0.3);
[e_1,a_1,S0_1,sigma_1,rho_1] = generateMarketParams(20,5,'descending','constant',0.4,'alternating',0.3);

M=10;
epsilon = 10.^-(1:M);
V0 = zeros(1,M);
V1 = zeros(1,M);
t0 = zeros(1,M);
t1 = zeros(1,M);
for i=1:M
tic;
V0(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,epsilon(i));
t0(i) = toc;
tic;
V1(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,epsilon(i));
t1(i) = toc;
end

relV0 = abs(V0(1:M-1)-V0(2:M))./V0(1:M-1);
relV1 = abs(V1(1:M-1)-V1(2:M))./V1(1:M-1);

relt0 = abs(t0(1:M-1)-t0(2:M))./t0(1:M-1);
relt1 = abs(t1(1:M-1)-t1(2:M))./t1(1:M-1);

plot(1:M,t0,1:M,t1)
semilogy(1:M-1,relV0,1:M-1,relV1)
