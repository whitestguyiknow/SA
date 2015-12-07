Folder Path Listing & Short File Description
Daniel Wälchli, December 2015


+---matlab
	-priceBasketSpreadOptionSOB.m 								// self explanatory
	-priceBasketSpreadOptinHybMMICUB.m 							// ..
	-priceBasketSpreadOptionMonteCarlo.m 						// .. 
	-Main 														// Script to reproduce results from [1]
	-Main2														// Script2 to reproduce results from [2]
	-generateMarketParams.m 									// helper function to generate parameters (i.e. correlation matrices), mostly needed in experiments)
	-printRun													// helper function to store results from my experiments which I ran on ETH Euler Cluster
	+---tests
		-Tests_IntegrationMethods.m 							// Script to test integration methods used in HybMMICUB
		-priceBasektSpreadOptionHybMMICUB2.m 					// dismissed implementation of HybMMICUB (using rectangle integration)
	+---tablesReferences
		-AnalyseResults.m 										// Script to analyze tables in [1] and [2]
		-analyseTables.m 										// helper function used in script above
		-"tablefiles" 											// table data from [1] and [2]
		-... 													// ""
	+---plots
		-Plotting.m 											// Script to generate plots included in my report
		-integrand.m 											// helper function to plot integrands from HybMMICUB, code copied from priceBasketSpreadOptinHybMMICUB.m 	
		-fx.m 													// helper function to plot f(x) from HybMMICUB, code copied from priceBasketSpreadOptinHybMMICUB.m 
		+---private
			-"miscellaneous files" 								// downloaded files, used to export plots as pdfs
		+---export
			--"miscellaneous files" 							// downloaded files, used to export plots as pdfs
	+experiments
		-experiments.sh 										// shell script to run my experiments on ETH Euler cluster
		-Experiment_SigmaDescending.m 							// Scripts including my experiments
		-... 													// ""
		+---data
			-tables 											// all results from experiments importet in one .m file, needed for analysis


[1] S.J. Deng, M. Li, J. Zhou. "Multi-asset Spread Option Pricing and Hedging" (2007)
[2] G. Deelstra, A. Petkovic, M. Vanmaele. "Pricing and hedging Asian basket spread options" (2009)