
function fp_pac_test_clus_nsg(isb)

DIRIN = './data/';
DIROUT = './bispecs/';

addpath(genpath('./'))

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
sub = ['vp' num2str(subs(isb))];

rois = [43,44,49,50]; %Regions of interest: pericalcarine l/r, precentral l/r
nshuf = 5000+1;

%%
tic

% load preprocessed EEG
%load([DIRIN sub '_left.mat']);     
load([DIRIN sub '_right.mat']);

%set parameters
f_nyq = fs/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least dr times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz

%select data of rois and time window of 0-2 sec post stim 
d = data(rois,101:end,:);

%calculate bispectra
bos = nan(f_lm,f_nyq,4,4,nshuf);
bas = nan(f_lm,f_nyq,4,4,nshuf);

%loop over freq combinations (in Hz)
for ifl = 1:f_lm
    for ifh = ifl*dr:f_nyq
        if (ifh+ifl<f_nyq)

            filt.low = ifl;
            filt.high = ifh;            
            [bos(ifl,ifh,:,:,:), bas(ifl,ifh,:,:,:)] = fp_pac_bispec_uni(d,fs,filt, nshuf);
            
        end
    end
end

t=toc;
save([DIROUT sub '_PAC_shuf_right.mat'],'bos','bas','t','-v7.3')




