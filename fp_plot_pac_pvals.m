function fp_plot_pac_pvals(DIRFIG,data,data_a,to,ta)

titles = {'post l','post r','pre l','pre r'};
%%
data(data>0.05)=1;
data_a(data_a>0.05)=1;

%%
figure;
figone(30,40)
u = 1;
for ii = 1:4
    for jj =1:4
        subplot(4,4,u)
        imagesc(-log10(squeeze(data(:,:,ii,jj))).*squeeze(sign(to(:,:,ii,jj))))
%         colorbar
        caxis([-3 3])
          title([titles{jj} '--' titles{ii}])
        xlabel('amplitude freqs')
        ylabel('phase freqs')
        axis equal
        u = u+1;
    end
end
outname = [DIRFIG 'pvals_orig.png'];
print(outname,'-dpng');
% close all

%%

figure;
figone(30,40)
u = 1;
for ii = 1:4
    for jj =1:4
        subplot(4,4,u)
        imagesc(-log10(squeeze(data_a(:,:,ii,jj))).*squeeze(sign(ta(:,:,ii,jj))))
%         colorbar
        caxis([-3 3])
          title([titles{jj} '--' titles{ii}])
        xlabel('amplitude freqs')
        ylabel('phase freqs')
        axis equal
        u = u+1;
    end
end
outname = [DIRFIG 'pvals_anti.png'];
print(outname,'-dpng');
% close all
