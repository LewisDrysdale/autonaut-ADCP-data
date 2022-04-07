clearvars;
close('all');


ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\batch-process-GNSS';

fdrs=dir([ddir '\*Data']);

fname='C:\Users\sa01ld\OneDrive - SAMS\GEBCO\gebco_2021_n68.75244140625_s46.12060546875_w-27.6416015625_e2.9443359375.nc'
lats=ncread(fname,'lat');lats=flipud(lats);
lons=ncread(fname,'lon'); 
lev=ncread(fname,'elevation');lev=rot90(lev);
lev(lev>0)=NaN;

[X,Y] = meshgrid(lons,lats);
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
m_contourf(X,Y,lev,100,'Linecolor','none');
cmocean('-Deep')
colorbar
m_gshhs_f('patch',[0.9000    0.9000    0.9000]);
hold on;
m_grid('linewidth',1.5,'linest','none','tickdir','out','fontsize',16,...
'Fontweight','bold','FontName','Times');
set(findobj('tag','m_grid_color'),'facecolor','none')
[x,y]=m_ll2xy(Lon,Lat);
p=plot(x,y);
p.MarkerFaceColor='r';
p.MarkerEdgeColor='k';
p.Marker='^';
p.MarkerSize=5;
p.LineStyle='none';


print(gcf,'-dpng','figures/track');