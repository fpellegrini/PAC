function p_stouff = fp_stouffer(p)

nsub = numel(p);
p(p==1)=0.9999;
p(p==0)=0.00001; 
zsr= norminv(p);
zr = squeeze(sum(zsr,2)./sqrt(nsub));
p_stouff = normpdf(zr);
