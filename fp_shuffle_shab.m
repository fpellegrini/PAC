function signal_shuf = fp_shuffle_shab(W,signal_unmixed)
%shuffle independent componends and project them back to original space 

[n_sensors, l_epoch, n_trials] = size(signal_unmixed);

for ichan = 1:n_sensors
    inds = randperm(n_trials);
    s_shuf(ichan,:,:) = signal_unmixed(ichan,:,inds);
end

%back to original space 
signal_shuf = W\s_shuf(:,:);
signal_shuf = reshape(signal_shuf,n_sensors,l_epoch, n_trials);