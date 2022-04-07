function params = fp_get_params_pac(ip)

if ip == 1
    %default bivariate 
    params.case = 2; %bivariate
    params.iInt = 1;
    params.isnr=0.7;
    params.t = 0; 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip == 2
    %vary interactions 
    params.case = 2; %bivariate
    params.iInt = 2:5;
    params.isnr=0.7;
    params.t = 0; 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip == 3
    %vary snr 
    params.case = 2; %bivariate
    params.iInt = 1;
    params.isnr=[0.3 0.5 0.9];
    params.t = 0; 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip == 4
    %truevox pipeline 
    params.case = 2; %bivariate
    params.iInt = 1;
    params.isnr=0.7;
    params.t = 1; 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip==5 
    %uni+bivariate case 
    params.case = 3; 
    params.iInt = [1 1];%one univariate and one bivariate interaction 
    params.isnr=0.7;
    params.t = 0; % pip1 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip==6
    %uni+bivariate case 
    params.case = 3; 
    params.iInt = [1 1];%one univariate and one bivariate interaction 
    params.isnr=0.7;
    params.t = 1; % truevox pip
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip == 7 
    %uni+bivariate case 
    params.case = 3; 
    params.iInt = [2 2];%two univariate and two bivariate interactions 
    params.isnr=0.7;
    params.t = 0; % pip1 
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
    
elseif ip==8 
    %uni+bivariate case 
    params.case = 3; 
    params.iInt = [2 2];%two univariate and two bivariate interactions 
    params.isnr=0.7;
    params.t = 1; % truevox
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 500;
       
    
% elseif ip == 5
%     params.case = 1; %univariate
%     params.iInt = 2;
%     params.isnr=0.3;
%     
%     params.iReg=1;
%     params.iss = 0.9;
%     params.ifilt = 'l';
%     params.pips = 1;
%     params.nshuf = 500;
% 
% elseif ip == 6
%     params.case = 2; %bivariate
%     params.iInt = 2;
%     params.isnr=0.3;
%     
%     params.iReg=1;
%     params.iss = 0.9;
%     params.ifilt = 'l';
%     params.pips = 1;
%     params.nshuf = 500;
%     
% elseif ip == 7
%     params.case = 2; %bivariate
%     params.iInt = 1;
%     params.isnr=0.7;
%     
%     params.iReg=1;
%     params.iss = 0.9;
%     params.ifilt = 'l';
%     params.pips = 1;
%     params.nshuf = 500;
%     
%         
% elseif ip == 8
%     params.case = 1; %univariate
%     params.iInt = 1;
%     params.isnr=0.7;
%     
%     params.iReg=1;
%     params.iss = 0.9;
%     params.ifilt = 'l';
%     params.pips = 1;
%     params.nshuf = 500;
    
end