%% lead_loadImaging
%
% Script for extracting data from Lead-DBS for group analyses
%
% Just set group directory & target below
% If unilateral leads run lead_flipper first
%
% NB: set for distal medium atlas
% NNB: saves & returns to group directory
%
% Michael Hart, University of British Columbia, November 2020

%% Set paths

%set path to group data
group_dir = '/Volumes/LaCie/DBS_Cambridge/';

%set target of interest (uncomment)
target = 'stn';
%target = 'gpi';
%target = 'vim';

%% Extract code
cd(group_dir); 

%set code for extracting accuracy
if target == 'stn'
    dir_name = 'stn*';
    atlas_ID = [1, 2];
elseif target == 'gpi'
    dir_name = 'gpi*';
    atlas_ID = [5, 9];
elseif target == 'vim'
    dir_name = 'vim*';
    atlas_ID = [5, 9];
end

%generate individual subject ID
net_dirs = dir(dir_name);

%% Extract data

nSubs = length(net_dirs);
electrodes = zeros(nSubs, 8); 
targets = {'right_nucleus_distance'; 'right_motor_distance'; 'right_nucleus_VAT'; 'right_motor_VAT'; 
    'left_nucleus_distance'; 'left_motor_distance'; 'left_nucleus_VAT'; 'left_motor_VAT'};

for iSub = 1:nSubs
    mysubject = net_dirs(iSub).name;
    mysubjectpath = sprintf('%s%s', group_dir, mysubject);
    cd(mysubjectpath);
    load ea_stats.mat
    %extract data: order of indices is right then left, distal to proximal
    %highlight if data doesn't exist and input nans
    if isfield(ea_stats, 'conmat')
        electrodes(iSub, 1:2) = min(ea_stats.conmat{1}(:, atlas_ID)); 
        electrodes(iSub, 5:6) = min(ea_stats.conmat{2}(:, atlas_ID)); 
    else
        electrodes(iSub, 1:2) = nan;
        electrodes(iSub, 5:6) = nan;
        sprintf('%s : no electrode distances', mysubject)
    end
    
    if isfield(ea_stats, 'stimulation')
        electrodes(iSub, 3:4) = ea_stats.stimulation.vat(1).AtlasIntersection(atlas_ID);
        electrodes(iSub, 7:8) = ea_stats.stimulation.vat(2).AtlasIntersection(atlas_ID);
    else
        electrodes(iSub, 3:4) = nan;
        electrodes(iSub, 7:8) = nan;
        sprintf('%s : no VAT stats', mysubject)
    end
    
end

%% Save up

cd(group_dir)
filename = 'lead_electrode_stats.mat'; 
save(filename);

electrodes_table = array2table(electrodes, 'VariableNames', targets);
writetable(electrodes_table, 'lead_electrode_stats.txt', 'delimiter', 'tab');
