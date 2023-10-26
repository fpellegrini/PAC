function  [canolty, tort, ozkurt] = fp_get_pac_values(amplt, phase)        
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

n_trials = size(phase,2);

for ii=1:n_trials   
    mi_canolty_vec(ii)= MI_canolty(phase(:,ii),amplt(:,ii));
    mi_tort_vec(ii)= MI_tort(phase(:,ii),amplt(:,ii),18);
    mi_ozkurt_vec(ii)= MI_ozkurt(phase(:,ii),amplt(:,ii));
end

canolty = mean(mi_canolty_vec);
tort = mean(mi_tort_vec);
ozkurt = mean(mi_ozkurt_vec);

% ozkurt=[];
% tort=[];

