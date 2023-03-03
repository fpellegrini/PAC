
function fp_pac_control_harmonics

DIRIN = './';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
% rois = [50, 46]; %Regions of interest:  precentral r, postcentral r
rois = [49, 46]; %Regions of interest:  precentral l, postcentral r

%FOIs
ifl = 5;
ifh = 33;
filt.low = ifl;
filt.high = ifh;

iband1 = 10 +[-2 2];
iband2 = 30 +[-2 2];

nshuf = 1;

%%
tic

%prevent array jobs to start at exactly the same time
for isb = 1:numel(subs)
    %%
    isub = subs(isb)
    
    % load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi1_' sub '_right.set'],'filepath',DIRIN) ;
    fs = EEG_left.srate;
    frqs = sfreqs(fs, fs);
    
    %select data of rois
    d_l = EEG_left.roi.source_roi_data(rois,:,:);
    
    
    for ishift = 1: size(d_l,3)
        %%
        
        dl1 = d_l;
        if ishift == 1
            dl1(2,:,:) = d_l(2,:,[ishift:end]);
        else
            dl1(2,:,:) = d_l(2,:,[ishift:end 1:ishift-1]);
        end
        
        %MIM low
        npcs = [1 1];
        filt.band_inds = find(frqs >= iband1(1) & frqs <= iband1(2));
        MIMl(isb,:,:,ishift) = fp_shuffle_MIM(dl1,npcs, fs, filt,nshuf);
        
        %MIM high
        npcs = [1 1];
        filt.band_inds = find(frqs >= iband2(1) & frqs <= iband2(2));
        MIMh(isb,:,:,ishift) = fp_shuffle_MIM(dl1,npcs, fs, filt,nshuf);
        
        %calculate PAC
        [~, bals] = fp_pac_bispec_uni(dl1,EEG_left.srate,filt, nshuf+1);
        pac(isb,:,:,ishift)=bals(:,:,1);
        
    end
    t=toc;
    
end

%%

figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    bar(squeeze(MIMl(isb,1,2,:)))
end

figure
bar(squeeze(mean(MIMl(:,1,2,:),1)))

figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    bar(squeeze(MIMh(isb,1,2,:)))
end

figure
bar(squeeze(mean(MIMh(:,1,2,:),1)))


figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    bar(squeeze(pac(isb,1,2,:)))
end

figure
bar(squeeze(mean(pac(:,1,2,:),1)))


figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    bar(squeeze(pac(isb,2,1,:)))
end

figure
bar(squeeze(mean(pac(:,2,1,:),1)))


