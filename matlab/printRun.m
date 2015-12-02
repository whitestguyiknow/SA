function [] = printRun(filename,N,nP,type_S0,type_sigma,s,type_rho,rho,r,K,T,seed,nPaths,nSteps,M,eps,varargin)
%% Writing Experiments to file

% Author: Daniel W?aelchli
% November 2015

%% Parameters:
% N:                number of assets            
% nP:               number of assets with positive sign
% type_S0:          "charged" or "descending"          
% type_sigma:       "constant" or "descending"        
% type_rho:         "constant" or "descending"
% r:                interest rate
% K:                strike array
% T:                maturity
% seed:             seed
% nSamples:         number of Monte Carlo paths per asset
% nSteps:           number of steps per path
% M:                number of MC repetitions
% varargin:         2dim array of calculated prices & runtime

%% Assertion
l = length(varargin);
assert(mod(l,3)==0,'number of varargin must be a multiple of 3 (requesting method, prices and timings)');

%% Print Params
fileID = fopen(filename,'w');
fprintf(fileID,'%1s %13.0f\r\n' ,'seed:',seed);
fprintf(fileID,'%1s %11.0f\r\n' ,'nPaths:',nPaths);
fprintf(fileID,'%1s %11.0f\r\n' ,'nSteps:',nSteps);
fprintf(fileID,'%1s %16.0f\r\n' ,'M:',M);
fprintf(fileID,'%1s %10.2e\r\n' ,'epsilon:',eps);
fprintf(fileID,'%1s %16.2f\r\n' ,'r:',r);
fprintf(fileID,'%1s %16.2f\r\n' ,'T:',T);
fprintf(fileID,'%1s %16.0f\r\n' ,'N:',N);
fprintf(fileID,'%1s %15.0f\r\n' ,'nP:',nP);
fprintf(fileID,'%1s %2s\r\n' ,'typeS0:',type_S0);
fprintf(fileID,'%1s %2s\r\n' ,'typeSigma:',type_sigma);
fprintf(fileID,'%1s %12.2f\r\n' ,'sigma:',s);
fprintf(fileID,'%1s %2s\r\n' ,'typeRho:',type_rho);
fprintf(fileID,'%1s %14.2f\r\n' ,'rho:',rho);
fprintf(fileID,'%1s','K:');
fprintf(fileID,'%16.2f' , K);
fprintf(fileID,'\n');

%% Print Prices and Runtimes
for i=1:3:l

fprintf(fileID,'%1s %2s\r\n' ,'method:',varargin{i});
fprintf(fileID,'%1s','V:');
fprintf(fileID,'%16.8f' , varargin{i+1});
fprintf(fileID,'\n');
fprintf(fileID,'%1s','t:');
fprintf(fileID,'%16.4f' , varargin{i+2});
fprintf(fileID,'\n');

end

fclose(fileID);
end

