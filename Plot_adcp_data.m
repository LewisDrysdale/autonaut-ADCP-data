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

%% PLOT BY BIN
% NORTH
% figure('Renderer', 'painters', 'Position', [10 20 1200 900])
% x=time';
% y=v_N/100;
% for j=1:length(y(:,1))
%     ax(j)=subplot(6,3,j);
%     plot(x,y(j,:));
%     grid on
%     xlim([x(1) x(end)])
%     xticks(x(1):6/24:x(end))
%     xticklabels(datestr(x(1):6/24:x(end),'HH:MM dd-mmm'))
%     ylabel('v-north m/s')
%     title(['Bin ' num2str(j) ' = ' num2str(binD(j,1)) ' m'])
% end
% sgtitle([name ' V - North']) 
% print(gcf,'-dpng',['figures/' name '_V_north_1minAverage']);
% 
% % EAST
% figure('Renderer', 'painters', 'Position', [10 20 1200 900])
% x=time';
% y=v_E/100;
% for j=1:length(y(:,1))
%     ax(j)=subplot(6,3,j);
%     plot(x,y(j,:));
%     grid on
%     xlim([x(1) x(end)])
%     xticks(x(1):6/24:x(end))
%     xticklabels(datestr(x(1):6/24:x(end),'HH:MM dd-mmm'))
%     ylabel('v-east m/s')
%     title(['Bin ' num2str(j) ' = ' num2str(binD(j,1)) ' m'])
% end
% sgtitle([name ' V - East']) 
% print(gcf,'-dpng',['figures/' name '_V_east_1minAverage']);

% %% plot against each othr 
% figure('Renderer', 'painters', 'Position', [10 20 1200 900])
% x=v_N/100;
% y=v_E/100;
% legstr={};
% for j=1:length(y(:,1))
%     h(j)=plot(x(j,:),y(j,:),'.');
%     legstr{j}=['Bin ' num2str(j)];
%     hold on
% end
% xlabel('v-north m/s')
% ylabel('v-east m/s')
% title([name]) 
% 
% legend(h,legstr);
% print(gcf,'-dpng',['figures/' name '_north_vs_east_1minAverage']);

%% plotvelocity
x=time';
y=binD(:,1);
figure('Renderer', 'painters', 'Position', [10 20 1600 600])
z=v_E/100;
subplot(2,1,1);
imagesc(x,y,z);  
c=colorbar;
caxis([-2 2]);
cmocean('balance','pivot',0);
datetick('x','HH:MM dd-mmm','keeplimits');
ylabel('Depth')
ylabel(c,'')
grid on
title([name ' Velocity East' ]);

subplot(2,1,2);
z=v_N/100;
imagesc(x,y,z);  
c=colorbar;
caxis([-2 2]);
cmocean('balance','pivot',0)
datetick('x','HH:MM dd-mmm','keeplimits');
ylabel('Depth')
ylabel(c,'')
grid on
title([name ' Velocity North' ]);
print(gcf,'-dpng',['figures/' name '_Velocities2']);


%% plot backscatter and correlation
x=time';
y=binD(:,1);
% four beams
for dd=1:4
   figure('Renderer', 'painters', 'Position', [10 20 1600 600])
   z=squeeze(corr(:,:,dd));
   z=double(z);
   z(z==0)=NaN;
   imagesc(x,y,z);  
   c=colorbar;
   cmocean('amp')
   datetick('x','dd-mmm')
   ylabel('Depth')
   ylabel(c,'% good')
   grid on
   title(['Beam ' num2str(dd) ]);
   print(gcf,'-dpng',['figures/' name '_correlation Beam2 ' num2str(dd)]);
end

%% plot backscatter and correlation
x=time';
y=binD(:,1);
figure('Renderer', 'painters', 'Position', [10 20 1600 600])
% four beams
for dd=1:4
   ax(dd)=subplot(2,2,dd);
   z=squeeze(bs(:,:,dd));
   z=double(z);
   z(z==0)=NaN;
   imagesc(x,y,z);  
   c=colorbar;
   cmocean('tempo')
   datetick('x','dd-mmm')
   ylabel('Depth')
   ylabel(c,'')
   grid on
   title(['Beam ' num2str(dd) ]);
end
sgtitle([name ' backscatter ']) ;
print(gcf,'-dpng',['figures/' name 'backscatter2']);
%% quiver plot
figure('Renderer', 'painters', 'Position', [10 20 500 500])
X=Lon;
Y=Lat;
U=gpsVeast;
V=gpsVnorth;

n = 600;             % Number of elements to create the mean over
% hourly mean of U
s1 = size(U, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(U(1:m), n, []);     % Reshape x to a [n, m/n] matrix
gpsu_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of V
s1 = size(V, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(V(1:m), n, []);     % Reshape x to a [n, m/n] matrix
gpsv_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of Lat
s1 = size(Lat, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(Lat(1:m), n, []);     % Reshape x to a [n, m/n] matrix
Lat_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of Lon
s1 = size(Lon, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(Lon(1:m), n, []);     % Reshape x to a [n, m/n] matrix
Lon_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim


q1 = quiver(X,Y,U,V,'AutoScale','on', 'AutoScaleFactor',3,'LineWidth',0.1,...
    'Color', [17 17 17]/255);
hold on
q2 = quiver(Lon_avg,Lat_avg,gpsu_avg,gpsv_avg,'AutoScale','on', 'AutoScaleFactor',3,'LineWidth',1.5,...
    'Color','b');
axis equal
ylabel('Latitude')
xlabel('Longitude')

legend([q1 q2],'Sample','10 minute average');
title([name ' GPS velocity']) 

print(gcf,'-dpng',['figures/' name '_GPS_velocity2']);

%% quiver plot
figure('Renderer', 'painters', 'Position', [10 20 500 500])
X=Lon;
Y=Lat;
U=av_e;
V=av_n;

n = 600;             % Number of elements to create the mean over
% hourly mean of U
s1 = size(U, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(U(1:m), n, []);     % Reshape x to a [n, m/n] matrix
u_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of V
s1 = size(V, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(V(1:m), n, []);     % Reshape x to a [n, m/n] matrix
v_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of Lat
s1 = size(Lat, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(Lat(1:m), n, []);     % Reshape x to a [n, m/n] matrix
Lat_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim

% hourly mean of Lon
s1 = size(Lon, 1);      % Find the next smaller multiple of n
m  = s1 - mod(s1, n);
y  = reshape(Lon(1:m), n, []);     % Reshape x to a [n, m/n] matrix
Lon_avg = transpose(sum(y, 1) / n);  % Calculate the mean over the 1st dim


quiver(X,Y,U,V,'AutoScale','on', 'AutoScaleFactor',3,'LineWidth',0.1,...
    'Color','k');
hold on
q1 = quiver(Lon_avg,Lat_avg,gpsu_avg,gpsv_avg,'AutoScale','on', 'AutoScaleFactor',3,'LineWidth',1,...
    'Color','b');
hold on
q2 = quiver(Lon_avg,Lat_avg,u_avg,v_avg,'AutoScale','on', 'AutoScaleFactor',3,'LineWidth',1,...
    'Color','r');

axis equal
ylabel('Latitude')
xlabel('Longitude')

legend([q1 q2],'GPS Velocity 10 min average','ADCP velocity 10 min average');
title([name]) 

print(gcf,'-dpng',['figures/' name '_vector_plot2']);
