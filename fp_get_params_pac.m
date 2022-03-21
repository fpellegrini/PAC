function params = fp_get_params_pac(ip)

if ip == 1
    params.case = 2; %bivariate
    params.iInt = 1;
    params.isnr=0.3;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
elseif ip == 2
    params.case = 2; %bivariate
    params.iInt = 2;
    params.isnr=0.7;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
elseif ip == 3
    params.case = 1; %univariate
    params.iInt = 1;
    params.isnr=0.3;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
elseif ip == 4
    params.case = 1; %univariate
    params.iInt = 2;
    params.isnr=0.7;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
elseif ip == 5
    params.case = 1; %univariate
    params.iInt = 2;
    params.isnr=0.3;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;

elseif ip == 6
    params.case = 2; %bivariate
    params.iInt = 2;
    params.isnr=0.3;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
elseif ip == 7
    params.case = 2; %bivariate
    params.iInt = 1;
    params.isnr=0.7;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
        
elseif ip == 8
    params.case = 1; %univariate
    params.iInt = 1;
    params.isnr=0.7;
    
    params.iReg=1;
    params.iss = 0.5;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 50;
    
end