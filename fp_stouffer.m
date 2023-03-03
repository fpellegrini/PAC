function p_stouff = fp_stouffer(p)

nsub = numel(p);
p(p==1)=0.9999;
p(p==0)=0.001; 
zsr= norminv(p);
zr = squeeze(sum(zsr,2)./sqrt(nsub));

%ensure that disproportionally high p-values don't lead to low p-values
%after stouffer
if (zr>0)
    p_stouff = 1;
else
    p_stouff = normpdf(zr);
end
