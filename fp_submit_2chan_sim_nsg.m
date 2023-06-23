function fp_submit_2chan_sim_nsg
% Function that submits the two-channel PAC simulation to several cores. Designed for
% running on the NSG cluster of the UCSD. 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

nit = 100; %number of iterations
seeds = (1:nit)*17;  %select seeds for random processes for every iteration

for iit = 1:nit
    fprintf(['starting job ' num2str(iit) '\n'])
    %submit one iteration per core 
    job{iit} = batch(@fp_2chan_sim,0,{seeds(iit),iit},'Pool',1);
end

%Ensure that this script is running until all jobs are done
for iit =1:nit
    fprintf(['waiting for job ' num2str(iit) '\n'])
    wait(job{nit})
end
