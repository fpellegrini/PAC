function p = fp_control_harmonics(sig,fs,fl,fh,p,q,nshuf)


%%
[bl, al] = butter(3, (fl+[-1 1])/fs*2);
[bh, ah] = butter(3, (fh+[-1 1])/fs*2);

xl = filtfilt(bl, al, sig);
xh = filtfilt(bh, ah, sig);

%% true plv 

for ii = 1:size(xl,2)
    plv_ep(ii) = Phase_Locking(xl(:,ii),xh(:,ii),p,q);
end
plv = mean(plv_ep);


%% shuffling 

for ishuf = 1:nshuf 
    
    ind = randperm(size(xl,2))';
    xls = xl(:,ind);
    
    for ii = 1:size(xl,2)
        plv_ep_s(ii) = Phase_Locking(xls(:,ii),xh(:,ii),p,q);
    end
    plv_s(ishuf) = mean(plv_ep_s);
 
end

%%

p = sum(plv_s>plv)/(nshuf);


