function [pac, p] = fp_get_all_pac(X, fs, filt, n_shuffles)

[nchan, ~, n_trials_s] = size(X);

% use efficient implementation for bispec shuffling
% ishuf == 1 is the true bispec
[u1,u2] = fp_pac_bispec_uni(X,fs,filt, n_shuffles);
pac(:,4) =  max([squeeze(u1(1,2,:)),squeeze(u1(2,1,:))]');
pac(:,5) =  max([squeeze(u2(1,2,:)),squeeze(u2(2,1,:))]');

%preparation for shabahzi
[W,~] = runica(X(:,:),'verbose','off');
signal_unmixed = W*X(:,:);
signal_unmixed = reshape(signal_unmixed,nchan, [], n_trials_s);

%shuffling for null distributions
for ishuf = 1:n_shuffles
%     fprintf(['Shuffle '  num2str(ishuf) '\n'])
    
    %first shuffle contains true pac
    if ishuf == 1
        ind = 1:n_trials_s;
    else
        ind = randperm(n_trials_s)';
    end
    X_shuf = cat(1,X(1,:,:),X(2,:,ind));
    
    %standard MI
    u = fp_pac_standard(X_shuf, filt.low,filt.high, fs );
    pac(ishuf,1) = max([u(1,2),u(2,1)]);
    
    %ortho MI
    [signal_ortho, ~, ~, ~] = symmetric_orthogonalise(X_shuf(:,:)', 1);
    signal_ortho = reshape(signal_ortho',nchan,[],n_trials_s);
    u = fp_pac_standard(signal_ortho, filt.low, filt.high, fs);
    pac(ishuf,2) = max([u(1,2),u(2,1)]);
    
    %shahbazi MI
    if ishuf == 1 
        X_shuf_sha = reshape(W\signal_unmixed(:,:),nchan,[], n_trials_s);
    else
        X_shuf_sha = fp_shuffle_shab(W,signal_unmixed);
    end
    u = fp_pac_standard(X_shuf_sha, filt.low, filt.high, fs);
    pac(ishuf,3) = max([u(1,2),u(2,1)]);
    
end

p(1) = fp_get_p_pac(pac(:,1)');%standard MI
p(2) = fp_get_p_pac(pac(:,2)');%ortho
p(3) = fp_get_p_pac(pac(:,3)');%shahbazi
p(4) = fp_get_p_pac(pac(:,4)');%bispec_orig
p(5) = fp_get_p_pac(pac(:,5)');%bispec_anti

