function signal_roi = fp_dimred(signal_sensor,D,A)

ipip = 1;

[n_sensors, l_epoch, n_trials] = size(signal_sensor);
ndim = size(A,2);

signal_roi = [];

%loop over regions
for aroi = 1:D.nroi
    
    clear A_ signal_source    
    A_ = A(:, :,D.ind_roi_cortex{aroi},:);
    A_ = A_(:,:,D.sub_ind_roi_region{aroi},:);
    
    %number of voxels at the current roi
    nvoxroi(aroi) = size(A_,3);
    A2{aroi} = reshape(A_, [n_sensors, ndim*nvoxroi(aroi)]);
    
    %project sensor signal to voxels at the current roi (aroi)
    signal_source = A2{aroi}' * signal_sensor(:,:);
    
    %zscoring
    signal_source = zscore(signal_source')'; %%%%%leave this out?????
    
    %do PCA
    clear signal_roi_ S
    [signal_roi_,S,~] = svd(double(signal_source(:,:))','econ');
    
    %fixed number of pcs
    npcs(aroi) = ipip;
    
    %bring signal_roi to the shape of npcs x l_epoch x n_trials
    signal_roi = cat(1,signal_roi,reshape((signal_roi_(:,1:npcs(aroi)))',[],l_epoch,n_trials));
    
end