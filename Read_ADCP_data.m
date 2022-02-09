clearvars;
close('all');

ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\batch-process';

fdrs=dir([ddir '\*Data']);

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

for ii=1:length(fdrs)   
   dtfle=fullfile(ddir,fdrs(ii).name);
   fles=dir(dtfle);
   fles=fles(~ismember({fles.name},{'.','..'}));
   fle=fullfile(dtfle,fles.name);
   importfile(fullfile(fle))
   
   x=Nav.long_deg;
   y=Nav.lat_deg;
   
   m_plot(x,y,'.','MarkerSize',15)
   
end
