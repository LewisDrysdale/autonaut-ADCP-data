close all
clear all

%Load data set
load rt_data.mat

    
%% Plot raw data
figure;
x=rt.time;
y=rt.v_N(1,:);
plot(x,y)
datetick('x','hh:mm')
title('V north')
xlabel('Time')
ylabel('cm/s')
axis tight

%% Interp onto evenly spaced time intervals for spectral analysis and fill gaps 
dd=x(isfinite(y));
yy=y(isfinite(y));
plot(dd,yy,'r')

  
%% PSD via Welch's method (avergaing periodograms)
% Set options
data = yy;
N = length(data);
% Here I have set a window length to be half the length of the time series
% and overlapped the windows by 50%  - the result is the average of spectra calculated 
% from each of these (overlapping) windows                               
    window = floor(length(data) ./ 2); % Window length 
    noverlap = floor(window./2); % Window overlap
    deltaT = 1/3600; % Sampling interval in hours 
    fs = 60*60; % samples per hour
    nfft = window;
    
% If using the whole length of the time series     
    fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
    fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin
    
% Call PSD function    
    [Pxx,f,Pxxc] = pwelch(data,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 
   
figure
l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255)
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255)

  
xlim([1 200])
set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200],'FontSize',10)
set(gca,'XDir','reverse')
set(gca,'XMinorTick','off')

ylabel('Chl-a variance (mg m^{-2}) ^2')
xlabel('Period (hours)')
title('Variance preserving PSD')
   
