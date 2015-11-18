function [V] = priceBasketSpreadOption_HybMMICUB(K, r, T, e, a, S0, sigma, rho, eps)
%% Pricing Function for Basket-Spread options using Hybrid Moment Matching associated with ICUB
%% Based on Pricing and hedging Asian basket spread options (G.Deelstra, A.Petkovic, M.Vanmaele; 2010)
% Author: Daniel Wälchli
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
% eps:          max error on intervall in Adaprive Simpson's Integration

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

fsic = @(x) fsicu(x,u1,A1,Y1,u2,A2,Y2,K,0.5);
FSICK = adaptive_simpson_rule(fsic,0.001,0.999,eps,simpsons_rule(fsic,0.00001,0.99999),1);

ifsic_1 = @(x) integrandFsicu_1(x,u1,A1,Y1,u2,A2,Y2,K,0.5);
ifsic_2 = @(x) integrandFsicu_2(x,u1,A1,Y1,u2,A2,Y2,K,0.5);
dx=1e-7;
I1 = adaptive_simpson_rule(ifsic_1,dx,1-dx,eps,simpsons_rule(ifsic_1,dx,1-dx),1);
I2 = adaptive_simpson_rule(ifsic_2,dx,1-dx,eps,simpsons_rule(ifsic_2,dx,1-dx),1);

V=I1-I2-K*(1-FSICK);
end

function [F] = fsicu(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);
    F = normcdf(F);
end

function [I1] = integrandFsicu_1(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);
    I1 = exp(u1+A1(u)+0.5*Y1^2)*normcdf(Y1-F);
end

function [I2] = integrandFsicu_2(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);
    I2 = exp(u2+A2(u)+0.5*Y2^2)*normcdf(Y2-F);
end

function [I] = simpson(f,a,b,N)
    % Numerical Integration with Simpson's Rule
    if(mod(N,2))
        N = N+1;
    end
    dx = (b-a)/(N-1);
    x = linspace(a,b,N);
    F = zeros(1,N);
    F(2:end-1) = arrayfun(f,x(2:end-1));
    F(1) = F(2);
    F(end) = F(end-1);
    %plot(x,F)
    I = dx/3*(4*sum(F(2:2:end-1))+2*sum(F(3:2:end-3))+F(1)+F(end));
end

function [I] = simpsons_rule(f,a,b)
    c = (a+b)/2;
    h = (b-a)/6;
    I = h*(f(a)+4.0*f(c)+f(b));
end

function [I] = adaptive_simpson_rule(f,a,b,eps,base,N)
    c = (a+b)/2;
    l = simpsons_rule(f,a,c);
    r = simpsons_rule(f,c,b);
    if (abs(l + r - base) <= 15*eps)
        I = [l + r + (l + r - base)/15.0, N];
    else
        I = adaptive_simpson_rule(f,a,c,eps/2.0,l,N+1) + adaptive_simpson_rule(f,c,b,eps/2.0,r,N+1);
    end
end
