function [e,a,S0,sigma,rho] = generateMarketParams(N,nP,type_S0,type_sigma,type_rho)
% This function generates market parameters sign e, weights a,
% initial asset values S0, volatility of assets sigma and correlation
% matrix rho.
% Output parameters are needed for the performance study of the basket
% pricing methods (SOB & HybMMICUB)

% Author: Daniel Waelchli
% November 2015

%% Parameters:
% N:                number of assets            
% nP:               number of assets with positive sign
% type_S0:          
% type_sigma:            
% type_rho:            

%% Assertion
assert(N > nP, 'choose less assets with positive sign (N>nP)');

end

