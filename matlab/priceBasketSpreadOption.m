function [V] = priceBasketSpreadOption(K, r, T, e, a, S0, sigma, rho, method, varargin)
%% Pricing Function for Basket-Spread options
% Author: Daniel Wälchli
% November 2015

%% Parameter:
% K:            strike price
% r:            annual interest rate
% T:            time to maturity in years
% e:            sign in the spread
% a:            weights given to asset
% S0:           initial value of asset
% sigma:        volatility
% rho:          correlation
% method:       method applied for pricing
% varagin{1}:   number of Monte Carlo paths per asset (only MC simulation)
% varargin{2}:  number of steps per path (only MC simulation)


%% Assertion 
M = length(e);
assert(M == length(a), 'number of weights incorrect');
assert(M == length(S0), 'number of initial values incorrect');
assert(M == length(sigma), 'number of variances incorrect');
assert(issymmetric(rho), 'correlation matrix not symmetric');
assert(all(eig(rho)>=zeros(M,1)), 'correlation matrix not positive-semidefinite');


%% Computation
switch method 
    case 'HybMMICUB'
        disp('Price basked-spread option with hybrid moment matching method with ICUB');
        V=0;
        
    case 'SB'
        disp('Price basked-spread option with second order boundary approximation');
        V=0;
        
    otherwise
        disp('Price basked-spread option with Monte Carlo simulation..');
        assert(nargin==11, 'incorrect number of arguments');
        nSamples = varargin{1};
        nSteps = varargin{2};
        
        mu = zeros(1,M);
        dt = T/nSteps;
        
        v = zeros(1,nSamples);
        
        percentage = floor(nSamples/10);
        counter = 0;
        
        for i = 1:nSamples
            
            if(mod(i,percentage)==0)
                counter = counter + 10;
                fprintf('%d%% completed..\n',counter)
            end
            
            S = zeros(M,nSteps+1);
            S(:,1) = S0';
            B = mvnrnd(mu, rho*dt, nSteps)';
            for j=1:nSteps
                S(:,j+1) = S(:,j)+S(:,j)*r*dt+S(:,j).*sigma'.*B(:,j)+...
                    0.5*S(:,j).*sigma'.^2.*(B(:,j).^2-dt);
            end
            
            v(i) = sum((S(:,end)'.*e.*a))-K;
            

            
        end
        
        fprintf('%d standard error\n',std(v))
        V = exp(-r*T)*mean(v);
end

