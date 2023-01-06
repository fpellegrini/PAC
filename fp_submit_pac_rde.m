cd ~/matlab/fp/PAC/
fp_addpath_pac
cd ~/matlab/fp/PAC/
nsubs = 26;
seeds = randi(1000,1,nsubs); %seeds for the random generator in the single jobs
mgsub({},@fp_pac_test_clus,{seeds},'qsub_opts',['-l -t 1-' num2str(nsubs) ]) %' -q 2jobs'
    