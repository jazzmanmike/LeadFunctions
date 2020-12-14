function lead_plotClinical( outcomes )
%LEAD_PLOTCLINICAL Analyses DBS clinical outcomes
%
%   lead_plotClinical(outcomes);
%
%   Inputs: outcomes,   table of DBS outcomes
%                       (e.g. 'outcomes' from lead_loadClinical.m)
%
%   Outputs: saves .eps figure of clinical outcomes in working directory
%
%   NB: outcomes names as per DBS_ClinicalOutcomes.xlsx file on github
%
%
% Michael Hart, University of British Columbia, December 2020


%% Rainclouds
% Assess pre & post-op changes in outcomes

%Plot
figure1 = figure('Name', 'DBS Clinical Outcomes');
hold on
[cb] = cbrewer('qual', 'Set3', 5, 'pchip');
timing = {'postop'; 'preop'};

%Weight
rc_data{1,1} = outcomes.Weight_pre;
rc_data{2,1} = outcomes.Weight_post;
subplot1 = subplot(1,5,1, 'Parent', figure1);
cl = cb(1, :);
h = rm_raincloud(rc_data, cl);
title(['Weight']);
set(gca,'yticklabel',timing)
xlabel('percentage change');

%UPDRS3
rc_data{1,1} = outcomes.UPDRS3_pre;
rc_data{2,1} = outcomes.UPDRS3_post;
subplot2 = subplot(1,5,2, 'Parent', figure1);
cl = cb(2, :);
h = rm_raincloud(rc_data, cl);
title(['UPDRS3']);
set(gca,'yticklabel',timing)

%UPDRS4
rc_data{1,1} = outcomes.UPDRS4_pre;
rc_data{2,1} = outcomes.UPDRS4_post;
subplot3 = subplot(1,5,3, 'Parent', figure1);
cl = cb(3, :);
h = rm_raincloud(rc_data, cl);
title(['UPDRS4']);
set(gca,'yticklabel',timing)

%LEDD
rc_data{1,1} = outcomes.LEDD_pre;
rc_data{2,1} = outcomes.LEDD_post;
subplot4 = subplot(1,5,4, 'Parent', figure1);
cl = cb(4, :);
h = rm_raincloud(rc_data, cl);
title(['LEDD']);
set(gca,'yticklabel',timing)

%PDQ39
rc_data{1,1} = outcomes.PDQ39_pre;
rc_data{2,1} = outcomes.PDQ39_post;
subplot5 = subplot(1,5,5, 'Parent', figure1);
cl = cb(5, :);
h = rm_raincloud(rc_data, cl);
title(['PDQ39']);
set(gca,'yticklabel',timing)

% save
set(gcf, 'PaperPositionMode', 'auto');	
saveas(gcf, 'plot_DBS_Outcomes_Rainclouds.tiff'); %better for colours & transparency
close(gcf);

%% Plotmatrix
% Assess for covariance in outcome measures (useful for subsequent analyses)

pm_data(:, 1) = 100 * ((outcomes.Weight_post - outcomes.Weight_pre) ./ outcomes.Weight_pre);
pm_data(:, 2) = 100 * ((outcomes.UPDRS3_post - outcomes.UPDRS3_pre) ./ outcomes.UPDRS3_pre);
pm_data(:, 3) = 100 * ((outcomes.UPDRS4_post - outcomes.UPDRS4_pre) ./ outcomes.UPDRS4_pre);
pm_data(:, 4) = 100 * ((outcomes.LEDD_post - outcomes.LEDD_pre) ./ outcomes.LEDD_pre);
pm_data(:, 5) = 100 * ((outcomes.PDQ39_post - outcomes.PDQ39_pre) ./ outcomes.PDQ39_pre);
pm_data(:, 6) = (outcomes.MOCA);

%plotmatrix
[H,AX,BigAx,P,PAx] = plotmatrix(pm_data);
labels = {'Weight'; 'UPDRS3'; 'UPDRS4'; 'LEDD'; 'PDQ39'; 'MOCA'};
for i = 1:6; ylabel(AX(i,1), labels(i), 'rot', 0, 'HorizontalAlignment', 'right'); end
title(['DBS Clinical Outcomes']);
set(AX, 'ytick', []);

%saveup
set(gcf, 'PaperPositionMode', 'auto');	
saveas(gcf, 'plot_DBS_Outcomes_Plotmatrix.tiff');
close(gcf);

%% Measure statistics

stats_codes = {'Mean'; 'Standard Deviation'; 'Median'; 'Range'; ...
    '25th Percentile'; '50th Percentile'; '75th Percentile'; ...
    'Semi Interquartile Deviation'; 'Number of outliers'};

measures = {'Weight'; 'UPDRS3'; 'UPDRS4'; 'LEDD'; 'PDQ39'; 'MOCA'};

outcome_stats = zeros(9, 6);
outcome_stats(:, 1) = lead_outcome_stats(pm_data(:, 1));
outcome_stats(:, 2) = lead_outcome_stats(pm_data(:, 2));
outcome_stats(:, 3) = lead_outcome_stats(pm_data(:, 3));
outcome_stats(:, 4) = lead_outcome_stats(pm_data(:, 4));
outcome_stats(:, 5) = lead_outcome_stats(pm_data(:, 5));
outcome_stats(:, 6) = lead_outcome_stats(pm_data(:, 6));

%write table
outcome_stats_table = array2table(outcome_stats, 'VariableNames', measures, 'RowNames', stats_codes); %only Matlab R2015 onwards
writetable(outcome_stats_table, 'table_outcome_stats.txt', 'delimiter', 'tab');
