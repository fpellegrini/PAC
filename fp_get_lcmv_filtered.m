function A = fp_get_lcmv_filtered(signal_sensor,L,filt)
%construct LCMV filter based on signals that have been filtered in specific
%frequency bands 

a_all = poly([roots(filt.aband_low);roots(filt.aband_high)]);
b_all = conv(filt.bband_low,filt.bband_high);
signal_sensor = filtfilt(b_all, a_all, signal_sensor(:,:)');  
  
cCS = cov(signal_sensor);
reg = 0.05*trace(cCS)/length(cCS);
Cr = cCS + reg*eye(size(cCS,1));

[~, A] = lcmv(Cr, L, struct('alpha', 0, 'onedim', 0));
A = permute(A,[1, 3, 2]);