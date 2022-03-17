function A = fp_get_lcmv(signal_sensor,L)

cCS = cov(signal_sensor(:,:)');
reg = 0.05*trace(cCS)/length(cCS);
Cr = cCS + reg*eye(size(cCS,1));

[~, A] = lcmv(Cr, L, struct('alpha', 0, 'onedim', 0));
A = permute(A,[1, 3, 2]);