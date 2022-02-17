clearvars; close('all')

ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\SBE_FastCat_CTD_49_01\2021';
fdrs=dir(ddir);
fdrs=fdrs(~ismember({fdrs.name},{'.','..'}));

fles=dir([fullfile(ddir,fdrs(2).name) '\SBE_FastCat_CTD_49_01_2021_08_2*']);
fles=fles(~ismember({fles.name},{'.','..'}));
%% salinity
figure
for jj=1:numel(fles)
    fle=fullfile(ddir,fdrs(2).name,fles(jj).name);
    SCAT_data = read_SBE49(fle);
    x=datetime(SCAT_data.DateString,'InputFormat','yyyy/MM/dd HH:mm:ss.S');
    y=SCAT_data.Salinity;
    [Y,dx,ndx] = ddspike(y,[-5 5],4,5,'n');
    plot(x,y,'k.');
    hold on
    plot(x,Y,'r.');

end

ylim([35.1 35.2])

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