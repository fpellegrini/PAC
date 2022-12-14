cd ~/matlab/fp/PAC/
fp_addpath_pac
cd ~/matlab/fp/PAC/
nsubs = 26;

mgsub({},@fp_pac_test_clus100,{},'qsub_opts',['-l h_vmem=16G -t 1-' num2str(nsubs) ]) %' -q 2jobs'
    