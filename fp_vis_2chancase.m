DIROUT = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/vis_2chancase/';
if ~exist(DIROUT); mkdir(DIROUT); end

%%
figure; 
figone(10,20)
plot(X_1(1:200,:))

outname = [DIROUT 'case1.png'];
print(outname,'-dpng');
close all

%%
figure; 
figone(10,20)
plot(X_2(1:200,:))

outname = [DIROUT 'case2.png'];
print(outname,'-dpng');
close all

%%

figure; 
figone(10,20)
plot(X_3(1:200,:))

outname = [DIROUT 'case3.png'];
print(outname,'-dpng');
close all


%%
figure; 
figone(10,20)
plot(X_4(1:200,:))

outname = [DIROUT 'case4.png'];
print(outname,'-dpng');
close all

%%

figure; 
figone(10,20)
plot(X_5(1:200,:))

outname = [DIROUT 'case5.png'];
print(outname,'-dpng');
close all

%%

figure; 
figone(10,20)
plot(X_6(1:200,:))

outname = [DIROUT 'case6.png'];
print(outname,'-dpng');
close all



