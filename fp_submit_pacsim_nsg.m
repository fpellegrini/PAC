function fp_submit_pacsim_nsg

nit = 100;
seeds = (1:nit)*17;
ip=1; %[1 2 3 10]

for iit = 1:nit
    fprintf(['starting job ' num2str(iit) '\n'])
    job{iit} = batch(@fp_eval_pac_sim,0,{ip,seeds(iit),iit},'Pool',1);
end

for iit =1:nit
    fprintf(['waiting for job ' num2str(iit) '\n'])
    wait(job{nit})
end
