
DIRIN = '~/Dropbox/Franziska/PAC_AAC_estimation/data/RDE/100Hz_srate/bispectra_5000/';

DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/RDE_figures/left_prepost/';
if ~exist(DIRFIG); mkdir(DIRFIG); end


%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
nsub = numel(subs);
regions = {'post l','post r','pre l','pre r'};

fs = 100;
f_nyq = fs/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least three times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz

pa = nan(nsub,f_lm,f_nyq,numel(regions),numel(regions));

%%

for mode = 1:2
    
    for isb = 1:nsub
        load([DIRIN 'vp' num2str(subs(isb)) '_PAC_shuf1-5000.mat'])
        isb 
        
        if mode == 1
            data = bols; %original bispectrum
        elseif mode == 2
            data = bals; %anti-symmetrized bispectrum
        end
        
        [~,~,nr1, nr2,nshuf] = size(data);
        
        for ifq = 1:f_lm
            for jfq=ifq*dr:f_nyq
                if (ifq+jfq<f_nyq)
                    for iroi = 1:nr1
                        for jroi = 1:nr2
                            pa(isb,ifq,jfq,iroi,jroi)= sum(data(ifq,jfq,iroi,jroi,1)< data(ifq,jfq,iroi,jroi,2:end))/(nshuf-1);
                        end
                    end
                end
            end
        end
    end
    
    pa(pa==0)=1/(nshuf-1);
    
    %% plot
    
    [pl, zr] = fp_stouffer(pa,nshuf,'right');
%     mask = ones(size(pl));
%     ind = find(~isnan(pl));
%     [pl_fdr, ~] = fdr(pl(ind), 0.05);
%     mask(pl>pl_fdr) = 0.1;
%     fp_plot_rdefig3(-log10(pl),[0 3],mask)

    mask(pl>0.05) = 0.1;
    fp_plot_rdefig3(-zr,[-3 3 ],mask)
    
    if mode == 1
        outname = [DIRFIG 'left_orig.png'];
        print(outname,'-dpng');
        outname = [DIRFIG 'left_orig.eps'];
        print(outname,'-depsc');
    elseif mode == 2
        outname = [DIRFIG 'left_anti.png'];
        print(outname,'-dpng');
        outname = [DIRFIG 'left_anti.eps'];
        print(outname,'-depsc');
    end
    close all
    
end
%%

figure; 
cl=slanCM('imola');
colormap(cl)
caxis([ -3 3]) 
cb = colorbar;
cb.Label.String = 'Stouffer''s z';
cb.FontSize = 18;
outname = [DIRFIG 'cb_left_prepost.png'];
print(outname,'-dpng');
outname = [DIRFIG 'cb_left_prepost.eps'];
print(outname,'-depsc');

