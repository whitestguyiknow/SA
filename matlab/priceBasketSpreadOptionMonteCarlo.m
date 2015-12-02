function [V] = priceBasketSpreadOptionMonteCarlo(K, r, T, e, a, S0, sigma, rho, nSamples, nSteps,M)
%% Pricing Function for Basket-Spread options using Monte Carlo Simulation and Milstein Method
% Author: Daniel W?aelchli
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
% method:       method applied for pricing
% nSamples:     number of Monte Carlo paths per asset
% nSteps:       number of steps per path


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
disp('Price basked-spread option with Monte Carlo simulation..');
mu = zeros(1,N);
dt = T/nSteps;

rdt = r*dt;

V = zeros(M,length(K));
for i=1:M
S = zeros(N*nSamples,nSteps+1);
S(:,1) = repmat(S0',nSamples,1);
sig = repmat(sigma',nSamples,1);
W = mvnrnd(mu, rho*dt, nSamples*nSteps)';
B = reshape(W,[N*nSamples,nSteps]);

for j=1:nSteps
    S(:,j+1) = S(:,j)+S(:,j)*rdt+S(:,j).*sig.*B(:,j);
end

nK = length(K);
ea = repmat(e'.*a',nSamples,1);
V(i,:) = exp(-r*T)*mean(max(repmat(S(:,end).*ea,1,nK)-repmat(K,N*nSamples,1),0));
end
mean(V)
end

