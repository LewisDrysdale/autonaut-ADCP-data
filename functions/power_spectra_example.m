close all
clear all

%% Load data set
    load mld_chl.mat

%% Faff with variable names
    dd_ww = datenum(ww_dtime);
    chl_ww = ww_sumchl;
    daynum_ww = dd2day(dd_ww); % Daynumber
    
%% Plot raw data    
    setfig([0 0 15 7],'portrait'); hold on; box on
    plot(dd_ww,chl_ww)
    datetick('x','dd')
    xlim([dd_ww(1) dd_ww(end)])
    title('Depth Integrated Chl-a within SCM')
    xlabel('Day in July 2015')
    ylabel('mg m^{-2}')

%% Interp onto evenly spaced time intervals for spectral analysis and fill gaps 
% mean interval is approx. 0.009 day --> 0.22 hours -- > 13 minutes

% Create evenly spaced time grid
  [daynum,dd,date] = dates(datestr(dd_ww(1),'dd-mmm-yyyy HH:MM:SS'),datestr(dd_ww(end),'dd-mmm-yyyy HH:MM:SS'),13.*60);

% Linear interpolation   
    isfn=isfinite(chl_ww); 
    [chl] = interp1(dd_ww(isfn),chl_ww(isfn),dd,'linear','extrap');
  
    plot(dd,chl,'r')

  
%% PSD via Welch's method (avergaing periodograms)
% Set options
    data = chl;
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
   
setfig([0 0 13 10],'portrait'); 
  l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
  semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255)
  semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255)
    
  
  xlim([1 200])
  set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200],'FontSize',10)
  set(gca,'XDir','reverse')
  set(gca,'XMinorTick','off')
  ylim([0 40])
  
  ylabel('Chl-a variance (mg m^{-2}) ^2')
  xlabel('Period (hours)')
  title('Variance preserving PSD')
   
