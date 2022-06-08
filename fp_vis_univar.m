

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

mean(m,2)
%%
titles = {'Standard','Ortho','Bispec Original','Bispec Anti','Shabazi'};
for ii =1:5
    subplot(2,3,ii)
    hist(m(ii,:)')
    title(titles{ii})
    xlim([0 1])
    ylim([0 100])
end

%%
for iit = 1:100
    figure
    for ii = 1:5
        subplot(2,3,ii)
        imagesc(P{ii}(:,:,iit))
        cnb = sum(sum(nb(:,iroi(iit))==0.5));
        title([titles{ii} ' iroi ' num2str(iroi(iit)) ', ' num2str(cnb) ' neighb'])
    end
end

