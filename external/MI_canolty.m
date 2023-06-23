function MI = MI_canolty(phase, amp)
% Calculates the mean vector length modulation index according to Canolty(2006). 

%C.f. Canolty 2006, supplementary material page 4. 
z = amp.*exp(1i*phase); 
MI = abs(mean(z));
