function p = fp_get_p_pac(pac)
% Get p-values by comparing true pac score agaist null distribution.
% pac has dimensions 2chan x 2chan x nshuffles+1 (first entry is true
% value) 
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

nshuf = size(pac,2)-1; 
p = sum(squeeze(pac(1)) < pac(2:end))./nshuf;