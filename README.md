# PAC
Matlab code for the paper "Distinguishing across- from within-site phase-amplitude coupling using antisymmetrized bispectra" by Franziska Pellegrini, 
Tien Dung Nguyen, Taliana Herrera, Vadim Nikulin, Guido Nolte, and Stefan Haufe.

These are two simulations that generate artificial time series containing ground-truth univariate or bivariate PAC interactions 
and compare different metrics in their ability to robustly distinguish between genuine across-site PAC and spurious across-site PAC that has emerged from 
within-site PAC and signal spreading. 

The two-channel simulation is started by [fp_submit_2chan_sim_nsg.m](fp_submit_2chan_sim_nsg.m). 
The whole-brain simulation is started by [fp_submit_pacsim_nsg.m](fp_submit_pacsim_nsg.m).  

The recommended methods and pipelines introduced in this project have been implemented in the ROIconn plugin to the free and open source [EEGlab toolbox](https://github.com/sccn/roiconnect).

The authors would be grateful if published reports of research using this code (or a modified version, maintaining a significant portion of the original code) would cite the following article: 
> Pellegrini, F., Nguyen, T.D., Herrera,T., Nikulin, V., Nolte, G., & Haufe, S. (2023). Distinguishing between- from within-site phase-amplitude coupling using antisymmetrized bispectra. bioRxiv 2023.10.26.564193. https://doi.org/10.1101/2023.10.26.564193
