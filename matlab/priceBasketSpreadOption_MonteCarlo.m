function [V] = priceBasketSpreadOption_MonteCarlo(K, r, T, e, a, S0, sigma, rho, nSamples, nSteps)
%% Pricing Function for Basket-Spread options using Monte Carlo Simulation and Milstein Method
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

v = zeros(1,nSamples);

percentage = floor(nSamples/10);
counter = 0;

for i = 1:nSamples
    
%     if(mod(i,percentage)==0)
%         counter = counter + 10;
%         fprintf('%d%% completed..\n',counter)
%     end
    
    S = zeros(N,nSteps+1);
    S(:,1) = S0';
    B = mvnrnd(mu, rho*dt, nSteps)';
    for j=1:nSteps
        S(:,j+1) = S(:,j)+S(:,j)*r*dt+S(:,j).*sigma'.*B(:,j)+...
            0.5*S(:,j).*sigma'.^2.*(B(:,j).^2-dt);
    end
    
    v(i) = max(sum((S(:,end)'.*e.*a))-K,0);
    
end

fprintf('%d standard error\n',std(v))
V = exp(-r*T)*mean(v);

end

