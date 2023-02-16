function MI = MI_canolty(phase, amp)
    z = amp.*exp(1i*phase); 
    MI = abs(mean(z));
end