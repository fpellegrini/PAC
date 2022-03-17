function signal_shuf = fp_shuffle_shab(W,signal_unmixed)

[n_sensors, l_epoch, n_trials] = size(signal_unmixed);

for ichan = 1:n_sensors
    inds = randperm(n_trials,n_trials);
    s_shuf(ichan,:,:) = signal_unmixed(ichan,:,inds);
end

%back to original space 
signal_shuf = W\s_shuf(:,:);
signal_shuf = reshape(signal_shuf,n_sensors,l_epoch, n_trials);