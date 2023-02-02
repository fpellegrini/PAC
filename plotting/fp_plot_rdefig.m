function fp_plot_rdefig(data,ca)

regions = {'Postcentral left','Postcentral right','Precentral left','Precentral right'};
rc = [[3 4];[4 3];[1 2];[2 1];[3 2];[2 3];[4 1];[1 4];[3 1];[1 3];[4 2];[2 4]];
fig = figure
figone(40,31)
[ha, pos] = tight_subplot(6,2,[.02 .025],[.05 .03],[.05 .01]);

for u = 1:size(rc,1)
    iroi = rc(u,2);
    jroi = rc(u,1);
    axes(ha(u)); 
    img_data=squeeze(data(:,:,iroi,jroi));
    h = imagesc(img_data);
    set(h, 'AlphaData', 1-isnan(img_data))
%     colorbar
    caxis(ca)
    axis equal    
    grid on
    ha(u).GridAlpha = 0.6;
    title([regions{jroi} ' - ' regions{iroi}],'FontSize',23)
    ylim([0 12])
    xlim([0 50])
    if u<11
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

ylabel_h.Position(1) = -0.14; % change horizontal position of ylabel
xlabel_h.Position(2) = -0.1; % change vertical position of xlabel

