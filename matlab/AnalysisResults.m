%% Analysis of results
% Author: Daniel Wälchli
% November 2015

% Pricing and hedging Asian basket spread options (G. Deelstra, A. Petkovic, M. Vanmaele; 2009)
% Basket Spread Options (Table 4-7)

table4 = csvread('data/PricingHedgingAsianBasketSpreadOpt_Tab4.csv');
table5 = csvread('data/PricingHedgingAsianBasketSpreadOpt_Tab5.csv');
table6 = csvread('data/PricingHedgingAsianBasketSpreadOpt_Tab6.csv');
table7 = csvread('data/PricingHedgingAsianBasketSpreadOpt_Tab7.csv');

r1_L1 = analyseTables('L1', 2:5, 6, table4, table5, table6, table7)
r1_L2 = analyseTables('L2', 2:5, 6, table4, table5, table6, table7)

% Multi-asset Spread Option Pricing and Hedging (S. Deng, M. Li, J. Zhou; 2007)
% Prices of spread options on 20, 50 and 150 assets (Table 3 Panel A, B & C)

table3A = csvread('data/MultiAssetSpreadOptionPricingHedging_Tab3A.csv');
table3B = csvread('data/MultiAssetSpreadOptionPricingHedging_Tab3B.csv');
table3C = csvread('data/MultiAssetSpreadOptionPricingHedging_Tab3C.csv');

r2_L1 = analyseTables('L1', 1:3, 4, table3A(2:5,:), table3B(2:5,:), table3C(2:5,:),...
        table3A(5:8,:), table3B(5:8,:), table3B(5:8,:))
r2_L2 = analyseTables('L2', 1:3, 4, table3A(2:5,:), table3B(2:5,:), table3C(2:5,:),...
        table3A(5:8,:), table3B(5:8,:), table3B(5:8,:))