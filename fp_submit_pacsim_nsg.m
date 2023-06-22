function fp_submit_pacsim_nsg
%Function that submits main PAC simulation to several cores. Designed for
%running on the NSG cluster of the UCSD. 

nit = 100; %number of iterations
seeds = (1:nit)*17; %select seeds for random processes for every iteration
ip=[1 2 3 10]; %experimental setups defined in fp_get_params_pac

for iit = 1:nit
    fprintf(['starting job ' num2str(iit) '\n'])
    %submit one iteration per core 
    job{iit} = batch(@fp_eval_pac_sim,0,{ip,seeds(iit),iit},'Pool',1);
end

%Ensure that this script is running until all jobs are done
for iit =1:nit
    fprintf(['waiting for job ' num2str(iit) '\n'])
    wait(job{nit})
end