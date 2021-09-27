%% Continuous Wavelet Transform Measures

function cwtmr = cwtm(x,no,wa,smin,smax)
% cwtm is a function that computes various continuous wavelet transforms of
% a time series:
% (1) a Generalized Morse Wavelet with P=4 (time-bandwith product) and
% gamma=3 (symmetry) is used to detect singularities
% (2) a Generalized Morse Wavelet with P=20 and gamma=3 is used to detect
% sales of oscillation
% (3) a Generalized Morse Wavelet with P and gamma optimized according to
% Maximum Entropy to Energy Ratio giving the most energy efficient
% wavelet transform(requires meer.m)
% (4) a Morlet wavelet is used with MonteCarlo bootstrap to assess
% significaity against white and red noise (requires grinsted wt toolbox)
% (5) a Morlet wavelet is used to compute the bicoherence of the signal
% INPUT:
% x: a time series(n*1 matrix)
% no: the max number of octaves per scales (defaut: floor(log2(numel(x)))-1 )
% Output:
% cwtmr: a structure with the following fields
%   x : the time series;
%   x.t: the time vector of x
%   sigma2 : variance of x
%   wt1 : The wavelet transform in (1)
%   wt1_pow: The wavelet power spectrum of wt1
%   wt1_coi: Cone of influence of wt1
%   wt1_period: The periods associated with each scale of wt1
%   wt2 : The wavelet transform in (2)
%   wt2_pow: The wavelet power spectrum of wt2
%   wt2_coi: Cone of influence of wt2
%   wt2_period: The periods associated with each scale of wt2
%   wt3 : The wavelet transform in (3)
%   wt3_pow: The wavelet power spectrum of wt3
%   wt3_coi: Cone of influence of wt3
%   wt3_period: The periods associated with each scale of wt3
%   wt3_params: the gamme and P parameters used for wt3
%   wt4 : The wavelet transform in (4)
%   wt4_pow: The wavelet power spectrum of wt4
%   wt4_coi: Cone of influence of wt4
%   wt4_period: The periods associated with each scale of wt4
%   wt4_signif: The significativity of wt4 with K bootstrap runs
%   wt5_wbi: The bicoherence in (5)
%   wt5_signif: The significativity of wt5_wbi with K bootstrap runs
%   (requires wbicoher.m and its toolbox)

%% Variables
if~no;no = floor(log2(numel(x)))-1;end
ts = seconds(1);
cwtmr.x = x;
cwtmr.t = 1:size(x,1);
cwtmr.sigma2 = var(x(:,1));
pr_end = 40;
gr_end = 5;
l = 1;
if nargin~=5
    wa = 'all';
end

switch wa
    case 'all'
    %% GMW (1)
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',[3 4],ts);
    [WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',[3 4],ts);
    cwtmr.wt1 = WT;
    cwtmr.wt1_pow = power(abs(WT),2);
    cwtmr.wt1_coi = COI;
    cwtmr.wt1_period = PERIOD;

    %% GMW (2)
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',[3 20],ts);
    [WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',[3 20],ts);
    cwtmr.wt2 = WT;
    cwtmr.wt2_pow = power(abs(WT),2);
    cwtmr.wt2_coi = COI;
    cwtmr.wt2_period = PERIOD;

    %% GMW(3)
    for i=3:gr_end;for j=i+1:pr_end;wname{l} = [i j];l = l+1;end;end
    tmp_meer = meer(x','cwt',wname);
    tmp_meer_max = wname{find(tmp_meer == max(tmp_meer))};
    [WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',tmp_meer_max,ts);
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',tmp_meer_max,ts);
    cwtmr.wt3 = WT;
    cwtmr.wt3_pow = power(abs(WT),2);
    cwtmr.wt3_coi = COI;
    cwtmr.wt3_period = PERIOD;
    cwtmr.wt3_params = tmp_meer_max;

    %% MW (4)
    %[WT,PERIOD,scale,COI,SIG95] = wt(boxpdf(x),'MakeFigure',0,'J1',no*10,'Dj',1/10);
    [WT,PERIOD,scale,COI,SIG95] = wt(boxpdf(x),'MakeFigure',0);
    cwtmr.wt4 = WT;
    cwtmr.wt4_pow = power(abs(WT),2);
    cwtmr.wt4_coi = seconds(COI);
    cwtmr.wt4_period = seconds(PERIOD);
    cwtmr.wt4_signif = SIG95;
    cwtmr.wt4_scale = scale;

    %% MWB (5)
    %[wbi,sig] = wbicoher(boxpdf(x),boxpdf(x),'MakeFigure',0,'J1',no*10,'Dj',1/10); % Morlet Wavelet
    [wbi,sig] = wbicoher(boxpdf(x),boxpdf(x),'MakeFigure',0); 
    cwtmr.wt5_wbi = wbi;
    cwtmr.wt5_signif = sig;
    %% ASToolbox (GMW)
    for i=3:gr_end;for j=i+1:pr_end;wname{l} = [i j];l = l+1;end;end
    tmp_meer = meer(x','cwtast',wname);
    tmp_meer_max = wname{find(tmp_meer == max(tmp_meer))};
    [wx,periods,scales,coi,wpower,pvPower]= AWTV2(boxpdf(x),1,1/12,2,16,0,'GMW',tmp_meer_max(2),tmp_meer_max(1),300,'ARMABoot',0,0);
    cwtmr.wt6 = wx;
    cwtmr.wt6_pow = wpower;
    cwtmr.wt6_coi = coi;
    cwtmr.wt6_period = periods;
    cwtmr.wt6_scales = scales;
    cwtmr.wt6_pvpower = pvPower;
    cwtmr.wt6_params = tmp_meer_max;
    case 'wtc'
    %% MW (4)
    %[WT,PERIOD,scale,COI,SIG95] = wt(boxpdf(x),'MakeFigure',0,'J1',no*10,'Dj',1/10);
    [WT,PERIOD,scale,COI,SIG95] = wt(boxpdf(x),'MakeFigure',0,'S0',smin,'MaxScale',smax);
    cwtmr.wt4 = WT;
    cwtmr.wt4_pow = power(abs(WT),2);
    cwtmr.wt4_coi = COI;
    cwtmr.wt4_period = PERIOD;
    cwtmr.wt4_pvpower = SIG95;
    cwtmr.wt4_scale = scale;
	cwtmr.wt4_params = [];

    case 'wbi'
    %% MWB (5)
    %[wbi,sig] = wbicoher(boxpdf(x),boxpdf(x),'MakeFigure',0,'J1',no*10,'Dj',1/10); % Morlet Wavelet
    [wbi,sig] = wbicoher(boxpdf(x),boxpdf(x),'MakeFigure',0); 
    cwtmr.wt5_wbi = wbi;
    cwtmr.wt5_signif = sig;
    case 'matlab'
    %% GMW (1)
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',[3 4],ts);
    [WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',[3 4],ts);
    cwtmr.wt1 = WT;
    cwtmr.wt1_pow = power(abs(WT),2);
    cwtmr.wt1_coi = COI;
    cwtmr.wt1_period = PERIOD;

    %% GMW (2)
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',[3 20],ts);
    [WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',[3 20],ts);
    cwtmr.wt2 = WT;
    cwtmr.wt2_pow = power(abs(WT),2);
    cwtmr.wt2_coi = COI;
    cwtmr.wt2_period = PERIOD;

    %% GMW(3)
    for i=3:gr_end;for j=i+1:pr_end;wname{l} = [i j];l = l+1;end;end
    tmp_meer = meer(x','cwt',wname);
    tmp_meer_max = wname{find(tmp_meer == max(tmp_meer))};
    [WT,PERIOD,COI] = cwt(boxpdf(x),'NumOctaves',no,'WaveletParameters',tmp_meer_max,ts);
    %[WT,PERIOD,COI] = cwt(boxpdf(x),'WaveletParameters',tmp_meer_max,ts);
    cwtmr.wt3 = WT;
    cwtmr.wt3_pow = power(abs(WT),2);
    cwtmr.wt3_coi = COI;
    cwtmr.wt3_period = PERIOD;
    cwtmr.wt3_params = tmp_meer_max;
    case 'ast'
    %% ASToolbox (GMW)
    for i=3:gr_end;for j=i+1:pr_end;wname{l} = [i j];l = l+1;end;end
    tmp_meer = meer(x','cwtast',wname,smin,smax);
    tmp_meer_max = wname{find(tmp_meer == max(tmp_meer))};
    %tmp_meer_max = [3 3];
    [wx,periods,coi,wpower,pvPower]= AWT(boxpdf(x),1,1/12,smin,smax,0,'GMW',tmp_meer_max(2),tmp_meer_max(1),'MCS',10000,2,2);
    cwtmr.wt6 = wx;
    cwtmr.wt6_pow = wpower;
    cwtmr.wt6_coi = coi;
    cwtmr.wt6_period = periods;
    %cwtmr.wt6_scales = scales;
    cwtmr.wt6_pvpower = pvPower;
    cwtmr.wt6_params = tmp_meer_max;
end
end

  




