function ratio = fp_diag_ratio(pac)

nroi = size(pac,1);
diag_inds = find(diag( ones(nroi,1) ) );
offdiag_inds = setdiff(1:numel(pac),diag_inds);
ratio = mean(pac(diag_inds))/mean(pac(offdiag_inds)); 