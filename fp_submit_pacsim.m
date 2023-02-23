cd ~/matlab/fp/PAC/
fp_addpath_pac
cd ~/matlab/fp/PAC/
nit = 100;
varIp = [1 2 3 10 11 12 13];

for ip = [1 2 3 10]
    mgsub({},@fp_eval_pac_sim,{ip},'qsub_opts',['-l h_vmem=4G -t 1-' num2str(nit) ]) %' -q 2jobs'
    pause(60*2)
end