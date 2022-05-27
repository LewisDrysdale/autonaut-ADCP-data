close('all'); clearvars;

cs=0;
rt=1;
ll=0;

if cs==1
    load cs_data.mat
    name='Celtic-Sea';
elseif rt==1
    load rt_data.mat
    name='Rockall-Trough';
elseif ll==1
    load ll_data.mat
    name='Loch-Linnhe';
end

%% step 1-2 temporally align ancillary data 
% transform from beam to cartesian coordinates?

% calcualte single ping velocities - ADCP
adpvel=(sqrt((v_E.^2)+(v_N.^2)))/100;

% calcualte velocities - GPS
gpsvel=sqrt((av_e.^2)+(av_n.^2));

% ensemble averaging?
y = movmean(gpsvel,100);
x=time;

figure('Renderer', 'painters', 'Position', [10 20 1200 500])

for ii=1:17
    id=isfinite(adpvel(ii,:));
    X=time(id);
    adp_lp = filt1('lp',adpvel(ii,id),'Tc',100,'order',5);
    h(ii)=plot(X,adp_lp);
    hold on
    legstr{ii}=['Bin ' num2str(ii)];

end
legstr{ii+1}=['GPS velocity'];
h(ii+1)=plot(x,y,'--k','LineWidth',2);
datetick('x')
grid on
legend(legstr)

ylabel('m/s')
title([name ' low pass filtered velocity'])

print(gcf,'-dpng',['figures/' name 'align_velocity_GPS']);

%% step 3 edit single ping data
 
%% step 4 ships heading estimate

figure('Renderer', 'painters', 'Position', [30 50 1200 500])
x=time;
y=gpsHead;
Y=sensHead;
xlin=[1:1:numel(x)];
h1=plot(xlin,Y,'+');
hold on
h2=plot(xlin,y,'.');
% remove dubious values from data
strt=13998;
endd=21722;
y(strt:endd)=NaN;
h3=plot(xlin,y,'.');
legend('Sensor heading','GPS heading','GPS bad values removed')
grid on
title([name ' heading'])

print(gcf,'-dpng',['figures/' name 'heading']);
%%
figure('Renderer', 'painters', 'Position', [30 50 1200 500])
yy=y-Y
h1=plot(x,yy,'+');
mean_diff=nanmean(yy)