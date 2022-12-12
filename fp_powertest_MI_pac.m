% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/';

%subjects with good classification accuracy 
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

%%
isb = 1;
for isub = subs
    
    %load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIRIN);
    
    %align with head model
    eeglabp = fileparts(which('eeglab.m'));
    EEG = pop_dipfit_settings( EEG, 'hdmfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_vol.mat'), ...
        'coordformat','MNI','mrifile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_mri.mat'),...
        'chanfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','elec', 'standard_1005.elc'),...
        'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG.nbchan] );
    
    %compute lead field
    EEG = pop_leadfield(EEG, 'sourcemodel',fullfile(eeglabp,'functions','supportfiles','head_modelColin27_5003_Standard-10-5-Cap339.mat'), ...
        'sourcemodel2mni',[0 -24 -45 0 0 -1.5708 1000 1000 1000] ,'downsample',1);
    
    %% epoching
    
    epoch = [1 3]; %from 1 sec after stimulus onset to 3 sec after stimulus onset
    EEG = eeg_checkset( EEG );
    EEG_left = pop_epoch( EEG, {'1'}, epoch, 'epochinfo', 'yes');
    EEG_right = pop_epoch( EEG, {'2'}, epoch, 'epochinfo', 'yes');
    
    EEG_left = pop_roi_activity(EEG_left, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    EEG_right = pop_roi_activity(EEG_right, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    
    pop_saveset(EEG_left,'filename',['roi_' sub '_left'],'filepath',DIRIN) 
    pop_saveset(EEG_right,'filename',['roi_' sub '_right'],'filepath',DIRIN) 
    
    
end



