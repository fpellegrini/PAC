DIRFIG = '~/Desktop/EEG_right/fig/37-40/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%%
for isb = 1:26
    
    EEG = pop_loadset('filename',['right_test' num2str(isb) '.set'],'filepath','~/Desktop/EEG_right/');
    
    oz = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'Oz'));
    c3 = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'C3'));
    c4 = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'C4'));
    
    data = EEG.data([oz c3 c4],100:300,:); %check that it is the same for all subjects!
    
    [nchan,np,nep]=size(data);
    
    fs = EEG.srate;
    high = [37 40];
    low = 3;
    
    [bl al] = butter(4, (low)/fs*2,'low');
    [bh ah] = butter(3, (high)/fs*2);
    
    xl = filtfilt(bl, al, data(1,:));
    xh = filtfilt(bh, ah, data(2,:));
    xh2 = filtfilt(bh, ah, data(3,:));
    
    
    amp = abs(hilbert(xh));
    amp2 = abs(hilbert(xh2));
    
    lf = reshape(xl,[np,nep]);
    hf = reshape(amp,[np,nep]);
    hf2 = reshape(amp2,[np,nep]);
    
    %%
    figure
    figone(15,20)
    subplot(2,3,1)
    plot(mean(lf,2))
    title('Phase Oz')
    ylim([-0.7 0.7])
    subplot(2,3,2)
    plot(mean(hf,2))
    ylim([0 0.15])
    title('Envelope C3')
    subplot(2,3,3)
    plot(mean(hf2,2))
    ylim([0 0.15])
    title('Envelope C4')
    
%     figure
    subplot(2,3,4)
    plot((lf))
    subplot(2,3,5)
    plot((hf))
    subplot(2,3,6)
    plot((hf2))
    
    outname = [DIRFIG num2str(isb) '.png'];
    print(outname,'-dpng');
    close all
    
end

%%
for isb = 1:26
    
    EEG = pop_loadset('filename',['right_test' num2str(isb) '.set'],'filepath','~/Desktop/EEG_right/');
    
    oz = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'Oz'));
    c3 = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'C3'));
    c4 = find(strcmp({EEG.chanlocs(1:length(EEG.chanlocs)).labels},'C4'));
    
    data = EEG.data([oz c3 c4],100:300,:); 
    
    [nchan,np,nep]=size(data);
    
    fs = EEG.srate;

    [bl al] = butter(4, (low)/fs*2,'low');
    [bh ah] = butter(3, (high)/fs*2);
    
    xl = filtfilt(bh, ah, data(1,:));
    xh = filtfilt(bl, al, data(2,:));
    xh2 = filtfilt(bl, al, data(3,:));
    
    
    amp = abs(hilbert(xl));
%     amp2 = abs(hilbert(xh2));
    
    lf = reshape(amp,[np,nep]);
    hf = reshape(xh,[np,nep]);
    hf2 = reshape(xh2,[np,nep]);
    
    %%
    figure
    figone(15,20)
    subplot(2,3,1)
    plot(mean(lf,2))
    title('Envelope Oz')
    ylim([0 0.15])
    subplot(2,3,2)
    plot(mean(hf,2))
    ylim([-0.7 0.7])
    title('Phase C3')
    subplot(2,3,3)
    plot(mean(hf2,2))
    
    ylim([-0.7 0.7])
    title('Phase C4')
    
%     figure
    subplot(2,3,4)
    plot((lf))
    subplot(2,3,5)
    plot((hf))
    subplot(2,3,6)
    plot((hf2))
    
    outname = [DIRFIG num2str(isb) '_inv.png'];
    print(outname,'-dpng');
    close all
    
end