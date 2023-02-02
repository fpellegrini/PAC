DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/100Hz_srate/';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r

isub = 30;

low = 4;
high = 34;

%%
% load preprocessed EEG
sub = ['vp' num2str(isub)];
EEG_left = pop_loadset('filename',['roi1_' sub '_left.set'],'filepath',DIRIN) ;
d_l = EEG_left.roi.source_roi_data(rois,:,:);
fs = EEG_left.srate;

% EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
% d_r = EEG_right.roi.source_roi_data(rois,:,:);

%%
for lroi = 1:4
    for hroi = 1:4
        if lroi ~=hroi
            %%
            low_0= [-1 1];
            high_0 = [-2 2];
            
            [bl al] = butter(3, (low +low_0)/fs*2);
            [bh ah] = butter(3, (high + high_0)/fs*2);
            
            xl = filtfilt(bl, al, d_l(lroi,:));
            xh = filtfilt(bh, ah, d_l(hroi,:));
            
            amp = abs(hilbert(xh));
            phase  = angle(hilbert(xl));
            
            phase_bins = linspace(-pi, pi, 19);
            
            %Mean amplitude per bin
            for i=1:18
                mean_amp_bin(i) = mean( amp( find( phase >= phase_bins(i) & phase< phase_bins(i+1) )));
            end
            
            
            
            
            %%
            [Ypk_l,Xpk_l,~,~] = findpeaks(xl);
            dist = round(mean(Xpk_l(2:end)-(Xpk_l(1:end-1))));
            
            [Ypk,Xpk,~,~] = findpeaks(amp);
            dist_h = round(mean(Xpk(2:end)-(Xpk(1:end-1))));
            
            clear a
            for ii = 1:numel(Xpk)
                if Xpk(ii)>dist && Xpk(ii)+dist<numel(xh)
                    a(ii,:)=xl(Xpk(ii)-dist:Xpk(ii)+dist);
                end
            end
            
            clear b
            for ii = 1:numel(Xpk_l)
                if Xpk_l(ii)>dist_h && Xpk_l(ii)+dist_h<numel(xh)
                    b(ii,:)=amp(Xpk_l(ii)-dist_h:Xpk_l(ii)+dist_h);
                end
            end
            b = b- mean(b,2);

            
            %%
            ta = 1:1000;
            regions = {'post l','post r','pre l','pre r'};
            
            figure
            figone(30,60)
            
            subplot(3,2,1)
            plot(xl(ta),'r')
            hold on
            plot(amp(ta),'b')
            
            plot(Xpk_l(Xpk_l<ta(end)),Ypk_l(Xpk_l<ta(end)),'r*')
            plot(Xpk(Xpk<ta(end)),Ypk(Xpk<ta(end)),'b*')
            title(['Subject ' sub ' ' regions{lroi} '--' regions{hroi}])
            xlabel('Time (samples)')
            legend('SO','Envelope FO','Peak SO','Peak Envelope FO')
            
            subplot(3,2,2)
            bar(mean_amp_bin)
            xlabel('Phase')
            ylabel('Mean amplitude')
            set(gca, 'XTick',[1 9 18],'XTickLabels',{'-\pi', '0', '\pi'})
            
            subplot(3,2,3)
            imagesc([-dist:dist],[],a)
            title([num2str(low) ' Hz to ' num2str(high) ,'; 0 = peak'])
            xlabel('Time (samples), 0 = Envelope peak of FO')
            ylabel('Peak number')
            
            subplot(3,2,4)
            plot([-dist:dist],mean(a,1))
            xlabel('Time (samples), 0 = Envelope peak of FO')
            ylabel('Mean Amplitude')
            ylim(2.*[-10^-4 10^-4])
            
            subplot(3,2,5)
            imagesc([-dist_h:dist_h],[],b)
            title([num2str(low) ' Hz to ' num2str(high) ,'; 0 = peak'])
            xlabel('Time (samples), 0 = Peak of SO')
            ylabel('Peak number')
            
            subplot(3,2,6)
            plot([-dist_h:dist_h],mean(b,1))
            xlabel('Time (samples), 0 = Peak of SO')
            ylabel('Mean')
%             ylim([-10^-3 10^-3])
        end
    end
end







