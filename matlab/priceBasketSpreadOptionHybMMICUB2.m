function [V] = priceBasketSpreadOptionHybMMICUB2(K, r, T, e, a, S0, sigma, rho, nIntervall)
%% Pricing Function for Basket-Spread options using Hybrid Moment Matching associated with ICUB
%% Based on Pricing and hedging Asian basket spread options (G.Deelstra, A.Petkovic, M.Vanmaele; 2010)
% Using Trapezoidal Rule
% Dismissed Implementation

% Author: Daniel Waelchli
% November 2015

%% Parameters:
% K:            strike price
% r:            annual interest rate
% T:            time to maturity in years
% e:            sign in the spread
% a:            weights given to asset
% S0:           initial value of asset
% sigma:        volatility
% rho:          correlation
% nIntervall:   number of intervalls used in (0,1) for trapezoidal rule 

%% Assertion
N = length(e);
assert(N == length(a), 'number of weights incorrect');
assert(all(abs(e)==1), 'all signs in the spread must be +1 or -1');
assert(all(size(S0)==[1,N]), 'S0 must be of dimension 1xN');
assert(all(size(sigma)==[1,N]), 'sigma must be of dimension 1xN');
assert(all(size(sigma)==[1,N]), 'rho must be of dimension 1xN');
assert(issymmetric(rho), 'correlation matrix not symmetric');
assert(all(eig(rho)>=zeros(N,1)), 'correlation matrix not positive-semidefinite');


%% Computation
disp('Price basked-spread option with Hybrid Moment Matching Method associated with ICUB');

I = (e==1);
M = sum(I);

S0 = S0.*a;
F0 = S0*exp(r*T);

% Hybrid moment matching
m11 = sum(F0(I));
m21 = sum(sum(F0(I)'*F0(I).*exp(rho(I,I).*(sigma(I)'*sigma(I))*T)));

u1 = 2*log(m11)-0.5*log(m21);
var1 = log(m21)-2*log(m11);

m12 = sum(F0(~I));
m22 = sum(sum(F0(~I)'*F0(~I).*exp(rho(~I,~I).*(sigma(~I)'*sigma(~I))*T)));

u2 = 2*log(m12)-0.5*log(m22);
var2 = log(m22)-2*log(m12);

crm = sum(sum(F0(I)'*F0(~I).*exp(0.5*T*(2*rho(I,~I).*(sigma(I)'*sigma(~I)))))); %repmat(sigma(I).^2',1,sum(~I))+repmat(sigma(~I).^2,sum(I),1)
p = (log(crm)-u1-u2-0.5*var1-0.5*var2)/sqrt(var1*var2);

% Proposition 5
gamma1 = (exp(u1)*sqrt(var1)+exp(u2)*sqrt(var2)*p)/sqrt(exp(2*u1)*var1+exp(2*u2)*var2+2*p*exp(u1+u2)*sqrt(var1)*sqrt(var2));
gamma2 = (exp(u1)*sqrt(var1)*p+exp(u2)*sqrt(var2))/sqrt(exp(2*u1)*var1+exp(2*u2)*var2+2*p*exp(u1+u2)*sqrt(var1)*sqrt(var2));
Y1 = sqrt(var1)*sqrt(1-gamma1^2);
Y2 = -sqrt(var2)*sqrt(1-gamma2^2);
A1 = @(u) gamma1*sqrt(var1)*norminv(u,0,1);
A2 = @(u) gamma2*sqrt(var2)*norminv(u,0,1);

dx=1e-12;
u=linspace(dx,1-dx,nIntervall);
fu = zeros(1,nIntervall);
for i=1:nIntervall
    fu(i)=fsicu(u(i),u1,A1,Y1,u2,A2,Y2,K,0.5);
end
FSICKN = sum(normcdf(fu))/nIntervall;
IN1 = sum(exp(u1+A1(u)+0.5*Y1^2).*normcdf(Y1-fu))/nIntervall;
IN2 = sum(exp(u2+A2(u)+0.5*Y2^2).*normcdf(Y2-fu))/nIntervall;

V=IN1-IN2-K*(1-FSICKN);
end

function [F] = fsicu(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    % Find FSU(K)
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);
end
