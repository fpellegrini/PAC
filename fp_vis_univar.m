

load('~/Dropbox/Franziska/Data_MEG_Project/processed_bs_wzb_90_2000/bs_results.mat')
iatl = 3; % DK atlas
neighbor_thresh = 10; % 10mm vicinity defines neighborhood between regions
[~, ~, nb, ~] = get_ROI_dist_full(cortex, iatl, neighbor_thresh);

%%
for iit = 1:100
    
    cnb = find(nb(:,iroi(iit))==0.5);
    
    for im = 1:5
        
        u1 = P{im}(cnb,cnb,iit);
        m(im,iit) = mean(u1(:));
    end
end

p1 = mean(m,2);

figure
bar(p1)
grid on 
xticks = 1:5; 
xTickLabels = titles2;
set(gca,'xtick',xticks,'xticklabels',xTickLabels);
ylabel('FPR')

figure; 
bar(p1(1:4))
grid on 
xticks = 1:4; 
xTickLabels = titles2(1:4);
set(gca,'xtick',xticks,'xticklabels',xTickLabels);
ylabel('FPR')

%% Histograms of neighboring FPR
titles = {'Standard','Ortho','Bispec Original','Bispec Anti','Shabazi'};
for ii =1:5
    subplot(2,3,ii)
    hist(m(ii,:)')
    title(titles{ii})
    xlim([0 1])
    ylim([0 100])
end

%% why is Shahbazi performing so badly?
for iit = 1:100
    figure
    for ii = 1:5
        subplot(2,3,ii)
        imagesc(P{ii}(:,:,iit))
        cnb = sum(sum(nb(:,iroi(iit))==0.5));
        title([titles{ii} ' iroi ' num2str(iroi(iit)) ', ' num2str(cnb) ' neighb'])
    end
end


%%

for iit = 1:100
    
    cnb = find(nb(:,iroi(iit))==0.5);
    cnb1 = setdiff(1:68,cnb);
    
    for im = 1:5
        
        u1 = P{im}(cnb1,cnb1,iit);
        mm(im,iit) = mean(u1(:));
    end
end

p2 = mean(mm,2);

figure
bar(p2)
grid on 
xticks = 1:5; 
xTickLabels = titles2;
set(gca,'xtick',xticks,'xticklabels',xTickLabels);
ylabel('FPR')

figure; 
bar(p2(1:4))
grid on 
xticks = 1:4; 
xTickLabels = titles2(1:4);
set(gca,'xtick',xticks,'xticklabels',xTickLabels);
ylabel('FPR')
