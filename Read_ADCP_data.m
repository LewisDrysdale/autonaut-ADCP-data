clearvars;
close('all');


ddir='C:\Users\sa01ld\OneDrive - SAMS\Projects\Autonaut-EE\Non-Acoustic data\batch-process';

fdrs=dir([ddir '\*Data']);

rt.Lat=[];
rt.Lon=[];
rt.v_N=[];
rt.v_E=[];
rt.binD=[];
rt.time=[];
rt.time=[];
rt.corr=[];
rt.bs=[];
rt.av_n=[];
rt.av_e=[];
rtcnt=0;

cs.Lat=[];
cs.Lon=[];
cs.v_N=[];
cs.v_E=[];
cs.binD=[];
cs.time=[];
cs.corr=[];
cs.bs=[];
cs.av_n=[];
cs.av_e=[];
cscnt=0;

for ii=1:length(fdrs)   
   dtfle=fullfile(ddir,fdrs(ii).name);
   fles=dir(dtfle);
   fles=fles(~ismember({fles.name},{'.','..'}));
   fle=fullfile(dtfle,fles.name);
   importfile(fullfile(fle))
   
   x=Nav.long_deg;
   y=Nav.lat_deg;
   
   dtnum=datenum(Sup.year,Sup.month,Sup.day,Sup.hour,Sup.minute,Sup.second);
   
   if nanmean(y)>55 & nanmean(x)<-9 % rockall data
       if rtcnt==0
           rt.v_N=Wat.vNorth;
           rt.v_E=Wat.vEast;
           rt.Lat=Nav.lat_deg;
           rt.Lon=Nav.long_deg;
           rt.binD=Wat.binDepth;
           rt.time=dtnum;
           rt.corr=Wat.correlation;
           rt.bs=Wat.backscatter;
           rt.av_e=Sup.avg_vEast;
           rt.av_n=Sup.avg_vNorth;
       else
           rt.v_N=[rt.v_N Wat.vNorth];
           rt.v_E=[rt.v_E Wat.vEast];
           rt.Lat=[rt.Lat; Nav.lat_deg];
           rt.Lon=[rt.Lon; Nav.long_deg];
           rt.binD=[rt.binD Wat.binDepth];
           rt.time=[rt.time; dtnum];
           rt.corr=cat(2,rt.corr,Wat.correlation);
           rt.av_e=cat(1,rt.av_e,Sup.avg_vEast);
           rt.av_n=cat(1,rt.av_n,Sup.avg_vNorth);
       end
      rtcnt=rtcnt+1;
   elseif nanmean(y)<55 & nanmean(x)<-9 & nanmean(y)>53% celtic sea
       if cscnt==0
           cs.v_N=Wat.vNorth;
           cs.v_E=Wat.vEast;
           cs.Lat=Nav.lat_deg;
           cs.Lon=Nav.long_deg;
           cs.binD=Wat.binDepth;
           cs.time=dtnum;
           cs.corr=Wat.correlation;
           cs.bs=Wat.backscatter;
           cs.av_e=Sup.avg_vEast;
           cs.av_n=Sup.avg_vNorth;
       else
           cs.v_N=[cs.v_N Wat.vNorth];
           cs.v_E=[cs.v_E Wat.vEast];
           cs.Lat=[cs.Lat; Nav.lat_deg];
           cs.Lon=[cs.Lon; Nav.long_deg];
           cs.binD=[cs.binD Wat.binDepth];
           cs.time=[cs.time; dtnum];
           cs.corr=cat(2,cs.corr,Wat.correlation);
           cs.bs=cat(2,cs.bs,Wat.backscatter);       
           cs.av_e=cat(1,cs.av_e,Sup.avg_vEast);
           cs.av_n=cat(1,cs.av_n,Sup.avg_vNorth);
       end
      cscnt=cscnt+1;
   end

end

save('rt_data.mat','-struct','rt');
save('cs_data.mat','-struct','cs');
