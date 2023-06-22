function fp_submit_pacrde_nsg

isbs = [12 21:23 25];

for isb = isbs
    fprintf(['starting sub ' num2str(isb) '\n'])
    job{isb} = batch(@fp_pac_test_clus_nsg,0,{isb},'Pool',1);
end

for isb =isbs
    fprintf(['waiting for sub ' num2str(isb) '\n'])
    wait(job{isb})
end