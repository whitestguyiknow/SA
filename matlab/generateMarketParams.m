function [e,a,S0,sigma,rho] = generateMarketParams(N,nP,type_S0,type_sigma,s,type_rho,r)
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
% type_S0:          "charged" or "descending"          
% type_sigma:       "constant" or "descending"        
% type_rho:         "constant" or "descending" 

%% Assertion
assert(N > nP, 'choose less assets with positive sign (N>nP)');
assert(strcmp(type_S0,'charged')|strcmp(type_S0,'descending'),...
    'type_S0 must be of type "weighted" or "descneding"');
assert(strcmp(type_sigma,'constant')|strcmp(type_sigma,'descending'),...
    'type_sigma must be of type "constant" or "descending"');
assert(strcmp(type_rho,'constant')|strcmp(type_rho,'alternating')...
    |strcmp(type_rho,'descending'),... 
    'type_rho must be of type "constant","alternating" or "descending"');
assert(abs(r)<1,'abs(r) must be smaller 1');

%% Create Market Params
e=[ones(1,nP), -ones(1,N-nP)];
a=ones(1,N);

switch type_S0
    case 'charged'
        S0 = [10*(N+1), 10*ones(1,N-1)];
    case 'descending'
        S0 = 10*(N:-1:1);   
end

switch type_sigma
    case 'constant'
        sigma = s*ones(1,N);
    case 'descending'
        sigma = linspace(s,0.1,N);
end

switch type_rho
    case 'constant'
        rho = r*ones(N,N);
        rho(eye(size(rho))~=0)=1; 
    case 'alternating'
        rho = repmat(1:N,N,1)+repmat((1:N)',1,N);
        rho(mod(rho,2)==0)=r;
        rho(mod(rho,2)==1)=r;
        rho(eye(size(rho))~=0)=1;
    case 'descending'
        rho = repmat(1:N,N,1)+repmat((1:N)',1,N);
        rho = ones(N,N)./rho;
        rho(eye(size(rho))~=0)=1;
end


end

