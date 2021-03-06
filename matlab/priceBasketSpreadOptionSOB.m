function [V,T] = priceBasketSpreadOptionSOB(K, r, T, e, a, S0, sigma, rho)
%% Pricing Function for Basket-Spread options using Second Order boundary Approximation
%% Based on Multi-asset Spread Option Pricing and Hedging (S.Deng, M.Li, J. Zhou; 2007)

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

%% Return Values:
% V:            price
% T:            computation time

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
tic;
I = (e==1);
M = sum(I);

S0 = S0.*a;
u0 = log(S0(I))+(r-0.5*sigma(I).^2)*T;                                                                                
uk = log(S0(~I))+(r-0.5*sigma(~I).^2)*T;                                        
v0 = sigma(I)*sqrt(T);      
vk = sigma(~I)*sqrt(T);                                                         

% Approximate H0(T)
vH0 = sqrt(v0*rho(I,I)*v0')/M;                                                  % (7)  
uH0 = log(sum(exp(u0+0.5*v0.^2)))-0.5*vH0^2;                                    % (6)  

sigma_10 = sum(rho(~I,I).*repmat(v0,N-M,1),2)/(M*vH0);
sigma_11 = rho(~I,~I);

sigma_11_inv_sigma_10 = sigma_11\sigma_10;
[sigma_11_EV, sigma_11_Eval] = eig(sigma_11); 
sigma_11_sqrt = sigma_11_EV*sqrt(sigma_11_Eval)*sigma_11_EV; 

% Proposition 1
sigma_xy = 1-sigma_10'*sigma_11_inv_sigma_10;                                   % (9)
sigma_xy_sqrt = sqrt(sigma_xy);

% Proposition 3
R   = sum(exp(uk));                                                             % (15)
dx  = exp(uk').*vk'/(vH0*(R+K));                                                % (13)
d2x = -vk'*vk*exp(repmat(uk',1,N-M)+repmat(uk,N-M,1))/(vH0*(R+K)^2)...
    +repmat(vk.^2.*exp(uk),N-M,1)/(vH0*(R+K));                                  % (14)
c   = -(log(R+K)-uH0)/(vH0*sigma_xy_sqrt);                                      % (17)
d   = 1/sigma_xy_sqrt*(sigma_11_inv_sigma_10-dx);                               % (18)
E   = -0.5/sigma_xy_sqrt*d2x;                                                   % (19)

% Proposition 4
F    = sigma_11_sqrt*E*sigma_11_sqrt;                                           % (32)
d_N1 = sigma_11_sqrt*d;                                                         % (31)
c_N1 = c+trace(F);                                                              % (30)
c0   = c+trace(F)+vH0*sigma_xy_sqrt+vH0*sigma_10'*d+vH0^2*sigma_10'*E*sigma_10; % (26)
d0   = sigma_11_sqrt*(d+2*vH0*E*sigma_10);                                      % (27)
ck   = c+trace(F)+vk'.*(sigma_11*d)+vk'.^2.*diag(sigma_11*E*sigma_11);          % (28)
dk   = sigma_11_sqrt*(repmat(d,1,N-M)+2*repmat(vk,N-M,1).*(E*sigma_11));        % (29) 

c = [c0; ck; c_N1];
d = [d0 dk d_N1]; 

F2 = F*F;
psi = 1./(1+dot(d,d))';                                                                                             % (33)
dFd = dot((d'*F)',d)';

% Proposition 5 
J0V = normcdf(c.*sqrt(psi));                                                                                        % (34)   
J1V = psi.^1.5.*(psi.*c.^2-1).*dFd.*normpdf(c.*sqrt(psi));                                                          % (35)
J2V = c.*psi.^1.5.*normpdf(c.*sqrt(psi)).*(2*trace(F2)-4*(1-trace(F))*(psi-psi.^2).*dFd+...
    (psi.^2).*(9+(2-3*c.^2).*psi-c.^2.*(4-c.^2).*psi.^2).*dFd.^2-2*psi.*(5+(1-2*c.^2).*psi).*dot((d'*F2)',d)');     % (36)
                                                                                                                                         
% Proposition 4 (price)
Ik = J0V+J1V-0.5*J2V;                                                      
V = exp(-r*T+uH0+0.5*vH0^2)*Ik(1)-sum(exp(-r*T+uk+0.5*vk.^2)'.*Ik(2:end-1))...
    -K*exp(-r*T)*Ik(end);                                                       % (10)

T = toc;
end



