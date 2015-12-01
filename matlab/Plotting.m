%% Basekt Spread Option Pricing
%% Plots for report

% Author: Daniel Waelchli
% November 2015

K = 10;
r = 0.05;
T = 1;

% grids
M = 500;
x = linspace(-5,5,M);
dx = 1e-12;
u = linspace(dx,1-dx,M);

% cases for u
u0=0.3;
u1=0.7;

% market params
[e_0,a_0,S0_0,sigma_0,rho_0] = generateMarketParams(4,2,'charged','constant',0.4,'constant',0.3);
[e_1,a_1,S0_1,sigma_1,rho_1] = generateMarketParams(20,5,'descending','constant',0.4,'alternating',0.3);
[e_2,a_2,S0_2,sigma_2,rho_2] = generateMarketParams(10,2,'charged','constant',0.4,'descending',0.3);

%% evaluation of f(x)
f0_0 = zeros(1,M);
fx0_0 = fx(u0,K,r,T,e_0,a_0,S0_0,sigma_0,rho_0);
f0_1 = zeros(1,M);
fx0_1 = fx(u0,K,r,T,e_1,a_1,S0_1,sigma_1,rho_1);
f1_0 = zeros(1,M);
fx1_0 = fx(u1,K,r,T,e_0,a_0,S0_0,sigma_0,rho_0);
f0_2 = zeros(1,M);
fx0_2 = fx(u0,K,r,T,e_2,a_2,S0_2,sigma_2,rho_2);
f1_1 = zeros(1,M);
fx1_1 = fx(u1,K,r,T,e_1,a_1,S0_1,sigma_1,rho_1);
f1_2 = zeros(1,M);
fx1_2 = fx(u1,K,r,T,e_2,a_2,S0_2,sigma_2,rho_2);
for i=1:M
    f0_0(i)=fx0_1(x(i));
    f0_1(i)=fx0_1(x(i));
    f0_2(i)=fx0_2(x(i));
    f1_0(i)=fx1_0(x(i));
    f1_1(i)=fx1_1(x(i));
    f1_2(i)=fx1_2(x(i));
end

figure(1)
hold on;
plot(x,f0_0,'b',x,f1_0,'--b',x,f0_1,'r',x,f1_1,'--r',x,f0_2,'g',x,f1_2,'--g')
grid on;
xlabel('x','FontName','Cambria','FontSize',14);
ylab=ylabel('f(x)','FontName','Cambria','FontSize',14,'rot',0);
set(ylab,'horizontalAlignment', 'left');
title('EVALUATION F(X,U=0.3) AND F(X,U=0.7)','FontName','Cambria','FontSize',16);
legend({'scenario 1, u0','scenario 1, u1','scenario 2, u0',...
    'scenario 2, u1','scenario 3, u10','scenario 3, u1'},'FontSize',12,...
    'Location','southeast')
hold off;

%% evaluation of integrands
I1_0 = zeros(1,M);
fI1_0 = integrand(1,K, r, T, e_0, a_0, S0_0, sigma_0, rho_0,eps);
I1_1 = zeros(1,M);
fI1_1 = integrand(1,K, r, T, e_1, a_1, S0_1, sigma_1, rho_1,eps);
I1_2 = zeros(1,M);
fI1_2 = integrand(1,K, r, T, e_2, a_2, S0_2, sigma_2, rho_2,eps);
I2_0 = zeros(1,M);
fI2_0 = integrand(2,K, r, T, e_0, a_0, S0_0, sigma_0, rho_0,eps);
I2_1 = zeros(1,M);
fI2_1 = integrand(2,K, r, T, e_1, a_1, S0_1, sigma_1, rho_1,eps);
I2_2 = zeros(1,M);
fI2_2 = integrand(2,K, r, T, e_2, a_2, S0_2, sigma_2, rho_2,eps);
for i=1:M
    I1_0(i)= fI1_0(u(i));
    I1_1(i)= fI1_1(u(i));
    I1_2(i)= fI1_2(u(i));
    I2_0(i)= fI2_0(u(i));
    I2_1(i)= fI2_1(u(i));
    I2_2(i)= fI2_2(u(i));
end

figure(2)
hold on;
plot(u,I1_0,'b',u,I2_0,'--b',u,I1_1,'r',u,I2_1,'--r',u,I1_2,'g',u,I2_1,'--g')
grid on;
xlabel('x','FontName','Cambria','FontSize',14);
ylab=ylabel('I_i(x)','FontName','Cambria','FontSize',14,'rot',0);
set(ylab,'horizontalAlignment', 'left');
title('Integrands','FontName','Cambria','FontSize',16);
legend({'scenario 1, I1','scenario 1, I2','scenario 2, I1',...
    'scenario 2, I2','scenario 3, I1','scenario 3, I2'},'FontSize',12,...
    'Location','northwest')
hold off;
