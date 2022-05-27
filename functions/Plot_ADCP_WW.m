clear; close;
load ../CCS_data/adcp/ccs_adcp.mat
%% use rich pawolwizc t_tide
% mean_vel = NaN(size(ve));mean_tvel = NaN(size(ve));
% 
% for i = 8:57
%     [theta,rho] = cart2compass(ve(i,:),vn(i,:));
%     [tidestruc,pout]=t_tide(rho,...
%         'interval',0.0833, ...            % 0.0833 of an hour (5 mins)
%         'start',dd(1),...                 % start time is datestr(tuk_time(1))
%         'latitude',49.4);                 % Latitude of obs
%     mean_tvel(i,1:length(pout)) = pout;
%     mean_vel(i,1:length(rho)) = rho;
% end
% 
% mean_detide_vel = mean_vel-mean_tvel;
% subplot(311)
% [c,h] = contourf(dd,mab(8:57),mean_vel(8:57,:),'Linecolor','none');
% subplot(312)
% [c,h] = contourf(dd,mab(8:57),mean_tvel(8:57,:),'Linecolor','none');
% subplot(313)
% [c,h] = contourf(dd,mab(8:57),mean_detide_vel(8:57,:),'Linecolor','none');

%% subsample and use the MSL data (Colin Bell)
ss_dd = dd([7:12:24355 24366:12:42450 42469:12:68389 68409:12:end]); 
ds = datevec(ss_dd); dvdta = datenum(ds);
vel_n = vn(:,[7:12:24355 24366:12:42450 42469:12:68389 68409:12:end]); 
vel_e = ve(:,[7:12:24355 24366:12:42450 42469:12:68389 68409:12:end]); 

% load tidal predictions. Have ot split in to 2 as the formatting of the
% text file provided is different when the 
fname = '../Tidal_Data/Tide_data_CCS_2014_5_copy.txt';
fid   = fopen(fname,'r');
format = ('%s %s %f %f %d %f %f');
C = textscan(fid,format,'HeaderLines',5);
lev = C{3};
spd = C{4};
dir = C{5};
U   = C{6}; 
V   = C{7};
td1 = datenum('1-1-2014');
td2 = datenum('1-1-2016');
tdt = td1:1/24:td2; tdt= tdt(:);
pred_dnum = datenum(datevec(tdt));
dvec = datevec(pred_dnum);
% find id of tidal predictions in the adcp data
id = ismember(pred_dnum,dvdta);

pred_e = U(id); pred_e = pred_e';
pred_n = V(id); pred_n = pred_n';

dt_e   = vel_e-pred_e;
dt_n   = vel_n-pred_n;

[thetaR,rhoR]   = cart2pol(vel_e,vel_n);
[theta,rho]     = cart2pol(dt_e,dt_n);
[ptheta,prho]   = cart2pol(U,V);


jd1 = datenum('12:00:00 13-July-2015')
jd2 = datenum('12:00:00 27-July-2015')
[c d1] = min(abs(jd1-dvdta));
[c d2] = min(abs(jd2-dvdta));

feather(dt_e(10,d1:d2),dt_n(10,d1:d2));

figure(1);
set(gcf,'pos',[ 99   41   1009   795]);
set(gcf,'color',[1 1 1]);

ax(1) = subplot(311)
[c,h] = contourf(dvdta,mab(8:57),rho(8:57,:),'Linecolor','none');
C = colorbar;    colormap(ax(1),brewermap([16],'Greys'));
caxis([0 0.2]);C.Label.String ='Speed m s^[-1}';
ylim([0 150]); ylabel('Bin depth');
axis ij

ax(2) = subplot(312)
[c,h] = contourf(ss_dd,mab(8:57),rhoR(8:57,:),'Linecolor','none');
C = colorbar;    colormap(ax(2),brewermap([16],'Blues'));
caxis([0 0.8]); C.Label.String ='Speed m s^[-1}';
ylim([0 150]);ylabel('Bin depth');
axis ij 

ax(3) = subplot(313)
h1 = plot(tdt,prho);
xlim([tdt(1) tdt(end)]);

for i=1:numel(ax)
xlim(ax(i),[tdt(1) tdt(end)]);
datetick(ax(i),'x','mm','Keeplimits','Keepticks');
xlabel(ax(i),'2014  - Year  -  2015');
end

fname = ['Figures/ADCP_overview'];
export_fig(fname,'-png');
