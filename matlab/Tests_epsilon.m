%% Testing influence of epsilon in HybMMICUB Method
% Author: Daniel Waelchli
% November 2015

format long;

K = 10;
r = 0.05;
T = 1;

%% Market Params
[e_0,a_0,S0_0,sigma_0,rho_0] = generateMarketParams(4,2,'charged','constant',0.4,'constant',0.3);
[e_1,a_1,S0_1,sigma_1,rho_1] = generateMarketParams(20,5,'descending','constant',0.4,'alternating',0.3);
[e_2,a_2,S0_2,sigma_2,rho_2] = generateMarketParams(100,1,'charged','descending',0.4,'constant',0.3);

M=6;
epsilon = 10.^-(1:M);
V0 = zeros(1,M);
V1 = zeros(1,M);
V2 = zeros(1,M);
t0 = zeros(1,M);
t1 = zeros(1,M);
t2 = zeros(1,M);
for i=1:M
tic;
V0(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,epsilon(i));
t0(i) = toc;
tic;
V1(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,epsilon(i));
t1(i) = toc;
tic;
V2(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_2,a_2,S0_2,sigma_2,rho_2,epsilon(i));
t2(i) = toc;
end

relV0 = abs(V0(1:M-1)-V0(2:M))./V0(1:M-1);
relV1 = abs(V1(1:M-1)-V1(2:M))./V1(1:M-1);
relV2 = abs(V2(1:M-1)-V2(2:M))./V2(1:M-1);

relt0 = abs(t0(1:M-1)-t0(2:M))./t0(1:M-1);
relt1 = abs(t1(1:M-1)-t1(2:M))./t1(1:M-1);
relt2 = abs(t2(1:M-1)-t2(2:M))./t2(1:M-1);

figure(1)
plot(1:M,t0,1:M,t1,1:M,t2)
figure(2)
semilogy(1:M-1,relV0,1:M-1,relV1,1:M-1,relV2)
figure(3)
plot(1:M,V0)
figure(4)
plot(1:M,V1)
figure(5)
plot(1:M,V2)
