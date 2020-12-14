%% lead_dataExtract
%
% script for extracting data from Lead-DBS for a group analysis
%
% Michael Hart, University of Cambridge, June 2020

%% Set paths

%path to group data
group_dir = '/lustre/group/p00433/workspaces/mgh40/';
cd(group_dir); 

%individual subject ID
net_dirs = dir('20*');

%target of interest (GPI or STN - uncomment)
target = 'STN'; STN = [1, 2];
%target = 'GPI'; GPI = [5, 9];

%% Extract data

nSubs = length(net_dirs);
stats = zeros(nSubs, 8); 
targets = {'right_nucleus_distance'; 'right_motor_distance'; 'right_nucleus_VAT'; 'right_motor_VAT'; 
    'left_nucleus_distance'; 'left_motor_distance'; 'left_nucleus_VAT'; 'left_motor_VAT'};

for iSub = 1:nSubs
    mysubject = net_dirs(iSub).name;
    mysubjectpath = sprintf('%s%s', group_dir, mysubject);
    cd(mysubjectpath);
    load ea_stats.mat
    %extract data: order of indices is right then left, distal to proximal
    stats(iSub, 1:2) = min(ea_stats.conmat{1}(:, target)); 
    stats(iSub, 3:4) = ea_stats.stimulation.vat(1).AtlasIntersection(target);
    stats(iSub, 5:6) = min(ea_stats.conmat{2}(:, target));
    stats(iSub, 7:8) = ea_stats.stimulation.vat(2).AtlasIntersection(target);
end

%% Save up

filename = 'lead_dbs_stats.mat'; 
save(filename);

stats_table = array2table(stats, 'VariableNames', targets);
writetable(stats_table, 'lead_stats.txt', 'delimiter', 'tab');
