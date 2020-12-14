%LEAD_DISTANCES_LATEX Script to extract data on lead accuracy
%   
%   Provides data for latex reports.
%
%   Usage: define target,      STN, GPI, VIM
%           
%   Outputs: .mat & .csv file of distances + plots & coords 
%
%   NB: needs ea.stats open
%   NNB: set for atlas Distal (medium)
%
% Michael Hart, University of British Columbia, August 2020

%% Define target
%uncomment as required

%STN
%atlas_target = [1, 2]; target = {'right_STN_distance'; 'right_STNmotor_distance'; 'left_STN_distance'; 'left_STNmotor_distance'}; target_short = {'RSTN'; 'RSTNm'; 'LSTN'; 'LSTNm'};

%GPI
atlas_target= [5, 6]; target = {'right_GPI_distance'; 'right_GPIsensory_distance'; 'left_GPI_distance'; 'left_GPIsensory_distance'}; target_short = {'RGPi'; 'RGPiM'; 'LGPi'; 'LGPiM'};

%VIM
%atlas_target=[16, 18]; target = {'right_thalamus_distance'; 'right_VIM_distance'; 'left_thalamus_distance'; 'left_VIM_distance'}; target_short = {'RThalamus'; 'RVIM'; 'LThalamus'; 'LVIM'};

%% Single Electrode Check

if isempty(ea_stats.electrodes.coords_mm{1})==1
    disp('no right hemisphere electrode');
    hemiright=0;
else
    hemiright=1;
end

if isempty(ea_stats.electrodes.coords_mm{2})==1
    disp('no left hemisphere electrode');
    hemileft=0;
else
    hemileft=1;
end

%% Extract Distances

distances = zeros(4,4);

if hemiright~=0
    distances(:, 1:2) = ea_stats.conmat{1}(:, atlas_target); %right
end

if hemileft~=0 
    distances(:, 3:4) = ea_stats.conmat{2}(:, atlas_target); %left
end

%% Plot Distances

%Reformat table
plotdistances = zeros(8, 2);
electrodes_long = categorical({'K0', 'K1', 'K2', 'K3', 'K8', 'K9', 'K10', 'K11'});
electrodes_long = reordercats(electrodes_long, {'K0', 'K1', 'K2', 'K3', 'K8', 'K9', 'K10', 'K11'});

if hemiright~=0
    plotdistances(1:4, :) = distances(:, 1:2); 
end

if hemileft~=0
    plotdistances(5:8, :) = distances(:, 3:4);
end

bar(electrodes_long, plotdistances); 
ylabel('distance (mm)');
legend('main nucleus', 'motor nucleus');

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 figure_individual_electrode_distances.eps
close(gcf);

%% Extract Co-ordinates

coords = zeros(8, 3);

if hemiright~=0
    coords(1:4, :) = ea_stats.electrodes.coords_mm{1};
end

if hemileft~=0
    coords(5:8, :) = ea_stats.electrodes.coords_mm{2};
end

%% Finish Up & Save

electrodes_short = {'K0/K8', 'K1/K9', 'K2/K10', 'K3/K11'}; 
electrodes_long = {'K0', 'K1', 'K2', 'K3', 'K8', 'K9', 'K10', 'K11'};

distances_table = array2table(distances, 'VariableNames', target, 'RowNames', electrodes_short);
writetable(distances_table, 'distances.csv', 'WriteRowNames', true);

coords_table = array2table(coords, 'VariableNames', {'X', 'Y', 'Z'}, 'RowNames', electrodes_long);
writetable(coords_table, 'coords.csv', 'WriteRowNames', true);

%file to add to latex

fid = fopen('latex_distances.txt', 'w');
fprintf(fid, '$Contact$ & $%s$ & $%s$ & $Contact$ &$%s$ & $%s$ %s \n\n', target_short{1}, target_short{2}, target_short{3}, target_short{4}, '\\');
fprintf(fid, '%s\n\n', '\midrule \\');
fprintf(fid, 'K0 & %.2f & %.2f & K8 & %.2f & %.2f %s \n\n', distances(1,1), distances(1,2), distances(1,3), distances(1,4), '\\');
fprintf(fid, 'K1 & %.2f & %.2f & K9 & %.2f & %.2f %s \n\n', distances(2,1), distances(2,2), distances(2,3), distances(2,4), '\\');
fprintf(fid, 'K2 & %.2f & %.2f & K10 & %.2f & %.2f %s \n\n', distances(3,1), distances(3,2), distances(3,3), distances(3,4), '\\');
fprintf(fid, 'K3 & %.2f & %.2f & K11 & %.2f & %.2f %s \n\n', distances(4,1), distances(4,2), distances(4,3), distances(4,4), '\\');

filename = 'lead_distances.mat'; 
save(filename);
