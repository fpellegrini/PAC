function fp_plot_rdefig2(data,ca,mask)

regions = {'Pericalc left','Pericalc right','Precentral left','Precentral right'};
rc = [[3 2];[2 3];[4 1];[1 4];[3 1];[1 3];[4 2];[2 4]];
fig = figure
figone(20,31)
[ha, pos] = tight_subplot(4,2,[.02 .025],[.05 .03],[.05 .01]);

for u = 1:size(rc,1)
    iroi = rc(u,1); %amplitude
    jroi = rc(u,2); %phase
    axes(ha(u)); 
    img_data=squeeze(data(:,:,iroi,jroi));
    h = imagesc(img_data);
    img_mask = squeeze(mask(:,:,iroi,jroi));
    img_mask(isnan(img_data))=0;
    set(h, 'AlphaData', img_mask)
%     colorbar
    caxis(ca)
    axis equal    
    grid on
    ha(u).GridAlpha = 0.6;
    title([regions{jroi} ' - ' regions{iroi}],'FontSize',23)
    ylim([0 12])
    xlim([0 50])
    if u<size(rc,1)-1
        ha(u).XAxis.TickLength = [0 0];
        ha(u).XAxis.TickLabels = [];
    else
        ha(u).XAxis.FontSize=20;
    end
    
    if rem(u,2)==0
        ha(u).YAxis.TickLength = [0 0];
        ha(u).YAxis.TickLabels = [];
    else
        ha(u).YAxis.FontSize=20;
    end
    
    ha(u).Box = 'off';
end
%%
han=axes(fig,'visible','off'); 
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel_h = ylabel(han,'Phase frequency (Hz)','FontSize',23);
xlabel_h = xlabel(han,'Amplitude frequency (Hz)','FontSize',23);

ylabel_h.Position(1) = -0.135; % change horizontal position of ylabel
xlabel_h.Position(2) = -0.09; % change vertical position of xlabel

