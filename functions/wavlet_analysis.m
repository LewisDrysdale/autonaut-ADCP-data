clear; close;

% ax_arry path to wavelet toolbox from 
% https://AMM7w.glaciology.net/publication/2004-12-24-application-of-the-cross-wavelet-transform-and-wavelet-coherence-to-geophysical-time-series/
addpath('wavelet-coherence-master')

% run model and pbs extraction file
run interpolate_MODEL_OBS.m

%%

% date range
jd1 = datenum(2015,7,13,0,0,0); jd2 =  datenum(2015,7,27,0,0,0);
jd1 = datenum(2015,6,15,0,0,0); jd2 =  datenum(2015,7,22,0,0,0);

[c d1] = min(abs(jd1-AMM7dd));
[c d2] = min(abs(jd2-AMM7dd));

% date range
x1=AMM7dd(d1);
x2=AMM7dd(d2);
x_arry=x1:1/24:x2;

% number of hours
nhours = numel(d1:d2);

% model data
CHL=AMM7sum_chl(:,d1:d2);
DNS=AMM7_pRho(:,d1:d2);
depth=AMM7depth(:,d1:d2);
% SML=AMM7_sml(:,d1:d2);
% BML=AMM7_bml(:,d1:d2);

% for ii=1:nhours
%     % make temporya nan arrays to cmoppemsate for different postion of SCM
%     if  ~isnan(SML(ii)) & ~isnan(BML(ii))
%     dta1=depth(SML(ii):BML(ii),ii);
%     dta2=data(SML(ii):BML(ii),ii);
%     intmod(ii)=trapz(dta1);
%     end
% end

% CLOSEST TO SCM FOR MODEL
ispcnl=26.9;

% CLOSEST ISOPYCNAL TO SCM FOR MODEL
[~, d] = min(abs(ispcnl-DNS));
obsdata=depth(d);
d_min=min(obsdata);
d_max=max(obsdata);

d_nrm=(obsdata-d_min)/(d_max-d_min);
id = isfinite(d_nrm);
ndata=d_nrm(id);

% remove nans
id = isfinite(ndata);
ndata=ndata(id);

x_arry=x_arry(id);

[D, PD] = allfitdist(ndata, 'PDF');
%%
clf
figure(1);
ax(1)=subplot(4,1,1:2)
wt_vLD(ndata);
colormap(brewermap( 12,'GnBu'))

% 2 MONTH ANALYSIS
xticks([1 200 400 600 800 880]);
xticklabels([datestr(x_arry(1),'dd-mmm') 
    datestr(x_arry(200),'dd-mmm') 
    datestr(x_arry(400),'dd-mmm') 
    datestr(x_arry(600),'dd-mmm') 
    datestr(x_arry(800),'dd-mmm')
    datestr(x_arry(880),'dd-mmm')]);

% 2 WEEK ANALYSIS
% xticks([1 50 100 150 200 250 300]);
% xticklabels([datestr(x_arry(1),'x_arry-mmm') 
%     datestr(x_arry(50),'x_arry-mmm') 
%     datestr(x_arry(100),'x_arry-mmm') 
%     datestr(x_arry(150),'x_arry-mmm') 
%     datestr(x_arry(200),'x_arry-mmm')
%     datestr(x_arry(250),'x_arry-mmm')
%     datestr(x_arry(300),'x_arry-mmm')])

ylabel({'Period (Hours)'});
xlabel('')

ax(2)=subplot(4,1,3);
pos=get(ax(2),'Position');
set(ax(2),'Position',[pos(1) pos(2) pos(3)-0.08 pos(4)]);
x_arry=AMM7dd(d1:d2);
plot(x_arry,ndata,'k-', 'LineWidth',1.5);
xlim([x_arry(1) x_arry(end)]);
xticks([x_arry(1):5:x_arry(end)]);
xticklabels(datestr(xticks,'x_arry-mmm'))
ylabel('');
xlabel('2015');

% Tide data
[levs,spd,dir,U,V,dvec] = fun_read_MDP_tide('/work/lewysd/CAMPUS/Tidal_Data/Tide_data_CCS_2014_5_copy.txt');
dvdta = datenum(dvec);

ax(3)=subplot(4,1,4);
pos=get(ax(3),'Position');
set(ax(3),'Position',[pos(1) pos(2) pos(3)-0.08 pos(4)]);
plot(dvdta,levs,'k-', 'LineWidth',1.5);
xlim([x_arry(1) x_arry(end)]);
xticks([x_arry(1):7:x_arry(end)]);
xticklabels(datestr(xticks,'dd-mmm'))
ylabel('Tidal Elevation (m)');
xlabel('2015');

%%
% filename
fname='Figures/AMM7_wavelet_2month';
    
width=9.5; height=11.5; FS=8; FN='Arial';
width=23; height=9.5; FS=8; FN='Arial';
set(ax(1:3),'FontSize',FS,'FontName',FN);
set(gcf,'units','centimeters','position',[5 5 width height])
export_fig(fname,'-png', '-transparent');
export_fig(fname,'-tiff', '-r300','-transparent');