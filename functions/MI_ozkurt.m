function MI = MI_ozkurt(phase, amp)
    z = amp.*exp(1i*phase);
    MI = abs(mean(z))/(sqrt(length(z))*sqrt(mean(amp.^2)));
end