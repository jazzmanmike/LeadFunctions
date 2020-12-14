function [ Stats ] = lead_outcome_stats( outcome )
%LEAD_OUTCOME_STATS Calculates some basic statistics on outcomes
%
%   Stats = lead_outcome_stats(outcome);
%   
%   Inputs:     outcome,    DBS outcome (vector)
%
%   Outputs:    Stats,      summary satistics
%
% Michael Hart, University of British Columbia, December 2020

%% Lets go!

%initialise
stats = zeros(9,1);

%remove nans
outcome = outcome(~isnan(outcome));

% mean
meanMeasure = mean(outcome);

% standard deviation
sigmaMeasure = std(outcome);

% median
medianMeasure = median(outcome);

% range
rangeMeasure = range(outcome);

% STEP 1 - rank the data
y = sort(outcome);

% compute 25th percentile (first quartile)
Q(1) = median(y(find(y<median(y))));

% compute 50th percentile (second quartile)
Q(2) = median(y);

% compute 75th percentile (third quartile)
Q(3) = median(y(find(y>median(y))));

% compute Interquartile Range (IQR)
IQR = Q(3)-Q(1);

% compute Semi Interquartile Deviation (SID)
% The importance and implication of the SID is that if you 
% start with the median and go 1 SID unit above it 
% and 1 SID unit below it, you should (normally) 
% account for 50% of the data in the original data set
SID = IQR/2;

% determine extreme Q1 outliers (e.g., x < Q1 - 3*IQR)
iy = find(y<Q(1)-3*IQR);
if length(iy)>0,
    outliersQ1 = y(iy);
else
    outliersQ1 = [];
end

% determine extreme Q3 outliers (e.g., x > Q1 + 3*IQR)
iy = find(y>Q(1)+3*IQR);
if length(iy)>0,
    outliersQ3 = y(iy);
else
    outliersQ3 = [];
end

% compute total number of outliers
Noutliers = length(outliersQ1)+length(outliersQ3);

%% Parse outputs

% make structure
Stats(1) = meanMeasure;
Stats(2) = sigmaMeasure;
Stats(3) = medianMeasure;
Stats(4) = rangeMeasure;
Stats(5) = Q(1);
Stats(6) = Q(2);
Stats(7) = Q(3);
Stats(8) = SID;
Stats(9) = Noutliers;

% display results
disp(['Mean:                                ',num2str(meanMeasure)]);
disp(['Standard Deviation:                  ',num2str(sigmaMeasure)]);
disp(['Median:                              ',num2str(medianMeasure)]);
disp(['Range:                               ',num2str(rangeMeasure)]);
disp(['25th Percentile:                     ',num2str(Q(1))]);
disp(['50th Percentile:                     ',num2str(Q(2))]);
disp(['75th Percentile:                     ',num2str(Q(3))]);
disp(['Semi Interquartile Deviation:        ',num2str(SID)]);
disp(['Number of outliers:                  ',num2str(Noutliers)]);

end

