load cm17;

D = fp_get_atlas_musdys;


%%

% pac  = squeeze(pac_standard(iroi_phase,:,1));
% pac(iroi_phase)=0;
p_standard(p_standard==0)=0.001;
pac  = -log10(squeeze(p_standard(iroi_phase,:)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])

pac  = -log10(squeeze(p_standard(:,iroi_phase)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])
%%
% pac  = squeeze(pac_ortho(iroi_phase,:,1));
% pac(iroi_phase)=0;
p_ortho(p_ortho==0)=0.001;
pac  = -log10(squeeze(p_ortho(iroi_phase,:)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])


pac  = -log10(squeeze(p_ortho(:,iroi_phase)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])
%%
% pac  = squeeze(b_orig(iroi_phase,:,1));
% pac(iroi_phase)=0;
p_orig(p_orig==0)=0.001;
pac  = -log10(squeeze(p_orig(iroi_phase,:)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])


pac  = -log10(squeeze(p_orig(:,iroi_phase)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])
%%
% pac  = squeeze(b_anti(iroi_phase,:,1));
% pac(iroi_phase)=0;
p_anti(p_anti==0)=0.001;
pac  = -log10(squeeze(p_anti(iroi_phase,:)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])

pac  = -log10(squeeze(p_anti(:,iroi_phase)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])

%%
p_shahbazi(p_shahbazi==0)=0.001;
pac  = -log10(squeeze(p_shahbazi(iroi_phase,:)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])

pac  = -log10(squeeze(p_shahbazi(:,iroi_phase)));
allplots_cortex_BS(D.cortex_highres, pac, [0 max(abs(pac))], cm17a ,'.', 0.3,[])
%%

data = zeros(68,1); 
data(iroi_phase)=1; 

allplots_cortex_BS(D.cortex_highres, data, [0 max(abs(data))], cm17a ,'.', 0.3,[])
       