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
% varagin{1}:   number of Monte Carlo paths per asset (only for method 'MC')
% varargin{2}:  number of steps per path (only for method 'MC')


%% Assertion
M = length(e);
assert(M == length(a), 'number of weights incorrect');
assert(all(abs(e)==1), 'all signs in the spread must be +1 or -1');
assert(M == length(S0), 'number of initial values incorrect');
assert(M == length(sigma), 'number of variances incorrect');
assert(issymmetric(rho), 'correlation matrix not symmetric');
assert(all(eig(rho)>=zeros(M,1)), 'correlation matrix not positive-semidefinite');


%% Computation
switch method
    case 'SB'
        disp('Price basked-spread option with second order boundary approximation');
        
        I = (e==1);
        N = sum(I);
        
        S0 = S0.*a;
        u0 = log(S0(I))+(r-0.5*sigma(I).^2)*T;                              % (5)
        uk = log(S0(~I))+(r-0.5*sigma(~I).^2)*T;                            % (5)
        v0 = sigma(I)*sqrt(T);
        vk = sigma(~I)*sqrt(T);                                             % (5)
        
        % Approximate H0(T)
        vH0 = sqrt(v0*rho(I)*v0')/N;
        uH0 = log(sum(exp(u0+0.5*v0.^2)))-0.5*vH0^2;
        
        sigma_10 = sum(rho(~I,I).*repmat(v0,M-N,1),2)/(N*vH0);
        sigma_11 = rho(~I,~I);
        
        sigma_11_inv  = sigma_11\eye(M-N);
        sigma_11_sqrt = sqrt(sigma_11); %or choletsky decomposition?????
        
        % Proposition 1
        sigma_xy = 1-sigma_10'*sigma_11_inv*sigma_10;
        sigma_xy_sqrt = sqrt(sigma_xy);
        
        % Proposition 3
        R   = sum(exp(uk));
        dx  = exp(uk').*vk'/(vH0*(R+K));
        d2x = (vk'*vk*exp(repmat(uk',1,M-N)+repmat(uk,M-N,1))/(vH0*(R+K)^2)...
                +repmat(vk.^2.*exp(uk)/(vH0*(R+K)),M-N,1));  
        c   = -(log(R+K)-uH0)/(vH0*sigma_xy_sqrt);                          % (13)
        d   = 1/sigma_xy_sqrt*(sigma_11_inv*sigma_10-dx);                   % (14)
        E   = -0.5/sigma_xy_sqrt*d2x;                                       % (15)
        
        % proposition 4
        F    =  sigma_11_sqrt*E*sigma_11_sqrt;                                          % (29)
        d_N1 =  sigma_11_sqrt*d;                                                        % (28)
        c_N1 = c+trace(F);                                                              % (27)
        c0   = c+trace(F)+vH0*sigma_xy_sqrt+vH0*sigma_10'*d+vH0^2*sigma_10'*E*sigma_10; % (23)
        d0   =  sigma_11_sqrt*(d+2*vH0*E*sigma_10);                                     % (24)
        ck   = c+trace(F)+vk'.*(sigma_11*d)+vk'.^2.*diag(sigma_11*E*sigma_11);          % (25)
        dk   = sigma_11_sqrt*(repmat(d,1,M-N)+2*repmat(vk,M-N,1).*(E*sigma_11));        % (26) Matrix with dks in columns
        
%         % Proposition 5
%         theta = @(v) (sqrt(1+v'*v)-1)/(v'*v*sqrt(1+v'*v));
%         psi   = @(v) 1/(1+v'*v);
%         
%         p = psi(d0);
%         V = exp(-r*T+uH0+0.5*vH0^2)*(normcdf(c0*sqrt(p)))+...
%             p^1.5*(p*c0^2-1)*d0'*F*d0*normpdf(c0*p)+...
%             c0*p^1.5*normpdf(c0*sqrt(p))*(2*trace(F^2)-4*(1-trace(F))
            
        
    case 'HybMMICUB'
        disp('Price basked-spread option with hybrid moment matching method with ICUB');
        V=0;
        
    case 'MC'
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
            
            v(i) = max(sum((S(:,end)'.*e.*a))-K,0);
            fprintf('%d standard error\n',std(v))
            
        end
        
    otherwise
        disp('This method is not available..');
        
end


V = exp(-r*T)*mean(v);
end

function [I] = I(c,d)
    I = 
end
