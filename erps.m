DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r

%%
% figure; figone(30,40)

for isb = 1:26
    sub = ['vp' num2str(subs(isb))];
    EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIRIN);
    
    epoch = [-1 4]; %from 1 sec after stimulus onset to 3 sec after stimulus onset
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {'2'}, epoch, 'epochinfo', 'yes');    
    pop_saveset(EEG,'filename',['right_test' num2str(isb)],'filepath','~/Desktop/')
    
%     EEG = pop_epoch( EEG, {'1'}, epoch, 'epochinfo', 'yes');    
%     pop_saveset(EEG,'filename',['test' num2str(isb)],'filepath','~/Desktop/')
    
%     EEG = pop_loadset('filename',['test' num2str(isb) '.set'],'filepath','~/Desktop/EEG_left/');
%     subplot(5,5,isb)
%     pop_timtopo( EEG,[-1000 3000],nan)
%     ylim([-2 2])
end

%%
figure;figone(30,40)

for isb = 1:25

    EEG = pop_loadset('filename',['test' num2str(isb) '.set'],'filepath','~/Desktop/');
    subplot(5,5,isb)
    pop_newtimef( EEG, 1, 41, [-100  3000], [0] , 'topovec', 41, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'FCz', 'baseline',[0], 'freqs', [13 30], 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1, 'winsize', 100);
%     pop_newtimef( EEG, 1, 10, [-100  3000], [0] , 'topovec', 10, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'C4', 'baseline',[0], 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1, 'winsize', 100);
%     pop_newtimef( EEG, 1, 41, [-100  3000], [0] , 'topovec', 41, 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'caption', 'FCz', 'baseline',[0], 'plotitc' , 'off', 'plotphase', 'off', 'padratio', 1, 'winsize', 100);

end



