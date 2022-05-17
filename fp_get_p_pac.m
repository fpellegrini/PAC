function p = fp_get_p_pac(pac)
% pac has dimensions 2chan x 2chan x nshuffles 

nshuf = size(pac,2)-1; 
p = sum(squeeze(pac(1)) < pac(2:end))./nshuf;