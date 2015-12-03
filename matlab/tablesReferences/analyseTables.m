function [r] = analyseTables(type,rowI,rowMC,varargin)
% Function to analyse results (Table 4-7) in 
% Pricing and hedging Asian basket spread options (G. Deelstra, A. Petkovic, M. Vanmaele; 2009)

nVarargs = length(varargin);
nD1 = length(rowI);
nD2 = size(varargin{1},2);
diff = zeros(nD1,nD2);
for i=1:nVarargs
    tab = varargin{i};
    switch type
        case 'L1'
            diff = diff + abs(tab(rowI,:)-repmat(tab(rowMC,:),nD1,1));
        case 'L2'
            diff = diff + (tab(rowI,:)-repmat(tab(rowMC,:),nD1,1)).^2;
    end
end

r = sum(diff,2);

end

