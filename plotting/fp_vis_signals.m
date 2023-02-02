
DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/vis_signals/';

%%
uni_pac = xh + xl;
%s1 -> N x nInts*nReg
s1u = uni_pac./norm(uni_pac,'fro');


%one region contains low signal, the other the modulated high signal
%s1 -> N x nInts*2*nReg
s1b = cat(2,xl,xh);
s1b = s1b./norm(s1b(:),'fro');


% add pink background noise
backgu = mkpinknoise(N, size(s1u,2), 1);
backgu = backgu ./ norm(backgu, 'fro');

% add pink background noise
backgb = mkpinknoise(N, size(s1b,2), 1);
backgb = backgb ./ norm(backgb, 'fro');

%combine signal and background noise
signal_sourcesu = coupling_snr*s1u + (1-coupling_snr)*backgu;
signal_sourcesb = coupling_snr*s1b + (1-coupling_snr)*backgb;

sensor_noise = randn(120000,1);
sensor_noise = sensor_noise ./ norm(sensor_noise(:), 'fro');

%%
timca = [-2.5*10^-3 2.5*10^-3];
freqca = [-105 -60];

figure
figone(10,10)
plot(signal_sourcesb(1:100,[1 4]),'Linewidth',2)
% ylabel('Power (dB)','FontSize',15)
xlabel('Time','FontSize',20)
ylabel('Amplitude','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(timca)
outname = [DIRFIG 'bisig_time.png'];
print(outname,'-dpng');
outname = [DIRFIG 'bisig_time.eps'];
print(outname,'-depsc');
close all

figure;
figone(10,10)
[p f] = pwelch(signal_sourcesb(:,[1,4]), 400,200,400,200)
plot(f,10*log10(p),'Linewidth',2)
ylabel('Power','FontSize',20)
xlabel('Frequency','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(freqca)
outname = [DIRFIG 'bisig_freq.png'];
print(outname,'-dpng');
outname = [DIRFIG 'bisig_freq.eps'];
print(outname,'-depsc');
close all


figure
figone(10,10)
plot(signal_sourcesu(1:100,[1]),'Linewidth',2)
xlabel('Time','FontSize',20)
ylabel('Amplitude','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(timca)
outname = [DIRFIG 'unisig_time.png'];
print(outname,'-dpng');
outname = [DIRFIG 'unisig_time.eps'];
print(outname,'-depsc');
close all

figure;
figone(10,10)
[p f] = pwelch(signal_sourcesu(:,[1]), 400,200,400,200)
plot(f,10*log10(p),'Linewidth',2)
ylabel('Power','FontSize',20)
xlabel('Frequency','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(freqca)
outname = [DIRFIG 'unisig_freq.png'];
print(outname,'-dpng');
outname = [DIRFIG 'unisig_freq.eps'];
print(outname,'-depsc');
close all

figure
figone(10,10)
plot(noise_sources(1:100,[1]),'Linewidth',2)
xlabel('Time','FontSize',20)
ylabel('Amplitude','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(timca)
outname = [DIRFIG 'noise_time.png'];
print(outname,'-dpng');
outname = [DIRFIG 'noise_time.eps'];
print(outname,'-depsc');
close all


figure;
figone(10,10)
[p f] = pwelch(noise_sources(:,[1]), 400,200,400,200)
plot(f,10*log10(p),'Linewidth',2)
ylabel('Power','FontSize',20)
xlabel('Frequency','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(freqca)
outname = [DIRFIG 'noise_freq.png'];
print(outname,'-dpng');
outname = [DIRFIG 'noise_freq.eps'];
print(outname,'-depsc');
close all


figure
figone(10,10)
plot(sensor_noise(1:100,[1]),'Linewidth',2)
xlabel('Time','FontSize',20)
ylabel('Amplitude','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(timca)
outname = [DIRFIG 'sensornoise_time.png'];
print(outname,'-dpng');
outname = [DIRFIG 'sensornoise_time.eps'];
print(outname,'-depsc');
close all


figure;
figone(10,10)
[p f] = pwelch(sensor_noise(:,[1]), 400,200,400,200)
plot(f(2:end-1),10*log10(p(2:end-1)),'Linewidth',2)
ylabel('Power','FontSize',20)
xlabel('Frequency','FontSize',20)
set(gca,'xtick',[],'ytick',[],'Box','off')
caxis(freqca)
outname = [DIRFIG 'sensornoise_freq.png'];
print(outname,'-dpng');
outname = [DIRFIG 'sensornoise_freq.eps'];
print(outname,'-depsc');
close all

%%
% DIRFIG = '~/Dropbox/Franziska/PAC_AAC_estimation/figures/vis_signals/';
% 
% %%
% figure
% figone(10,10.5)
% imagesc(pac_ortho)
% xlabel('Region','FontSize',25)
% ylabel('Region','FontSize',25)
% set(gca,'xtick',[],'ytick',[],'Box','off')
% axis equal
% title('PAC scores','FontSize',25)
% 
% outname = [DIRFIG 'MI_vis.png'];
% print(outname,'-dpng');
% outname = [DIRFIG 'MI_vis.eps'];
% print(outname,'-depsc');
% close all
% 
% %%
% figure
% figone(10,10.5)
% imagesc(p_orig)
% xlabel('Region','FontSize',25)
% ylabel('Region','FontSize',25)
% set(gca,'xtick',[],'ytick',[],'Box','off')
% axis equal
% title('P-values','FontSize',25)
% 
% outname = [DIRFIG 'p_vis.png'];
% print(outname,'-dpng');
% outname = [DIRFIG 'p_vis.eps'];
% print(outname,'-depsc');
% close all
