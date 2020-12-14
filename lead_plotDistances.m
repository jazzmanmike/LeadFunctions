function lead_plotDistances( stats )
%LEAD_PLOTDISTANCES Makes electrode distance-to-target Violin plots
%
%   lead_plotDistances(stats);
%
%   Inputs: stats,      matrix of Lead-DBS distances
%                       (e.g. 'stats' from lead_loadImaging.m)
%
%   Outputs: saves .eps figure of electrode distances in working directory
%
%
% Michael Hart, University of British Columbia, December 2020

%% Lets go!

nSubjects = size(stats, 1);
plot_data = zeros(nSubjects, 2, 2); 
plot_data(:,:,2) = stats(:, [1,2]); %right nucleus & motor
plot_data(:,:,1) = stats(:,[5,6]); %left nucleus & motor
labels = {'Overall nucleus'; 'Motor nucleus'};
sides = {'left'; 'right'};
figure('color','w');
h = iosr.statistics.boxPlot(labels, plot_data, ...
    'showViolin', true, ...
    'boxWidth', 0.025, ...
    'showOutliers', true, ...
    'showScatter', true, ...
    'boxColor', '[0.8 0.8 0.8]', ...
    'violinColor', '[0.7 0.7 0.7]', ...
    'scatterMarker', 'o', ...
    'scatterSize', 50, ...
    'groupLabels', sides, ...
    'showLegend', true, ...
    'xSeparator', true, ...
    'theme', 'colorall', ...
    'scatterColor', '[1 1 1]');
box on
grid on
hTitle = title('Electrode distances');
hYLabel = ylabel('Distance (mm)');
hXLabel = xlabel('Target');

set(gca, 'FontName', 'Helvetica', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 plot_electrode_distances.eps
close(gcf);