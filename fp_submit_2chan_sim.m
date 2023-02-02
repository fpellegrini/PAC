cd ~/matlab/fp/PAC/
fp_addpath_pac
cd ~/matlab/fp/PAC/
nit = 10;

mgsub({},@fp_2chan_sim,{},'qsub_opts',['-l h_vmem=4G -t 1-' num2str(nit) ])
