
DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';
DIRIN1 = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/';

for isub = subs
    
    sub = ['vp' num2str(isub)]
    
    EEG_left = pop_loadset('filename',['roi_' sub '_left.set'],'filepath',DIRIN) ;
    EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    EEG_left = pop_roi_activity(EEG_left, 'leadfield',EEG_left.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    EEG_right = pop_roi_activity(EEG_right, 'leadfield',EEG_left.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);

    pop_saveset(EEG_left,'filename',['roi1_' sub '_left'],'filepath',DIRIN1)
    pop_saveset(EEG_right,'filename',['roi1_' sub '_right'],'filepath',DIRIN1)
end