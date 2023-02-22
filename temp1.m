
DIRIN = '~/Dropbox/Franziska/MotorImag/Data_eyes/';
DIRIN1 = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE_eyes/';
if ~exist(DIRIN1); mkdir(DIRIN1); end 

for isub = subs
    
    sub = ['vp' num2str(isub)]
    EEG_closed = pop_loadset('filename',['roi_' sub '_closed.set'],'filepath',DIRIN) ;
    
%     EEG_left = pop_loadset('filename',['roi_' sub '_left.set'],'filepath',DIRIN) ;
%     EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    EEG_closed = pop_roi_activity(EEG_closed, 'leadfield',EEG_closed.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
%     EEG_right = pop_roi_activity(EEG_right, 'leadfield',EEG_left.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);

    pop_saveset(EEG_closed,'filename',['roi1_' sub '_closed'],'filepath',DIRIN1,'savemode','twofiles')
%     pop_saveset(EEG_right,'filename',['roi1_' sub '_right'],'filepath',DIRIN1,'savemode','twofiles')
end