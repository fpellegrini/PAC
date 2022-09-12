cd ~/matlab/fp/PAC/
fp_addpath_pac
cd ~/matlab/fp/PAC/
nit = 100;

for ip = [1:5]% 7 10:13]
    mgsub({},@fp_eval_pac_sim,{ip},'qsub_opts',['-l h_vmem=16G -t 1-' num2str(nit) ]) %' -q 2jobs'
    pause(60*3)
end