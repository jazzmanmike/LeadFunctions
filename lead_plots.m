%% Lead Figures
%
% Script for reproducing Lead-DBS analysis figures
%
% Michael Hart, University of Cambridge, August 2018

%% Load data

%gpi
gpigroupleaddata = readtable('/Users/michaelhart/Dropbox/DBS/DBS_datafiles/gpi_group_lead_data.csv');

%stn & UPDRS & PDQ3
stngroupleaddata = readtable('/Users/michaelhart/Dropbox/DBS/DBS_datafiles/stn_group_lead_data.csv');
stngroupleaddata = standardizeMissing(stngroupleaddata, Inf);

%% Figure 1: mm plots

%GPi
plot_data = zeros(10,2,2);
data = table2array(gpigroupleaddata);
plot_data(:,:,1) = data(:,[1,2]);
plot_data(:,:,2) = data(:,[5,6]);
labels = {'GPi'; 'GPi motor'};
sides = {'right'; 'left'};
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
hTitle = title('Electrode distances: GPi');
hYLabel = ylabel('Distance (mm)');
hXLabel = xlabel('Target');

set(gca, 'FontName', 'Helvetica', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 figure1a.eps
close;

%STN
plot_data = zeros(14,2,2);
data = table2array(stngroupleaddata);
plot_data(:,:,1) = data(:,[1,2]); %right nucleus & motor
plot_data(:,:,2) = data(:,[5,6]);
labels = {'STN'; 'STN motor'};
sides = {'right'; 'left'};
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
hTitle = title('Electrode distances: STN');
hYLabel = ylabel('Distance (mm)');
hXLabel = xlabel('Target');

set(gca, 'FontName', 'Helvetica', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 figure1b.eps
close(gcf);

%% Figure 2a: STN motor VAT versus UPDRS3 version 1 data

STN_UPDRS = [-80 79; -70 84; -66 87; -52 72; -50 88; -29 69; -24 65];
STNm_UPDRS = [-80 55; -70 45; -66 64; -52 20; -50 55; -29 34; -24 28];
STN_PDQ = [-69 78; -60 87; -41 73; -11 69; -2 89; 0 84];
STNm_PDQ = [-69 54; -60 64; -41 20; -11 35; -2 55; 0 47];

%UPDRS
[fitresult, goodness, fitoutput] = fit(STNm_UPDRS(:, 2), STNm_UPDRS(:, 1), 'poly1');
mdl = fitlm(STNm_UPDRS(:, 2), STNm_UPDRS(:, 1));
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
figure('color', 'w');
hold on;
H = plot(mdl);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('STN motor VAT and UPDRS3 change');
hXLabel = xlabel('STN motor VAT');
hYLabel = ylabel('UPDRS3 change');
%hText = text(55, -55, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = text(53, -57, sprintf('r = %.2g, p = %.2g', -0.57, 0.08));

%Adjust font & axes properties
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);

set(legend, 'Box', 'off');

%Export to EPS
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, 'figure2a.tif');
%print -depsc2 figure2a.eps
close(gcf);

%% Figure 2b: STN motor VAT versus PDQ39 [version 2 data]

[fitresult, goodness, fitoutput] = fit(STNm_PDQ(:, 2), STNm_PDQ(:, 1), 'poly1');
mdl = fitlm(STNm_PDQ(:, 2), STNm_PDQ(:, 1));
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
figure('color', 'w');
hold on;
%plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');
H = plot(mdl);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 12, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('STN motor VAT and PDQ39 change');
hXLabel = xlabel('STN motor VAT');
hYLabel = ylabel('PDQ39 change');
%hText = text(50, -20, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = text(50, -20, sprintf('r = %.2g, p = %.2g', -0.43, 0.19));

%Adjust font & axes properties
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);

set(legend, 'Box', 'off', 'location', 'northeast');

%Export to EPS
set(gcf, 'PaperPositionMode', 'auto');	
saveas(gcf, 'figure2b.tif');
%print -depsc2 figure2b.tiff
close(gcf);

%% Figure 2: STN motor VAT versus UPDRS3 version 2 data

%Structure data
data = table2array(stngroupleaddata);
STN = data(:, 3) + data(:, 7);
STN_motor = data(:, 4) + data(:, 8);
UPDRS = data(:, 9);
PDQ = data(:, 10);
I = find(isnan(UPDRS));
UPDRS(I) = [];
STN(I) = [];
STN_motor(I) = [];

%Do fits
[fitresult, goodness, fitoutput] = fit(STN_motor, UPDRS, 'poly1');
CI = predint(fitresult, STN_motor, 0.95, 'function', 'off');
mdl = fitlm(STN_motor, UPDRS);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
figure('color', 'w');
hold on;
H = plot(mdl);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], 'r');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 14, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('STN motor VAT and UPDRS change');
hXLabel = xlabel('STN motor VAT');
hYLabel = ylabel('UPDRS percentage change post-op');
hText = text(200, -45, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));

%Adjust font & axes properties
set(gca, 'FontName', 'AvantGarde', 'FontSize', 16);
%set([hXLabel, hYLabel, hText], 'FontName', 'AvantGarde', 'FontSize', 16);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);

set(legend, 'Box', 'off');

%Export to EPS
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, 'figure2b.tif');
%print -depsc2 figure2.eps
close(gcf);

%% Supplementary: figure 1 alternatives

%notBoxPlot

% Distances
labels = {'right'; 'left'};
figure; 

subplot(2,2,1);
H = notBoxPlot(gpigroupleaddata{:, [1, 5]});

set([H.data],'MarkerSize',8,...
    'markerFaceColor',[1,1,1]*0.5,...
    'markerEdgeColor', 'none');
set([H.semPtch],...
    'FaceColor',[1,1,1]*0.25,...
    'EdgeColor','none');
set([H.sdPtch],...
    'FaceColor',[1,1,1]*0.75,...
    'EdgeColor','none');
set([H.mu],...
    'Color','k', 'LineWidth', 10);
grid on
set(gcf, 'color', 'w');
ylabel('distance from GPi (mm)');
set(gca, 'XTickLabel', labels);

subplot(2,2,2);
H = notBoxPlot(gpigroupleaddata{:, [2, 6]});

set([H.data],'MarkerSize',8,...
    'markerFaceColor',[1,1,1]*0.5,...
    'markerEdgeColor', 'none');
set([H.semPtch],...
    'FaceColor',[1,1,1]*0.25,...
    'EdgeColor','none');
set([H.sdPtch],...
    'FaceColor',[1,1,1]*0.75,...
    'EdgeColor','none');
set([H.mu],...
    'Color','k', 'LineWidth', 10);
grid on
set(gcf, 'color', 'w');
ylabel('distance from GPi motor (mm)');
set(gca, 'XTickLabel', labels);

subplot(2,2,3);
H = notBoxPlot(gpigroupleaddata{:, [3, 7]});

set([H.data],'MarkerSize',8,...
    'markerFaceColor',[1,1,1]*0.5,...
    'markerEdgeColor', 'none');
set([H.semPtch],...
    'FaceColor',[1,1,1]*0.25,...
    'EdgeColor','none');
set([H.sdPtch],...
    'FaceColor',[1,1,1]*0.75,...
    'EdgeColor','none');
set([H.mu],...
    'Color','k', 'LineWidth', 10);
grid on
set(gcf, 'color', 'w');
ylabel('VAT GPi (mm)');
set(gca, 'XTickLabel', labels);

subplot(2,2,4);
H = notBoxPlot(gpigroupleaddata{:, [4, 8]});

set([H.data],'MarkerSize',8,...
    'markerFaceColor',[1,1,1]*0.5,...
    'markerEdgeColor', 'none');
set([H.semPtch],...
    'FaceColor',[1,1,1]*0.25,...
    'EdgeColor','none');
set([H.sdPtch],...
    'FaceColor',[1,1,1]*0.75,...
    'EdgeColor','none');
set([H.mu],...
    'Color','k', 'LineWidth', 10);
grid on
set(gcf, 'color', 'w');
ylabel('VAT GPi motor (mm)');
set(gca, 'XTickLabel', labels);

set(gca, 'FontName', 'AvantGarde');
set(gca, 'FontSize', 14, 'FontWeight', 'bold');
set([hXLabel, hYLabel, hText], 'FontSize', 50);
set(hTitle, 'FontSize', 12, 'FontWeight', 'bold');


set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 gpi_plots.eps
close;

%iosr
figure('color', 'w'); 
iosr.statistics.boxPlot(gpigroupleaddata{2:end, 1}, 'showViolin', true);

%example 1
figure;
h = iosr.statistics.boxPlot(gpigroupleaddata{1:end, 1}, ...
'symbolColor','k',...
'medianColor','k',...
'symbolMarker',{'d'},...
'boxcolor',{[1 0 0]},...
'groupLabels',{'GPi mm'},...
'showLegend',true);
box on

%example 2
figure;
h = iosr.statistics.boxPlot(gpigroupleaddata{1:end, 1}, ...
'symbolColor','k', ...
'medianColor','k', ...
'symbolMarker',{'+','o','d'},...
'boxcolor','auto',... 
'showScatter',true);
box on

%example3
figure;
iosr.statistics.boxPlot(gpigroupleaddata{1:end, 1}, ...
'medianColor','k',...
'symbolMarker',{'+','o','d'},...
'boxcolor','auto',...
'sampleSize',true,...
'scaleWidth',true);
box on

%example 4
figure;
iosr.statistics.boxPlot(gpigroupleaddata{1:end, 1},...
'notch',true,...
'medianColor','k',...
'symbolMarker',{'d'},...
'boxcolor','auto',...
'style','hierarchy',...
'xSeparator',true,...
'groupLabels',{'Group 1'});
box on

%example 5
% load data
load carbig
[y,x,g] = iosr.statistics.tab2box(Cylinders,MPG,when);
IX = [1 3 2]; % order
g = g{1}(IX);
y = y(:,:,IX);
figure
h = iosr.statistics.boxPlot(x,y,...
'symbolColor','k','medianColor','k','symbolMarker','+',...
'boxcolor',{[1 1 1],[.75 .75 .75],[.5 .5 .5]},...
'scalewidth',true,'xseparator',true,...
'groupLabels',g,'showLegend',true);
box on
title('MPG by number of cylinders and period')
xlabel('Number of cylinders')
ylabel('MPG')

%example 6
weights = rand(size(MPG));
[y,x,g] = iosr.statistics.tab2box(Cylinders,MPG,when);
weights_boxed = iosr.statistics.tab2box(Cylinders,weights,when);
figure
h = iosr.statistics.boxPlot(x,y,'weights',weights_boxed);
 
%example 7
figure('color','w');
h2 = iosr.statistics.boxPlot(gpigroupleaddata{:, [1,5,2,6]}, 'showViolin', true, 'boxWidth', 0.025, 'showOutliers', true, 'showScatter', true);
box on
        
        
%beautiful figures
figure('color', 'w');
subplot(1,2,1);
violin(gpigroupleaddata{1:end, 1}, 'facecolor', [1 0 0], 'medc', '', 'mc', 'k');
legend off
box off
%axis off

colors = lbmap(10,'RedBlue');
sizes = ones(10,1)*100;
grot = ones(1, 10);
subplot(1,2,2);
scatter(grot, gpigroupleaddata{1:end, 1}, sizes, colors, 'filled')
alpha(0.8)
axis off
box off

%% Figure 2: outcome plots