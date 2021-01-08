%% lead_radar
%
% Script for analysing electrode targetting errors
%
% Just set group directory & target below
%
% NB: set for distal medium atlas
% NNB: saves & returns to group directory
%
% Michael Hart, University of British Columbia, December 2020

%% Set paths

%set path to group data
group_dir = '/Volumes/LaCie/DBS_Cambridge/';

%set target of interest (uncomment)
target = 'stn';
%target = 'gpi';
%target = 'vim';

%% Define target
%DISAL_Medium 
%Co-ordinates from fslstats -c

cd(group_dir); 

%set code for extracting accuracy
if target == 'stn'
    dir_name = 'stn*';
    coords_left = [-11.451222 -13.150800 -7.642420]; coords_right = [11.318733 -12.492448 -7.615416]; 
    coords_motor_left = [-12.769799 -14.992926 -7.041483]; coords_motor_right = [13.083996 -14.583479 -7.044755];
elseif target == 'gpi'
    dir_name = 'gpi*';
    coords_left = [-17.886158 -5.146724 -3.932297]; coords_right = [17.685215 -4.332600 -3.932334]; 
    coords_motor_left = [-20.159295 -7.206499 -3.566539]; coords_motor_right = [19.588933 -6.642944 -3.342620];
elseif target == 'vim'
    dir_name = 'vim*';
    coords_left = [-11.693818 -17.096018 6.659262]; coords_right = [11.965826 -18.760551 6.618713]; 
    coords_motor_left = [-13.919168 -14.512344 2.253728]; coords_motor_right = [13.950011 -15.638635 2.440878];
end

%generate individual subject ID
net_dirs = dir(dir_name);

%% Extract data

nSubs = length(net_dirs);
XYZ_right = zeros(nSubs, 3);
XYZ_left = zeros(nSubs, 3);
targets = {'right_nucleus_distance'; 'right_motor_distance'; 'left_nucleus_distance'; 'left_motor_distance'};

for iSub = 1:nSubs
    mysubject = net_dirs(iSub).name;
    mysubjectpath = sprintf('%s%s', group_dir, mysubject);
    cd(mysubjectpath);
    load ea_stats.mat
    %extract data: order of indices is right then left, distal to proximal
    %highlight if data doesn't exist and input nans
    
    if isfield(ea_stats, 'conmat')
        XYZ_right(iSub, :) = ea_stats.electrodes.coords_mm{1}(1, :);
        XYZ_left(iSub, :) = ea_stats.electrodes.coords_mm{2}(1, :);
    else
        XYZ_right(iSub, :) = nan;
        XYZ_left(iSub, :) = nan;
        sprintf('%s : no electrode distances', mysubject)
    end
    
    clear ea_stats
    
end

%% Compute error

delta_right = XYZ_right - coords_right;
delta_left = XYZ_left - coords_left;

%% Generate surface

flat_right = zeros(200,200);

%multiply x10 & round
nRows = size(delta_right, 1);
for iRow = 1:nRows
    flat_right(100-round(delta_right(iRow, 1)*10, 0), 100-round(delta_right(iRow, 2)*10, 0)) = 100-round(delta_right(iRow, 3)*10, 0);
end

flat_left = zeros(200,200);

%multiply x10 & round
nRows = size(delta_left, 1);
for iRow = 1:nRows
    flat_left(100-round(delta_left(iRow, 1)*10, 0), 100-round(delta_left(iRow, 2)*10, 0)) = 100-round(delta_left(iRow, 3)*10, 0);
end


%% Matlab Surface

f = figure;
ax = axes;

subplot(1,2,1)
s = surface(flat_left);
s.EdgeColor = 'none';
h = surf(flat_left);
set(gca,'XTick',[], 'YTick', [])
hTitle = title('left brain');

subplot(1,2,2);
s = surface(flat_right);
s.EdgeColor = 'none';
h = surf(flat_right);
set(gca,'XTick',[], 'YTick', [])
hTitle = title('right brain');

%% Save up & close

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 plot_radar.eps
close(gcf);

