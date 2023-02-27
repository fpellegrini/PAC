function fp_submit_2chan_sim_nsg

nit = 100;
seeds = (1:nit)*17; 

for iit = 1:nit
    fprintf(['starting job ' num2str(iit) '\n'])
    job{iit} = batch(@fp_2chan_sim,0,{seeds(iit),iit},'Pool',1);
end

for iit =1:nit
    fprintf(['waiting for job ' num2str(iit) '\n'])
    wait(job{nit})
end
