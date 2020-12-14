function lead_plotVATOutcomes( stats, outcomes )
%LEAD_PLOTVATOUTCOMES Plots electrode parameters versus clinical outcomes
%   
%   lead_plotOutcomes(stats, outcomes);
%
%   Inputs: stats,          matrix of Lead-DBS VATs 
%                           (e.g. from lead_loadImaging.m)
%           outcomes,       vector of clinical outcomes
%                           (e.g. index table from lead_loadClinical.m)
%
% Michael Hart, University of British Columbia, December 2020

%% Definitions

%set target of interest (uncomment)
target = outcomes.Target=='STN'; %STN
%target = outcomes.Target=='GPI'; %GPI
%target = outcomes.Target=='VIM'; %VIM

%% Define outcomes
%set outcome of interest
weight = 100 * ((outcomes.Weight_post - outcomes.Weight_pre) ./ outcomes.Weight_pre);
UPDRS3 = 100 * ((outcomes.UPDRS3_post - outcomes.UPDRS3_pre) ./ outcomes.UPDRS3_pre);
UPDRS4 = 100 * ((outcomes.UPDRS4_post - outcomes.UPDRS4_pre) ./ outcomes.UPDRS4_pre);
LEDD = 100 * ((outcomes.LEDD_post - outcomes.LEDD_pre) ./ outcomes.LEDD_pre);
PDQ39 = 100 * ((outcomes.PDQ39_post - outcomes.PDQ39_pre) ./ outcomes.PDQ39_pre);

%select outcome relevant to target
weight = weight(target, :);
UPDRS3 = UPDRS3(target, :);
UPDRS4 = UPDRS4(target, :);
LEDD = LEDD(target, :);
PDQ39 = PDQ39(target, :);


%% Nucleus VAT

%weight
nucleus_VAT = mean(stats(:, [3,7]), 2);

%remove nans (for fit)
nucleus_VAT = nucleus_VAT(~isnan(nucleus_VAT)); 
weight = weight(~isnan(nucleus_VAT));

weight = weight(~isnan(weight));
nucleus_VAT = nucleus_VAT(~isnan(weight));

[~, goodness, ~] = fit(nucleus_VAT, weight, 'poly1');
mdl = fitlm(nucleus_VAT, weight);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data

figure1 = figure('Name', 'Clinical Outcomes & VAT', 'color', 'w');
hold on;
subplot1 = subplot(2,5,1, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('Weight & VAT');
hXLabel = xlabel('Nucleus VAT');
hYLabel = ylabel('Weight %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.15 0.33 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);

%UPDRS3
nucleus_VAT = mean(stats(:, [3,7]), 2);

%remove nans (for fit)
nucleus_VAT = nucleus_VAT(~isnan(nucleus_VAT)); 
UPDRS3 = UPDRS3(~isnan(nucleus_VAT));

UPDRS3 = UPDRS3(~isnan(UPDRS3));
nucleus_VAT = nucleus_VAT(~isnan(UPDRS3));

[~, goodness, ~] = fit(nucleus_VAT, UPDRS3, 'poly1');
mdl = fitlm(nucleus_VAT, UPDRS3);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,2, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('UPDRS3 & VAT');
hXLabel = xlabel('Nucleus VAT');
hYLabel = ylabel('UPDRS3 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.315 0.33 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');

set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%UPDRS4
nucleus_VAT = mean(stats(:, [3,7]), 2);

%remove nans (for fit)
nucleus_VAT = nucleus_VAT(~isnan(nucleus_VAT)); 
UPDRS4 = UPDRS4(~isnan(nucleus_VAT));

UPDRS4 = UPDRS4(~isnan(UPDRS4));
nucleus_VAT = nucleus_VAT(~isnan(UPDRS4));

[~, goodness, ~] = fit(nucleus_VAT, UPDRS4, 'poly1');
mdl = fitlm(nucleus_VAT, UPDRS4);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,3, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('UPDRS4 & VAT');
hXLabel = xlabel('Nucleus VAT');
hYLabel = ylabel('UPDRS4 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.48 0.33 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%LEDD
nucleus_VAT = mean(stats(:, [3,7]), 2);

%remove nans (for fit)
nucleus_VAT = nucleus_VAT(~isnan(nucleus_VAT)); 
LEDD = LEDD(~isnan(nucleus_VAT));

LEDD = LEDD(~isnan(LEDD));
nucleus_VAT = nucleus_VAT(~isnan(LEDD));

[~, goodness, ~] = fit(nucleus_VAT, LEDD, 'poly1');
mdl = fitlm(nucleus_VAT, LEDD);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,4, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('LEDD & VAT');
hXLabel = xlabel('Nucleus VAT');
hYLabel = ylabel('LEDD %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.64 0.33 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%PDQ39
nucleus_VAT = mean(stats(:, [3,7]), 2);

%remove nans (for fit)
nucleus_VAT = nucleus_VAT(~isnan(nucleus_VAT)); 
PDQ39 = PDQ39(~isnan(nucleus_VAT));

PDQ39 = PDQ39(~isnan(PDQ39));
nucleus_VAT = nucleus_VAT(~isnan(PDQ39));

[~, goodness, ~] = fit(nucleus_VAT, PDQ39, 'poly1');
mdl = fitlm(nucleus_VAT, PDQ39);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,5, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('PDQ39 & VAT');
hXLabel = xlabel('Nucleus VAT');
hYLabel = ylabel('PDQ39 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.80 0.33 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%% (Re)Define outcomes
%set outcome of interest
weight = 100 * ((outcomes.Weight_post - outcomes.Weight_pre) ./ outcomes.Weight_pre);
UPDRS3 = 100 * ((outcomes.UPDRS3_post - outcomes.UPDRS3_pre) ./ outcomes.UPDRS3_pre);
UPDRS4 = 100 * ((outcomes.UPDRS4_post - outcomes.UPDRS4_pre) ./ outcomes.UPDRS4_pre);
LEDD = 100 * ((outcomes.LEDD_post - outcomes.LEDD_pre) ./ outcomes.LEDD_pre);
PDQ39 = 100 * ((outcomes.PDQ39_post - outcomes.PDQ39_pre) ./ outcomes.PDQ39_pre);

%select outcome relevant to target
weight = weight(target, :);
UPDRS3 = UPDRS3(target, :);
UPDRS4 = UPDRS4(target, :);
LEDD = LEDD(target, :);
PDQ39 = PDQ39(target, :);

%% Motor VAT

%weight
motor_VAT = mean(stats(:, [4,8]), 2);

%remove nans (for fit)
motor_VAT = motor_VAT(~isnan(motor_VAT)); 
weight = weight(~isnan(motor_VAT));

weight = weight(~isnan(weight));
motor_VAT = motor_VAT(~isnan(weight));

[~, goodness, ~] = fit(motor_VAT, weight, 'poly1');
mdl = fitlm(motor_VAT, weight);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,6, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('Weight & VAT');
hXLabel = xlabel('Motor VAT');
hYLabel = ylabel('Weight %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.15 0.15 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);



%UPDRS3
motor_VAT = mean(stats(:, [4,8]), 2);

%remove nans (for fit)
motor_VAT = motor_VAT(~isnan(motor_VAT)); 
UPDRS3 = UPDRS3(~isnan(motor_VAT));

UPDRS3 = UPDRS3(~isnan(UPDRS3));
motor_VAT = motor_VAT(~isnan(UPDRS3));

[~, goodness, ~] = fit(motor_VAT, UPDRS3, 'poly1');
mdl = fitlm(motor_VAT, UPDRS3);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,7, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('UPDRS3 & VAT');
hXLabel = xlabel('Motor VAT');
hYLabel = ylabel('UPDRS3 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.315 0.15 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%UPDRS4
motor_VAT = mean(stats(:, [4,8]), 2);

%remove nans (for fit)
motor_VAT = motor_VAT(~isnan(motor_VAT)); 
UPDRS4 = UPDRS4(~isnan(motor_VAT));

UPDRS4 = UPDRS4(~isnan(UPDRS4));
motor_VAT = motor_VAT(~isnan(UPDRS4));

[~, goodness, ~] = fit(motor_VAT, UPDRS4, 'poly1');
mdl = fitlm(motor_VAT, UPDRS4);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,8, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('UPDRS4 & VAT');
hXLabel = xlabel('Motor VAT');
hYLabel = ylabel('UPDRS4 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.48 0.15 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%LEDD
motor_VAT = mean(stats(:, [4,8]), 2);

%remove nans (for fit)
motor_VAT = motor_VAT(~isnan(motor_VAT)); 
LEDD = LEDD(~isnan(motor_VAT));

LEDD = LEDD(~isnan(LEDD));
motor_VAT = motor_VAT(~isnan(LEDD));

[~, goodness, ~] = fit(motor_VAT, LEDD, 'poly1');
mdl = fitlm(motor_VAT, LEDD);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,9, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('LEDD & VAT');
hXLabel = xlabel('Motor VAT');
hYLabel = ylabel('LEDD %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.64 0.15 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%PDQ39
motor_VAT = mean(stats(:, [4,8]), 2);

%remove nans (for fit)
motor_VAT = motor_VAT(~isnan(motor_VAT)); 
PDQ39 = PDQ39(~isnan(motor_VAT));

PDQ39 = PDQ39(~isnan(PDQ39));
motor_VAT = motor_VAT(~isnan(PDQ39));

[~, goodness, ~] = fit(motor_VAT, PDQ39, 'poly1');
mdl = fitlm(motor_VAT, PDQ39);
p = mdl.Coefficients(2, 4); 
p = table2array(p);

%Plot data
subplot1 = subplot(2,5,10, 'Parent', figure1);
H = plot(mdl, 'Parent', subplot1);
plotshaded(H(2).XData, [H(3).YData; H(4).YData], '[0.8 0.8 0.8]');

%Adjust plots
set(H(1), 'Marker', 'o', 'MarkerSize', 6, 'MarkerEdgeColor', 'none', 'MarkerFaceColor', [0.8 0.8 0.8]);
set(H(2), 'LineWidth', 3, 'LineStyle', '--', 'Color', [0.6 0.6 0.6]);
set(H(3), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);
set(H(4), 'LineWidth', 1.5, 'LineStyle', '-.', 'Color', [0.7 0.7 0.7]);

%Add labels
hTitle = title('PDQ39 & VAT');
hXLabel = xlabel('Motor VAT');
hYLabel = ylabel('PDQ39 %');
%hText = text(30, 0, sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p));
hText = annotation('textbox',[0.8 0.15 .3 .3],'String', sprintf('R^2 = %.2g, p = %.2g', goodness.rsquare, p),'EdgeColor', 'none');

%Adjust font & axes properties
%set(legend, 'Box', 'off', 'location', 'southoutside');
b = gca; legend(b,'off');
set([gca, hText], 'FontName', 'Helvetica', 'FontSize', 8);
set(hTitle, 'FontName', 'Helvetica');

set(gca, ...
    'Box', 'off', ...
    'TickDir', 'out', ...
    'TickLength', [0.02 0.02], ...
    'YGrid', 'on', ...
    'XColor', [0.3 0.3 0.3], ...
    'YColor', [0.3 0.3 0.3], ...
    'LineWidth', 1);


%% Save up

%Export to EPS
set(gcf, 'PaperPositionMode', 'auto');	
saveas(gcf, 'plot_VAT_outcomes.eps');
close(gcf);