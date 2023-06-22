function [ppos, mask]= fp_clust_correction(data,alpha)

[f_lm,f_nyq,nshuf] = size(data);
dr = 3; %we define PAC only when high freq is at least three times higher than low freq


%% true
p = nan(f_lm,f_nyq);
for ifq = 1:f_lm
    for jfq=ifq*dr:f_nyq
        if (ifq+jfq<f_nyq)
            p(ifq,jfq)= sum(data(ifq,jfq,1)< data(ifq,jfq,2:end-1))/(nshuf-2);
        end
    end
end

cube = zeros(size(p));
cube(p<alpha)=1;

%bridge removal
% tmp_pos1 = cm_bridge_removal(tmp_pos);

[clust,~] = bwlabeln(cube);

%% permutation

cluSize = zeros(nshuf-1,1);

for ishuf = 2:nshuf
    
    p = nan(f_lm,f_nyq);
    for ifq = 1:f_lm
        for jfq=ifq*dr:f_nyq
            if (ifq+jfq<f_nyq)
                inds = setdiff(2:nshuf,ishuf);
                p(ifq,jfq)= sum(data(ifq,jfq,ishuf)< data(ifq,jfq,inds))/(nshuf-1);
            end
        end
    end
    
    %pos
    cube= p<alpha;
    [clu,tot] = bwlabeln(cube);
    if tot>0
        x = hist(clu(:),0:tot);
        cluSize(ishuf-1) = max(x(2:end));
    end
    clear clu tot x
end

%%
%find largest positive cluster
temp=clust(:);
temp(clust(:)==0)=[];
maxPos = mode(temp);
truePos = sum(clust(:)==maxPos);
clear temp

%compare permuted cluster sizes to size of real cluster
ppos = sum(cluSize>truePos)/(nshuf-1);

%
mask = zeros(size(clust));
if ppos < 0.05
    mask(clust==maxPos)=0.7;
end

mask=mask+0.3;