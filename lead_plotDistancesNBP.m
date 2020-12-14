function lead_plotDistancesNBP( stats )
%LEAD_PLOTDISTANCESNBP Makes electrode distance-to-target not-box-plots
%
%   lead_plotDistancesNBP(stats);
%
%   Inputs: stats,      matrix of Lead-DBS distances
%                       (e.g. 'stats' from lead_loadImaging.m)
%
%   Outputs: saves .eps figure of electrode distances in working directory
%
%
% Michael Hart, University of British Columbia, December 2020

%% notBoxPlot

% Distances
labels = {'left'; 'right'};
figure; 

subplot(2,2,1);
H = notBoxPlot(stats(:, [5, 1]));

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
ylabel('distance from overall nucleus (mm)');
set(gca, 'XTickLabel', labels);
set(gca, 'FontName', 'AvantGarde');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');

subplot(2,2,2);
H = notBoxPlot(stats(:, [6, 2]));

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
ylabel('distance from motor nucleus (mm)');
set(gca, 'XTickLabel', labels);
set(gca, 'FontName', 'AvantGarde');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');

subplot(2,2,3);
H = notBoxPlot(stats(:, [7, 3]));

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
ylabel('VAT overall nucleus (mm)');
set(gca, 'XTickLabel', labels);
set(gca, 'FontName', 'AvantGarde');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');


subplot(2,2,4);
H = notBoxPlot(stats(:, [8, 4]));

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
ylabel('VAT motor nucleus(mm)');
set(gca, 'XTickLabel', labels);

set(gca, 'FontName', 'AvantGarde');
set(gca, 'FontSize', 10, 'FontWeight', 'bold');


set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 plot_electrode_distances_NBP.eps
close;
