clearvars;
close('all');


ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\batch-process-GNSS';

fdrs=dir([ddir '\*Data']);


Lat=[];
Lon=[];
time=[];

cnt=0;

for ii=1:length(fdrs)   
   dtfle=fullfile(ddir,fdrs(ii).name);
   fles=dir([dtfle '\*.mat']);
   fles=fles(~ismember({fles.name},{'.','..'}));
   fle=fullfile(dtfle,fles.name);
   importfile(fullfile(fle))
   dtnum=datenum(Sup.year,Sup.month,Sup.day,Sup.hour,Sup.minute,Sup.second);
   
       if cnt==0
           Lat=Nav.lat_deg;
           Lon=Nav.long_deg;
           time=dtnum;
       else
           Lat=[Lat; Nav.lat_deg];
           Lon=[Lon; Nav.long_deg];
           time=[time; dtnum];

       end
       cnt = cnt+1;
   
end

%%
figure; 
set(gcf,'color',[1 1 1]);set(gcf,'pos',[1  41  1280  907]);
% first map
res=1; 
proj =('lambert');
m_proj(proj,'lon',[-17 0],'lat',[52.1 57.4]);
m_gshhs_f('patch',[0.9000    0.9000    0.9000]);
hold on;
m_grid('linewidth',1.5,'linest','none','tickdir','out','fontsize',16,...
'Fontweight','bold','FontName','Times');
set(findobj('tag','m_grid_color'),'facecolor','none')

m_scatter(Lon,Lat,20,time,'filled');
colorbar
cbdate

m_55 & nanmean(x)<-9 % rockall data


title('Autonaut EE ADCP data');

print(gcf,'-dpng','figures/track');