function [daynum,dd,date] = dates(startdate,enddate,int)
% [daynum,dd,date] = dates(startdate,enddate,int)
% Function that creates a vector of daynumbers (daynum),decimal days (dd)
% and strings of dates (date) given a startdate, enddate, and interval (in
% SECONDS).
% e.g. startdate = '05-Jun-2010 17:00:00'; 
%      enddate =  '18-Jun-2010 10:00:00';
%      int = 60 (seconds)

% Create independant vector of dates
    a = datenum(startdate);
    b = datenum(enddate);

% Create a serial basedate
    basedate = datenum('01-Jan-1970 00:00:00','dd-mmm-yyyy HH:MM:SS');

% Create vector of times starting at 'a' and ending at 'b'

    aepoch = (a - basedate) * (24*60*60);
    bepoch = (b - basedate) * (24*60*60);

    tvec =  [ aepoch : int : bepoch ].'; %Epochal time (seconds)
    

% Divide by 24*60*60 to convert to a serial date number that represents the
% whole and fractional number of days from a specific date and time (basedate)
    date =  datestr((tvec ./ (24*60*60))+basedate);
    dd = datenum(date);
    
% Convert dd into year day

    dtmp = datestr(dd,'ddmmyy');
    hrs_tmp = str2num( datestr(dd,'HH') );
    min_tmp = str2num( datestr(dd,'MM') );
    sec_tmp = str2num( datestr(dd,'SS') );
    
    decimal_hrs = (hrs_tmp + (min_tmp./60))./24;
    
    for ind = 1:size(date,1)
        
        day(ind) = datetojulian(dtmp(ind,:)) + decimal_hrs(ind);
        
    end
    
    daynum = day.'; 
    
    date = datestr(dd);
    
end
    
   