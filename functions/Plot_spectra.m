clear; close;
for ii = 7
filename = ['W:/CAMPUS/SSB_EXPS01/TVars_2015_CelticSea_Transect_' num2str(ii) '.mat'];
sml = 0.02;bml=0.02; % need to define mld criteria 
[AMM7] = fun_load_model(filename,sml,bml,4);
sml=0.02;bml=0.2;% CS15 needs higher demnsity criteria for bmld
filename = ['W:/CAMPUS/CS15/Data/TVars_2015_CandyFloss_T.mat'];
[CS15] = fun_load_model(filename,sml,bml);
end
clear filename
% load glider data
filename = 'W:/CAMPUS/CCS_data/glider/spring_2015/SoG_534_Grd_cal_que.mat';
[gld] = fun_load_glider(filename)
% WW data
filename =  'W:/CAMPUS/CCS_data/wirewalker/summer_2015_at_CCS/DY033_deployment1_ctd_triplet_gridded.mat';
% filename =  '/work/lewysd/CAMPUS/CCS_data/wirewalker/summer_2015_at_CCS/DY033_deployment1_ctd_triplet_gridded.mat';
[ww] = fun_load_ww(filename);
clear filename transect

%% MODEL TIME STEP
t_step          = 1/24;
rel_strt        = datenum('1950-01-01 00:00:00');
% 2015
nsec_strt       = AMM7.time_instant(1)/60/60/24;
nsec_end        = AMM7.time_instant(end)/60/60/24;
time2015        = [rel_strt+nsec_strt:t_step:rel_strt+nsec_end];

%% calculate integrated chl
% ww deployment 
jd1 = datenum('00:00:00 13-July-2015')
jd2 = datenum('23:00:00 26-July-2015')

[c d1] = min(abs(jd1-AMM7.mtime));
[c d2] = min(abs(jd2-AMM7.mtime));

% wirewalker data
ww.intchl = NaN(length(ww.mtime),1);
SPC = 0.005*ones(length(ww.mtime),1);
for ii = 1:length(ww.mtime)
    [~, idx] = min(abs(ww.SMLD(ii)-ww.PRES));
    [~, idk] = min(abs(ww.BMLD(ii)-ww.PRES));
    ww.intchl(ii) = trapz(ww.PRES(idx:idk),ww.CHL(idx:idk,ii),1);
end

%% set variables for analysis
D1 = ww.intchl;
D2 = CS15.intchl(d1:d2);
D3 = AMM7.intchl(d1:d2);
X1 = ww.mtime;
X2 = CS15.mtime(d1:d2);
X3 = AMM7.mtime(d1:d2);
%% Interp onto evenly spaced time intervals for spectral analysis and fill gaps FOR WIREWALKER ONLY
% mean interval is approx. 0.009 day --> 0.22 hours -- > 13 minutes
% Create evenly spaced time grid
[daynum,dd,date] = dates(datestr(X1(1),'dd-mmm-yyyy HH:MM:SS'),datestr(X1(end),'dd-mmm-yyyy HH:MM:SS'),13.*60);
% Linear interpolation   
isfn=isfinite(D1); 
[data] = interp1(X1(isfn),D1(isfn),dd,'linear','extrap');
plot(dd,data,'r');
%% Calculate spectra using jeh example: PSD via Welch's method (avergaing periodograms)
% Set options for WW
N = length(data);
% Here I have set a window length to be half the length of the time series
% and overlapped the windows by 50%  - the result is the average of spectra calculated 
% from each of these (overlapping) windows                               
    window = floor(length(data) ./ 2); % Window length 
    noverlap = floor(window./2); % Window overlap
    deltaT = 13/60; % Sampling interval in hours 
    fs = 60./13; % samples per hour
    nfft = window;
    
% If using the whole length of the time series     
    fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
    fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin
    
% Call PSD function    
    [Pxx,f,Pxxc] = pwelch(data,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 

    
%% plot spectra
figure(1);
set(gcf,'pos',[ 59   612   763   327]);
set(gcf,'color',[1 1 1]);
% variance preserving by fxpsd
l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255);
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255);
xlim([1 100])
set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200],'FontSize',10)
set(gca,'XDir','reverse')
set(gca,'XMinorTick','off')
ylim([0 100])
ylabel('Chl-a variance (mg m^{-2}) ^2')
xlabel('Period (hours)')
fname='spectra_st_WW';
export_fig(['Figures/',fname],'-png'); 

%% Set options for CS15
data = CS15.intchl(d1:d2)	;
N = length(data);
% Here I have set a window length to be half the length of the time series
% and overlapped the windows by 50%  - the result is the average of spectra calculated 
% from each of these (overlapping) windows                               
    window = floor(length(data) ./2); % Window length 
    noverlap = floor(window./2); % Window overlap
    deltaT = 1; % Sampling interval in hours 
    fs = 1; % samples per hour
    nfft = window;
    
% If using the whole length of the time series     
    fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
    fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin
    
% Call PSD function    
    [Pxx,f,Pxxc] = pwelch(data,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 
%% plot spectra
figure(2);
set(gcf,'pos',[ 59   612   763   327]);
set(gcf,'color',[1 1 1]);
% variance preserving by fxpsd
l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255);
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255);
xlim([1 100])
set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200],'FontSize',10)
set(gca,'XDir','reverse')
set(gca,'XMinorTick','off')
ylim([0 100])
ylabel('Chl-a variance (mg m^{-2}) ^2')
xlabel('Period (hours)')
fname='spectra_st_CS15';
export_fig(['Figures/',fname],'-png'); 
%% Set options for CS15
data = AMM7.intchl(d1:d2)	;
N = length(data);
% Here I have set a window length to be half the length of the time series
% and overlapped the windows by 50%  - the result is the average of spectra calculated 
% from each of these (overlapping) windows                               
    window = floor(length(data) ./ 2); % Window length 
    noverlap = floor(window./2); % Window overlap
    deltaT = 1; % Sampling interval in hours 
    fs = 1; % samples per hour
    nfft = window;
    
% If using the whole length of the time series     
    fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
    fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin
    
% Call PSD function    
    [Pxx,f,Pxxc] = pwelch(data,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 
%% plot spectra
figure(3)
set(gcf,'pos',[ 59   612   763   327]);
set(gcf,'color',[1 1 1]);
% variance preserving by fxpsd
l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255);
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255);
xlim([1 100])
set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200],'FontSize',10)
set(gca,'XDir','reverse')
set(gca,'XMinorTick','off')
ylim([0 3])
ylabel('Chl-a variance (mg m^{-2}) ^2')
xlabel('Period (hours)')
fname='spectra_st_AMM7';
export_fig(['Figures/',fname],'-png'); 