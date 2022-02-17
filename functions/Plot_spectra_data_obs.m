clear; close;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
run LOAD_MODEL_OBS.m
%%
% number of hours
nhours = numel(WWdd);
% mean model data
mmd=NaN(1,numel(nhours));

% mean obs data
mod=NaN(1,numel(nhours));

% dta1 matrix 
model=NaN(100,numel(nhours));

% dta2 matrix 
obs=NaN(100,numel(nhours));

for ii=1:nhours
    if ~isnan(WW_sml(ii)) & ~isnan(WW_bml(ii))
    % CLOSEST depth TO sml FOR obs
    [~, d1] = min(abs(WWdepth-WW_sml(ii)));
    % CLOSEST depth TO bml FOR obs
    [~, d2] = min(abs(WWdepth-WW_bml(ii)));
    
    intobs(ii)=trapz(WWdepth(d1:d2),WWchl(d1:d2,ii));
    end
end

%% set data 

fname='pycncline_spectra_WW_normal';
data = intobs(isfinite(intobs));


%% normalis and plot
N = length(data);

% normalize the data
d_min=min(data);
d_max=max(data);

d_nrm=(data-d_min)/(d_max-d_min);
id = isfinite(d_nrm);
d_nrm=d_nrm(id);

clf
figure(1);
ax(1)=subplot(3,1,1);
plot(d_nrm,'-k')
ylim([0 1])
ylabel({'Normalized Chl-a', '(mg m^{-2})'});
xlabel('Hours')
set(gca,'FontSize',8);

%% performm psd
% Here I have set a window length to be half the length of the time series
% and overlapped the windows by 50%  - the result is the average of spectra calculated 
% from each of these (overlapping) windows                               
window = floor(length(d_nrm) ./5); % Window length 
noverlap = floor(window./2); % Window overlap
deltaT = 1; % Sampling interval in hours 
fs = 1; % samples per hour
nfft = window;

% If using the whole length of the time series     
fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin

% Call PSD function    
[Pxx,f,Pxxc] = pwelch(d_nrm,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 
    
%% plot spectra normal data
ax(2)=subplot(3,1,2:3);
% variance preserving by fxpsd
l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255);
semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255);
xlim([2 100])
set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200 400],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200 400],'FontSize',10)
set(gca,'XDir','reverse')
set(gca,'XMinorTick','off')
% ylim([0 0.15])
ylabel({'Chl-a variance', '(mg m^{-2}) ^2'});
xlabel('Period (hours)')
ylim([0 0.1]);
set(gca, 'YScale', 'log')
%% plot spectra  data
% % Here I have set a window length to be half the length of the time series
% % and overlapped the windows by 50%  - the result is the average of spectra calculated 
% % from each of these (overlapping) windows                               
%     window = floor(length(d_nrm) ./5); % Window length 
%     noverlap = floor(window./2); % Window overlap
%     deltaT = 1; % Sampling interval in hours 
%     fs = 1; % samples per hour
%     nfft = window;
%     
% % If using the whole length of the time series     
%     fmax = 1./(2*deltaT); % Nquist interval, upper frequency limit - can't resolve periods any shorter than fmax
%     fmin = 1./(N*deltaT); % Lower frequency limit - can't resolve periods any longer fmin
%     
% % Call PSD function    
%     [Pxx,f,Pxxc] = pwelch(d_nrm,hanning(window),noverlap,nfft,fs,'onesided','ConfidenceLevel',0.90); 
%     
% % ax(3)=subplot(3,1,3);
% clf
% % variance preserving by fxpsd
% l1 = semilogx(1./f(2:end),f(2:end).*Pxx(2:end),'Color','k','LineWidth',1.5); hold on
% semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,1),'-.','Color',[128 128 128]./255);
% semilogx(1./f(2:end),f(2:end).*Pxxc(2:end,2),'-.','Color',[128 128 128]./255);
% xlim([2 30])
% set(gca,'XTick',[1 2 3 4 5 6 12 15 24 50 100 200 400],'XTickLabel',[1 2 3 4 5 6 12 15 24 50 100 200 400],'FontSize',10)
% set(gca,'XDir','reverse')
% set(gca,'XMinorTick','off')
% % ylim([0 0.15])
% ylabel({'Normalized Chl-a variance', '(mg m^{-2}) ^2'});
% xlabel('Period (hours)')

%% format and save
width=23; height=11.5; FS=8; FN='Arial';

set(ax(1:2), 'fontsize', FS, 'FontName',FN);

set(gcf,'units','centimeters','position',[5 5 width height])

export_fig(['Figures/' fname],'-png', '-transparent');
export_fig(['Figures/' fname],'-tiff', '-r300','-transparent');


