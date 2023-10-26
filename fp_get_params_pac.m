function params = fp_get_params_pac(ip)
% Output is the params structure with several fields defining the
% experimental setup.
%
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

if ip == 1
    %default bivariate case
    params.case = 2; %bivariate
    params.iInt = 3;
    params.isnr=0.5;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100; %for shahbazi
    
elseif ip == 2
    %vary interactions
    params.case = 2; %bivariate
    params.iInt = [1 5];
    params.isnr=0.5;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
elseif ip == 3
    %vary snr
    params.case = 2; %bivariate
    params.iInt = 3;
    params.isnr=[0.3 0.7];
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
    % elseif ip == 4
    %     %truevox pipeline
    %     params.case = 2; %bivariate
    %     params.iInt = 3;
    %     params.isnr=0.5;
    %     params.t = 1;
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    
    % elseif ip==5
    %     %uni+bivariate case
    %     params.case = 3;
    %     params.iInt = [1 1];%one univariate and one bivariate interaction
    %     params.isnr=0.5;
    %     params.t = 0; % pip1
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    %
    % elseif ip==6
    %     %uni+bivariate case
    %     params.case = 3;
    %     params.iInt = [1 1];%one univariate and one bivariate interaction
    %     params.isnr=0.5;
    %     params.t = 1; % truevox pip
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    %
    % elseif ip == 7
    %     %uni+bivariate case
    %     params.case = 3;
    %     params.iInt = [3 3];%three univariate and two bivariate interactions
    %     params.isnr=0.5;
    %     params.t = 0; % pip1
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    %
    % elseif ip==8
    %     %uni+bivariate case
    %     params.case = 3;
    %     params.iInt = [3 3];%three univariate and two bivariate interactions
    %     params.isnr=0.5;
    %     params.t = 1; % truevox
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    
    % elseif ip==9
    %     %different lcmv
    %     params.case = 2; %bivariate
    %     params.iInt = 3;
    %     params.isnr=0.5;
    %     params.t = 0;
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'lf';
    %     params.pips = 1;
    %     params.nshuf = 100;
    
elseif ip == 10
    
    %default univariate case
    params.case = 1; %univariate
    params.iInt = 1;
    params.isnr=0.8;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
    % elseif ip == 11
    %
    %     %univariate case
    %     params.case = 1; %univariate
    %     params.iInt = 3;
    %     params.isnr=0.8;
    %     params.t = 0;
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'l';
    %     params.pips = 1;
    %     params.nshuf = 100;
    
    % elseif ip == 12
    %     %eloreta
    %     params.case = 2; %bivariate
    %     params.iInt = 3;
    %     params.isnr=0.5;
    %     params.t = 0;
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'e';
    %     params.pips = 1;
    %     params.nshuf = 100; %for shahbazi
    
    % elseif ip == 13
    %     %eloreta
    %     params.case = 1; %univariate
    %     params.iInt = 3;
    %     params.isnr=0.8;
    %     params.t = 0;
    %
    %     params.iReg=1;
    %     params.iss = 0.9;
    %     params.ifilt = 'e';
    %     params.pips = 1;
    %     params.nshuf = 100;
    
elseif ip == 14
    
    %low snr univariate case
    params.case = 1; %univariate
    params.iInt = 1;
    params.isnr=0.5;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
elseif ip == 15
    
    %middle snr univariate case
    params.case = 1; %univariate
    params.iInt = 1;
    params.isnr=0.7;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
elseif ip == 16
    
    %default univariate case
    params.case = 1; %univariate
    params.iInt = 3;
    params.isnr=0.8;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
elseif ip == 17
    
    %default univariate case
    params.case = 1; %univariate
    params.iInt = 5;
    params.isnr=0.8;
    params.t = 0;
    
    params.iReg=1;
    params.iss = 0.9;
    params.ifilt = 'l';
    params.pips = 1;
    params.nshuf = 100;
    
end