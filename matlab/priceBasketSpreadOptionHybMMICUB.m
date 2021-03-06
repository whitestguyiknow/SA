function [V,T] = priceBasketSpreadOptionHybMMICUB(K, r, T, e, a, S0, sigma, rho, eps)
%% Pricing Function for Basket-Spread options using Hybrid Moment Matching associated with ICUB
%% Based on Pricing and hedging Asian basket spread options (G.Deelstra, A.Petkovic, M.Vanmaele; 2010)
% Using adaptive Simpson's rule

% Author: Daniel Waelchli
% November 2015

% The numbers in the brackets refer to according equations in my semester
% thesis.

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
tic;
I = (e==1);

S0 = S0.*a;
F0 = S0*exp(r*T);

% Hybrid moment matching
m11 = sum(F0(I));                                                               % (38)
m21 = sum(sum(F0(I)'*F0(I).*exp(rho(I,I).*(sigma(I)'*sigma(I))*T)));            % (39)

u1 = 2*log(m11)-0.5*log(m21);
var1 = log(m21)-2*log(m11);

m12 = sum(F0(~I));                                                              % (38)
m22 = sum(sum(F0(~I)'*F0(~I).*exp(rho(~I,~I).*(sigma(~I)'*sigma(~I))*T)));      % (39)

u2 = 2*log(m12)-0.5*log(m22);
var2 = log(m22)-2*log(m12);

crm = sum(sum(F0(I)'*F0(~I).*exp(0.5*T*(2*rho(I,~I).*(sigma(I)'*sigma(~I)))))); % (40)
p = (log(crm)-u1-u2-0.5*var1-0.5*var2)/sqrt(var1*var2);

% Proposition 5
gamma1 = (exp(u1)*sqrt(var1)+exp(u2)*sqrt(var2)*p)/sqrt(exp(2*u1)*var1+exp(2*u2)*var2+2*p*exp(u1+u2)*sqrt(var1)*sqrt(var2));    % (43)
gamma2 = (exp(u1)*sqrt(var1)*p+exp(u2)*sqrt(var2))/sqrt(exp(2*u1)*var1+exp(2*u2)*var2+2*p*exp(u1+u2)*sqrt(var1)*sqrt(var2));    % (43)
Y1 = sqrt(var1)*sqrt(1-gamma1^2);
Y2 = -sqrt(var2)*sqrt(1-gamma2^2);
A1 = @(u) gamma1*sqrt(var1)*norminv(u,0,1);
A2 = @(u) gamma2*sqrt(var2)*norminv(u,0,1);

dx=1e-12;

fsic = @(x) fsicu(x,u1,A1,Y1,u2,A2,Y2,K,0.5);
[FSICKN] = adaptive_simpson_rule(fsic,dx,1-dx,eps,simpsons_rule(fsic,dx,1-dx),1);
%fprintf('Integration intervalls used in FSICK: %d\n',FSICKN(2))
ifsic_1 = @(x) integrandFsicu_1(x,u1,A1,Y1,u2,A2,Y2,K,0.5);
ifsic_2 = @(x) integrandFsicu_2(x,u1,A1,Y1,u2,A2,Y2,K,0.5);

[IN1] = adaptive_simpson_rule(ifsic_1,dx,1-dx,eps,simpsons_rule(ifsic_1,dx,1-dx),1);
%fprintf('Integration intervalls used in I1: %d\n',IN1(2))
[IN2] = adaptive_simpson_rule(ifsic_2,dx,1-dx,eps,simpsons_rule(ifsic_2,dx,1-dx),1);
%fprintf('Integration intervalls used in I2: %d\n',IN2(2))

V=IN1(1)-IN2(1)-K*(1-FSICKN(1));                                                % (41)
T=toc;
end

function [F] = fsicu(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    % Find FSU(K)
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);                                                            % (42)
    F = normcdf(F);
end

function [I1] = integrandFsicu_1(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    % Integral in (15) for i=1
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);
    I1 = exp(u1+A1(u)+0.5*Y1^2)*normcdf(Y1-F);
end

function [I2] = integrandFsicu_2(u,u1,A1,Y1,u2,A2,Y2,K,x0)
    % Integral in (41) for i=2
    f = @(x) exp(u1+A1(u)+Y1*x)-exp(u2+A2(u)+Y2*x)-K;
    F = fzero(f,x0);                                                            % (42)
    I2 = exp(u2+A2(u)+0.5*Y2^2)*normcdf(Y2-F);
end

function [I] = simpsons_rule(f,a,b)
    % Simpson's Rule
    c = (a+b)/2;
    h = (b-a)/6;
    I = h*(f(a)+4.0*f(c)+f(b));
end

function [IN] = adaptive_simpson_rule(f,a,b,eps,base,N)
    % Recursive Adavtibe Simpson's Rule
    c = (a+b)/2;
    l = simpsons_rule(f,a,c);
    r = simpsons_rule(f,c,b);
    if (abs(l + r - base) <= 15*eps)
        IN = [l+r+(l+r-base)/15.0, N];
    else
        IN = adaptive_simpson_rule(f,a,c,eps/2.0,l,N+1) + adaptive_simpson_rule(f,c,b,eps/2.0,r,N+1);
    end
end