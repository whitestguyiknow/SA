echo start...
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_SigmaDescending
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_S0Descending
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_S0Descending_60pct
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_RhoDescending
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_RhoDescending_60pct
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_RhoAlternating
bsub -W 08:00 matlab -nodesktop -nosplash -r Experiment_RhoAlternating_60pct
echo finished!
