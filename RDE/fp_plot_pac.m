function fp_plot_pac(DIRFIG,data,data_a,condname)

titles = {'post l','post r','pre l','pre r'};

%% subject plots 

for isb = 1:26
    figure;
    figone(30,40)
    u = 1;
    for ii = 1:4
        for jj =1:4
            subplot(4,4,u)
            imagesc(squeeze(data(isb,:,:,ii,jj)))
            caxis([0 3.5*(10^-4)])
            title([titles{jj} '--' titles{ii}])
            xlabel('amplitude freqs')
            ylabel('phase freqs')
%             if u==16
%                 colorbar
%             end
            u = u+1;
        end
    end
    outname = [DIRFIG num2str(isb) '_' condname '.png'];
    print(outname,'-dpng');
    close all
end

%% average 

data1 = squeeze(mean(data,1)); 
figure;
figone(30,40)
u = 1;
for ii = 1:4
    for jj =1:4
        subplot(4,4,u)
        imagesc(squeeze(data1(:,:,ii,jj)))
%         colorbar
        caxis([0 1.5*(10^-4)])
          title([titles{jj} '--' titles{ii}])
        xlabel('amplitude freqs')
        ylabel('phase freqs')
        u = u+1;
    end
end
outname = [DIRFIG 'average_' condname '.png'];
print(outname,'-dpng');
close all

%% average anti

data_a1 = squeeze(mean(data_a,1)); 
figure;
figone(30,40)
u = 1;
for ii = 1:4
    for jj =1:4
        subplot(4,4,u)
        imagesc(squeeze(data_a1(:,:,ii,jj)))
%         colorbar
        caxis([0 1.5*(10^-4)])
        title([titles{jj} '--' titles{ii}])
        xlabel('amplitude freqs')
        ylabel('phase freqs')
        u = u+1;
    end
end
outname = [DIRFIG 'average_anti_' condname '.png'];
print(outname,'-dpng');
close all
%% average original-anti

data1 = squeeze(mean(data,1)); 
data_a1 = squeeze(mean(data_a,1)); 
figure;
figone(30,40)
u = 1;
for ii = 1:4
    for jj =1:4
        subplot(4,4,u)
        imagesc(squeeze(data1(:,:,ii,jj)-data_a1(:,:,ii,jj)))
%         colorbar
        caxis([0 1.5*(10^-4)])
          title([titles{jj} '--' titles{ii}])
        xlabel('amplitude freqs')
        ylabel('phase freqs')
        u = u+1;
    end
end
outname = [DIRFIG 'average_vol_c_' condname '.png'];
print(outname,'-dpng');
close all

%%

a = squeeze(nanmean(data1,1)); 
b = squeeze(nanmean(data1,2));

figure;
figone(20,40)
subplot(1,2,1)
for ii = 1:4
    plot(a(:,ii,ii))
    hold on
end
legend(titles)
grid on 
title('Average across phase freqs')

subplot(1,2,2)
for ii = 1:4
    plot(b(:,ii,ii))
    hold on
end
legend(titles)
grid on 
title('Average across amplitude freqs')

outname = [DIRFIG 'average_spectra_univar_' condname '.png'];
print(outname,'-dpng');
close all