function [V] = priceBasketSpreadOption_HybMMICUB(K, r, T, e, a, S0, sigma, rho)
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
disp('Price basked-spread option with second order boundary approximation');



end



