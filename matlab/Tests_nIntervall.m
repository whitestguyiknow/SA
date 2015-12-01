%% Testing influence of nIntervall in HybMMICUB2 Method
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

%% Test
M=4;
N = 10.^(1:M);
V20 = zeros(1,M);
V21 = zeros(1,M);
V22 = zeros(1,M);
t20 = zeros(1,M);
t21 = zeros(1,M);
t22 = zeros(1,M);
for i=1:M
tic;
V20(i) = priceBasketSpreadOption_HybMMICUB2(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,N(i));
t20(i) = toc;
tic;
V21(i) = priceBasketSpreadOption_HybMMICUB2(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,N(i));
t21(i) = toc;
tic;
V22(i) = priceBasketSpreadOption_HybMMICUB2(K,r,T,e_2,a_2,S0_2,sigma_2,rho_2,N(i));
t22(i) = toc;
end

relV20 = abs(V20(1:M-1)-V20(2:M))./V20(1:M-1);
relV21 = abs(V21(1:M-1)-V21(2:M))./V21(1:M-1);
relV22 = abs(V22(1:M-1)-V22(2:M))./V22(1:M-1);

figure(1)
plot(1:M,t20,1:M,t21,1:M,t22)
title('Testing influence of nIntervall in HybMMICUB2 Method: Runtime')
figure(2)
semilogy(1:M-1,relV20,1:M-1,relV21,1:M-1,relV22)
title('Testing influence of epsilon in HybMMICUB2 Method: Relative Value Change')
figure(3)
plot(1:M,V20)
title('Testing influence of epsilon in HybMMICUB2 Method: V20')
figure(4)
plot(1:M,V21)
title('Testing influence of epsilon in HybMMICUB2 Method: V21')
figure(5)
plot(1:M,V22)
title('Testing influence of epsilon in HybMMICUB2 Method: V22')
