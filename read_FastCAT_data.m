clearvars; close('all')

ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\SBE_FastCat_CTD_49_01\2021';
fdrs=dir(ddir);
fdrs=fdrs(~ismember({fdrs.name},{'.','..'}));

fles=dir([fullfile(ddir,fdrs(2).name) '\SBE_FastCat_CTD_49_01_2021_08_2*']);
fles=fles(~ismember({fles.name},{'.','..'}));
%% salinity

cnt=1;

for jj=1:numel(fles)
    fle=fullfile(ddir,fdrs(2).name,fles(jj).name);
    SCAT_data = read_SBE49(fle);
    x=datetime(SCAT_data.DateString,'InputFormat','yyyy/MM/dd HH:mm:ss.S');
    y=SCAT_data.Salinity;
    t=SCAT_data.Temperature;
    if cnt==1
        time=x;
        salt=y;
        temp=t;
    else
        time=[time;x];
        salt=[salt;y];
        temp=[temp;t];
    end
    cnt=cnt+1;
    clear x y t
end
%%
figure;
% plot TS with some questionable salinities
plot(salt,temp,'.'); grid on;

% User input: draw polygon of data to keep, finish by using double-click
roi = drawpolygon;
polyx = roi.Position(:,1);
polyy = roi.Position(:,2);
IN = inpolygon(salt,temp,polyx,polyy);

% Set all rejected salinities to NaN
salt(~IN==0) = nan;
temp(~IN==0) = nan;

% replot figure
clf;
plot(salt,temp,'.')
%%
figure;
t = tiledlayout(3,1);
nexttile;
x=time;
y = salt;
[Y,dx,ndx] = ddspike(y,[-0.5 0.5],4,5,'n');
ix=Y==-9999;
Y(Y==-9999)=NaN;
h1=plot(x,Y,'b.','Color',[0.6 0.6 0.6]);
mmy=movmean(Y,30);
hold on
h2=plot(x,mmy,'k-');
title('')
ylabel('')
grid on

nexttile;
x=time;
y = temp;
ix=Y==-9999;
y(Y==-9999)=NaN;
h1=plot(x,y,'b.','Color',[0.6 0.6 0.6]);
mmy=movmean(y,30);
hold on
h2=plot(x,mmy,'k-');
title('');
ylabel('Temperature (^o C)');
grid on



print(gcf,'-dpng',['figures/sal_example']);

%% speed of sound
figure
for jj=1:numel(fles)
    fle=fullfile(ddir,fdrs(2).name,fles(jj).name);
    SCAT_data = read_SBE49(fle);
    if jj==1
        x=datetime(SCAT_data.DateString,'InputFormat','yyyy/MM/dd HH:mm:ss.S');
        y=SCAT_data.SoundVelocity;
    else
        x=[x; datetime(SCAT_data.DateString,'InputFormat','yyyy/MM/dd HH:mm:ss.S')];
        y=[y; SCAT_data.SoundVelocity];
    end

end
plot(x,y,'b-');
hold on
plot([x(1) x(end)],[nanmean(y) nanmean(y)],'r-');
ylim([floor(min(y)) ceil(max(y))])
title('Speed of sound')
ylabel('m/s')

print(gcf,'-dpng',['figures/SOS_example']);
