% The idea is you have a set of experimental data {Yi} (i=1 to N). These might be responses collected in N different conditions, for example.
% The mean is
% 
% M = sum{Yi} / N
% 
% and the variance about this mean is the total variance
% 
% TV = var(Yi) = sum{ (Yi-M)^2 } / N
% 
% Now suppose you have some model or fit which predicts values Fi. The residuals between the fit and the data are Ri=(Yi-Fi). The mean of the residuals is = M – F, where F is the mean fit value, sum {Fi} / N.
% To see how good the fit is, compute the variance of the residuals:
% 
% RV = var(Yi-Fi) = sum { (Yi - Fi - M + F)^2 } / N
% 
% The variance which has been removed by the fit is the “explained variance”:
% 
% EV = TV-RV.
% 
% In a perfect world, Fi would be equal to Yi for all i, and therefore these residuals would all be zero. RV=0 and thus all of the variance is explained. The other end of the spectrum is where all the fit values are the same, just equal to the mean of the data: Fi=F. Then we can see from the equations above that RV=TV and none of the variance is explained.
% The percentage of variance which is explained is
% 
% PV = 100(TV-RV)/TV.