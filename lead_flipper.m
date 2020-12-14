%LEAD_FLIPPER Duplicates leads for viewing single side results as a group
%
%   Usage: subject to duplicate,      absolute path
%           
%   Outputs: ea_reconstruction.mat in new lead_flipped folder within working directory
%
%   NB: set for Medtronic 3389
%
%   NNB: code based on discussion here
%   [https://www.lead-dbs.org/forums/topic/export-code-for-vta-calculation/]
%
% Michael Hart, University of British Columbia, November 2020

%% Definitions

%Directory to be flipped
subject = '/Volumes/LaCie/DBS_Vancouver/SD_006/'; 

%% Files & directories

%Make new directory
mkdir lead_flipped

%CD to folder
cd lead_flipped

%Load ea_reconstruction.mat from original absolute path
dataload = sprintf('%s%s', subject, 'ea_reconstruction.mat');
load(dataload); %as reco

%Determine side to be flipped
if isempty(reco.electrode(1).dbs)==1
    disp('no right hemisphere electrode');
    hemiright=0;
else
    hemiright=1;
end

%% Extract co-ordinates

if hemiright==0 %making new right electrode - take coords from left  
    coords_head = reco.mni.markers(2).head; 
    coords_tail = reco.mni.markers(2).tail;  
elseif hemiright==1 %making new left electrode - take coords from right 
    coords_head = reco.mni.markers(1).head; 
    coords_tail = reco.mni.markers(1).tail;  
end

%% Generate new file

clear reco

reco.props(1).elmodel = 'Medtronic 3389';
reco.props(2).elmodel = 'Medtronic 3389';
reco.props(1).manually_corrected = 1;
reco.props(2).manually_corrected = 1;

%flip x co-ordinate only
if hemiright==0 %add new right coords + original left
    reco.mni.markers(1).head = coords_head .* [-1 1 1];
    reco.mni.markers(2).head = coords_head;
    reco.mni.markers(1).tail = coords_tail .* [-1 1 1];
    reco.mni.markers(2).tail = coords_tail;
elseif hemiright==1 %add new left coords + original right
    reco.mni.markers(1).head = coords_head;
    reco.mni.markers(2).head = coords_head .* [-1 1 1];
    reco.mni.markers(1).tail = coords_tail;
    reco.mni.markers(2).tail = coords_tail .* [-1 1 1];
end

save('ea_reconstruction.mat', 'reco');