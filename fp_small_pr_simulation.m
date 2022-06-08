

for iInt = 1:6
    
    %true interactions
    iroi_phase = randperm(68,iInt)';
    iroi_amplt = randperm(68,iInt)';
    
    %be sure that no region is selected twice
    for ii = 1:iInt
        while any(iroi_phase==iroi_amplt(ii))
            iroi_amplt(ii) = randi(68,1,1);
        end
    end
    
    %random matrices
    for ii = 1:1000
        pac = randn(68,68);
        pr(iInt,ii) = fp_pr_pac(pac,iroi_amplt,iroi_phase);
    end
    
end

%%

for ii = 1:6
    
    subplot(2,3,ii)
    hist(pr(ii,:)')
    ylim([0 250])
    xlim([0 1])
    title([num2str(ii) ' Interactions'])
end