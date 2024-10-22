%LEAD_LOGBOOK Report on electrode accuracy (e.g. for a surgical logbook)
%
%   Usage:  define target,          STN, GPI, VIM
%           define "in" distance,   distance considered inside the target
%           
%   Outputs: .mat & .csv file of distances + plots & coords 
%
%   NB: run from patient directory - needs ea.stats open
%   NNB: all atlases are Distal (medium)
%
% Michael Hart, University of British Columbia, November 2020

%% Define target
%uncomment as required
%note Lead-DBS = right (K0:K7) then left (K8:K15)

%STN
atlas_target = [1, 2]; target = {'Right STN'; 'Right motor STN'; 'Left STN'; 'Left motor STN'};

%GPI
%atlas_target= [5, 6]; target = {'Right GPi'; 'Right sensorimotor GPi'; 'Left GPi'; 'Left sensorimotor GPi'};

%VIM
%atlas_target=[16, 18]; target = {'Right Thalamus'; 'Right VIM'; 'Left Thalamus'; 'Left VIM'};

%% Set parameters

%distance considered "within" a nucleus (mm)
indistance = 1; 

%note Lead-DBS = right (K0:K7) then left (K8:K15)
electrodes = categorical({'K0', 'K1', 'K2', 'K3', 'K8', 'K9', 'K10', 'K11'});
electrodes = reordercats(electrodes, {'K0', 'K1', 'K2', 'K3', 'K8', 'K9', 'K10', 'K11'});

format bank

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

%% Extract Distances & Plot

%Reformat table
plotdistances = zeros(8, 2);

if hemiright~=0
    plotdistances(1:4, :) = distances(:, 1:2); 
end

if hemileft~=0
    plotdistances(5:8, :) = distances(:, 3:4);
end

bar(electrodes, plotdistances); 
ylabel('distance (mm)');
legend('main nucleus', 'motor nucleus');

set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 figure_individual_electrode_distances.eps
close(gcf);

%% Generate reports
%Closest contact is [general / motor]: right | left
%Average distance is: right | left
%Contacts in nucleus are: right | left

%logbook report
fid = fopen('logbook_report.txt', 'w');

fprintf(fid, 'Contact to target distances \n\n');
fprintf(fid, '%s %s %s %s \n\n', target{1}, target{2}, target{3}, target{4});
fprintf(fid, 'K0 %.2f %.2f K8 %.2f %.2f \n\n', distances(1,1), distances(1,2), distances(1,3), distances(1,4));
fprintf(fid, 'K1 %.2f %.2f K9 %.2f %.2f \n\n', distances(2,1), distances(2,2), distances(2,3), distances(2,4));
fprintf(fid, 'K2 %.2f %.2f K10 %.2f %.2f \n\n', distances(3,1), distances(3,2), distances(3,3), distances(3,4));
fprintf(fid, 'K3 %.2f %.2f K11 %.2f %.2f \n\n', distances(4,1), distances(4,2), distances(4,3), distances(4,4));

fprintf(fid, 'Closest contacts to nucleus are: \n\n');
min_nucleus = find(distances(:,[1,3])==min(distances(:,[1,3])));
fprintf(fid, 'Right contact: %s %.2f mm Left contact: %s %.2f mm \n\n', electrodes(min_nucleus(1)), distances(min_nucleus(1)), electrodes(min_nucleus(2)), distances(min_nucleus(2)));

fprintf(fid, 'Closest contacts to motor nucleus are: \n\n');
min_motor = find(distances(:,[2,4])==min(distances(:,[2,4])));
fprintf(fid, 'Right contact: %s %.2f mm Left contact: %s %.2f mm \n\n', electrodes(min_motor(1)), distances(min_motor(1)), electrodes(min_motor(2)), distances(min_motor(2)));

fprintf(fid, 'Average distance to nucleus is: \n\n');
mean_nucleus = mean(distances(:,[1,3]));
fprintf(fid, 'Right: %.2f mm Left: %.2f mm \n\n', mean_nucleus(1), mean_nucleus(2));

fprintf(fid, 'Average distance to motor nucleus is: \n\n');
mean_motor = mean(distances(:,[2,4]));
fprintf(fid, 'Right: %.2f mm Left: %.2f mm \n\n', mean_motor(1), mean_motor(2));

fprintf(fid, 'Number of contacts in nucleus are: \n\n');
contacts_nucleus_right = nnz(distances(:,1)<indistance);
contacts_nucleus_left = nnz(distances(:,2)<indistance);
fprintf(fid, 'Right: %.2f Left: %.2f \n\n', contacts_nucleus_right, contacts_nucleus_left);

fprintf(fid, 'Number of contacts in motor nucleus are: \n\n');
contacts_motor_right = nnz(distances(:,3)<indistance);
contacts_motor_left = nnz(distances(:,4)<indistance);
fprintf(fid, 'Right: %.2f Left: %.2f \n\n', contacts_motor_right, contacts_motor_left);

%summary (for .csv database)
fprintf(fid, 'right nucleus : right motor : left nucleus : left motor : \n\n');
fprintf(fid, '%.2f %.2f %.2f %.2f \n\n', distances(min_nucleus(1)), distances(min_motor(1)), distances(min_nucleus(2)), distances(min_motor(2)) );

%% Finish Up & Save

filename = 'lead_logbook.mat'; 
save(filename);
