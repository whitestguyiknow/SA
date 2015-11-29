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
eps = 1e-6;
u = linspace(eps,1-eps,M);

% cases for u
u0=0.3;
u1=0.7;

% market params
[e_0,a_0,S0_0,sigma_0,rho_0] = generateMarketParams(4,2,'charged','constant',0.4,'constant',0.3);
[e_1,a_1,S0_1,sigma_1,rho_1] = generateMarketParams(20,5,'descending','constant',0.4,'alternating',0.3);


f0 = zeros(1,M);
fz = fx(u0,K,r,T,e_0,a_0,S0_0,sigma_0,rho_0);
for i=1:M
    f0(i)=fz(x(i));
end

f1 = zeros(1,M);
fz = fx(u0,K,r,T,e,a,S0,sigma,rho);
for i=1:M
    f1(i)=fz(x(i));
end

f2 = zeros(1,M);
fz = fx(u1,K,r,T,e_0,a_0,S0_0,sigma_0,rho_0);
for i=1:M
    f2(i)=fz(x(i));
end

f3 = zeros(1,M);
fz = fx(u1,K,r,T,e_1,a_1,S0_1,sigma_1,rho_1);
for i=1:M
    f3(i)=fz(x(i));
end

figure(1)
hold on;
plot(x,f0,'b')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(x,f1,'r')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(x,f2,'--b')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(x,f3,'--r')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
grid on;
%xlim([0 1]);
%ylim([-10 10]);
xlabel('x','FontName','Cambria','FontSize',14);
ylab=ylabel('f(x)','FontName','Cambria','FontSize',14,'rot',0);
set(ylab, 'position', [-5.6, 1050, 0],'horizontalAlignment', 'left');
title('EVALUATION F(X)','FontName','Cambria','FontSize',16);
hold off;


I1_0 = zeros(1,M);
fI = integrand(1,K, r, T, e_0, a_0, S0_0, sigma_0, rho_0,eps);
for i=1:M
    I1_0(i)= fI(u(i));
end

I1_1 = zeros(1,M);
fI = integrand(1,K, r, T, e_1, a_1, S0_1, sigma_1, rho_1,eps);
for i=1:M
    I1_1(i)= fI(u(i));
end

I2_0 = zeros(1,M);
fI = integrand(2,K, r, T, e_0, a_0, S0_0, sigma_0, rho_0,eps);
for i=1:M
    I2_0(i)= fI(u(i));
end

I2_1 = zeros(1,M);
fI = integrand(2,K, r, T, e_1, a_1, S0_1, sigma_1, rho_1,eps);
for i=1:M
    I2_1(i)= fI(u(i));
end

figure(2)
hold on;
grid on;
plot(u,I1_0,'b')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(u,I1_1,'r')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(u,I2_0,'--b')
%text(0.015,3.5, 'Peak \pi (3.0 Flops/Cycle)', 'Color', 'k','FontSize',14)
plot(u,I2_1,'--r')
hold off;

