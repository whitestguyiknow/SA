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

%% Test
M=6;
epsilon = 10.^-(1:M);
V10 = zeros(1,M);
V11 = zeros(1,M);
V12 = zeros(1,M);
t10 = zeros(1,M);
t11 = zeros(1,M);
t12 = zeros(1,M);
for i=1:M
tic;
V10(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,epsilon(i));
t10(i) = toc;
tic;
V11(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,epsilon(i));
t11(i) = toc;
tic;
V12(i) = priceBasketSpreadOption_HybMMICUB(K,r,T,e_2,a_2,S0_2,sigma_2,rho_2,epsilon(i));
t12(i) = toc;
end

relV10 = abs(V10(1:M-1)-V10(2:M))./V10(1:M-1);
relV11 = abs(V11(1:M-1)-V11(2:M))./V11(1:M-1);
relV12 = abs(V12(1:M-1)-V12(2:M))./V12(1:M-1);

figure(1)
plot(1:M,t10,1:M,t11,1:M,t12)
title('Testing influence of epsilon in HybMMICUB Method: Runtime')
figure(2)
semilogy(1:M-1,relV10,1:M-1,relV11,1:M-1,relV12)
title('Testing influence of epsilon in HybMMICUB Method: Relative Value Change')
figure(3)
plot(1:M,V10)
title('Testing influence of epsilon in HybMMICUB Method: V10')
figure(4)
plot(1:M,V11)
title('Testing influence of epsilon in HybMMICUB Method: V11')
figure(5)
plot(1:M,V12)
title('Testing influence of epsilon in HybMMICUB Method: V12')
