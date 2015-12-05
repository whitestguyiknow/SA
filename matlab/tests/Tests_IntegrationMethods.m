%% Testing influence of epsilon and nIntervalls in HybMMICUB Method
%% Using Simpson's rule and rectangular method 
% Author: Daniel Waelchli
% November 2015

format long;
addpath('..');

K = 10;
r = 0.05;
T = 1;

%% Market Params
[e_0,a_0,S0_0,sigma_0,rho_0] = generateMarketParams(4,2,'charged','constant',0.4,'constant',0.3);
[e_1,a_1,S0_1,sigma_1,rho_1] = generateMarketParams(20,5,'descending','constant',0.4,'alternating',0.3);
[e_2,a_2,S0_2,sigma_2,rho_2] = generateMarketParams(100,1,'charged','descending',0.4,'constant',0.3);

%% Test epsilon
M=7;
epsilon = 10.^-(1:M);
V10 = zeros(1,M);
V11 = zeros(1,M);
V12 = zeros(1,M);
t10 = zeros(1,M);
t11 = zeros(1,M);
t12 = zeros(1,M);
for i=1:M
[V10(i),t10(i)] = priceBasketSpreadOptionHybMMICUB(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,epsilon(i));
[V11(i),t11(i)] = priceBasketSpreadOptionHybMMICUB(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,epsilon(i));
[V12(i),t12(i)] = priceBasketSpreadOptionHybMMICUB(K,r,T,e_2,a_2,S0_2,sigma_2,rho_2,epsilon(i));
end

relV10 = abs(V10(1:M-1)-V10(2:M))./V10(1:M-1);
relV11 = abs(V11(1:M-1)-V11(2:M))./V11(1:M-1);
relV12 = abs(V12(1:M-1)-V12(2:M))./V12(1:M-1);

figure(1)
semilogx(epsilon,t10,1:M,t11,1:M,t12)
title('Testing influence of epsilon in HybMMICUB Method: Runtime')
figure(2)
loglog(epsilon(1:end-1),relV10,1:M-1,relV11,1:M-1,relV12)
title('Testing influence of epsilon in HybMMICUB Method: Relative Value Change')
figure(3)
semilogx(epsilon,V10,epsilon,V11,epsilon,V12)
title('Testing influence of epsilon in HybMMICUB Method: V10, V11 and V12')

%% Test nIntervalls
M=6;
N = 10.^(1:M);
V20 = zeros(1,M);
V21 = zeros(1,M);
V22 = zeros(1,M);
t20 = zeros(1,M);
t21 = zeros(1,M);
t22 = zeros(1,M);
for i=1:M
[V20(i),t20(i)] = priceBasketSpreadOptionHybMMICUB2(K,r,T,e_0,a_0,S0_0,sigma_0,rho_0,N(i));
[V21(i),t21(i)] = priceBasketSpreadOptionHybMMICUB2(K,r,T,e_1,a_1,S0_1,sigma_1,rho_1,N(i));
[V22(i),t22(i)] = priceBasketSpreadOptionHybMMICUB2(K,r,T,e_2,a_2,S0_2,sigma_2,rho_2,N(i));
end

relV20 = abs(V20(1:M-1)-V20(2:M))./V20(1:M-1);
relV21 = abs(V21(1:M-1)-V21(2:M))./V21(1:M-1);
relV22 = abs(V22(1:M-1)-V22(2:M))./V22(1:M-1);

figure(4)
semilogx(N,t20,1:M,t21,1:M,t22)
title('Testing influence of nIntervall in HybMMICUB2 Method: Runtime')
figure(5)
loglog(N(1:end-1),relV20,1:M-1,relV21,1:M-1,relV22)
title('Testing influence of epsilon in HybMMICUB2 Method: Relative Value Change')
figure(6)
semilogx(N,V20,N,V21,N,V22)
title('Testing influence of epsilon in HybMMICUB2 Method: V20, V21 and V22')
figure(7)
semilogy(t10(2:end),relV10,'-+b',t20(2:end),relV20,'-+r',t11(2:end),relV11,'-^b',...
    t21(2:end),relV20,'-^r',t12(2:end),relV12,'-*b',t22(2:end),relV22,'-*r')
title('Testing relative value change vs run-time (varying eps and nIntervalls)')
ylab=ylabel('Rel. Change','FontName','Cambria','FontSize',14,'rot',0);
set(ylab,'horizontalAlignment', 'left','position', [-5.75, 2.2, 0]);
xlabel('Runtime [s]','FontName','Cambria','FontSize',14);