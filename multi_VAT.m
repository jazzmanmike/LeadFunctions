function dices = multi_VAT(  )
%MULTI_VAT Compares difference VAT models
%
% Makes VATs with multiple (3-4) models
% Outputs VATs in separate folders 
% Also DICE coefficient confusion matrix
%
% nb: works from patient directory
% nnb: need to run first stimulation in Gui & name it "vat_horn"
%
% Michael Hart, University of British Columbia, May 2021

%% Set up FSL

fsldir = '/Volumes/LaCie/fsl/'; 
fsldirmpath = sprintf('%s/etc/matlab',fsldir);
setenv('FSLDIR', fsldir);
setenv('FSLOUTPUTTYPE', 'NIFTI_GZ');
path(path, fsldirmpath);
clear fsldir fsldirmpath;

setenv('PATH', [getenv('PATH') ':/Volumes/LaCie/fsl/bin']);

%% Load parameters

options = ea_getptopts('./');

load('ea_reconstruction.mat');
coords_mm = reco.mni.coords_mm;

load('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/stimparameters'); %saves as S

%% Make VAT in each model 

%Butenko - work in progress!
%varargout = ea_genvat_butenko(varargin);

%Dembek
%right
ea_genvat_dembek(coords_mm, S, 1, options, 'vat_dembek');
%left
ea_genvat_dembek(coords_mm, S, 2, options, 'vat_dembek');

%Fastfield - on hold (lgfigure): essentially as per Horn but monopolar only

%Horn - on hold (lgfigure): should already be run prior to starting function

%Kuncel
%Right
ea_genvat_kuncel(coords_mm, S, 1, options, 'vat_kuncel');
%Left
ea_genvat_kuncel(coords_mm, S, 2, options, 'vat_kuncel');

%Maedler
%Right
ea_genvat_maedler(coords_mm, S, 1, options, 'vat_maedler');
%Left
ea_genvat_maedler(coords_mm, S, 2, options, 'vat_maedler');


%% Run DICE

%first register all to same space (for image dimensions)

%horn
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right_MNI.nii'); 
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left_MNI.nii');

%dembek
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right_MNI.nii'); 
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left_MNI.nii');

%kuncel
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right_MNI.nii'); 
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left_MNI.nii');

%maedler
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right_MNI.nii'); 
system('flirt -in ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left.nii -ref ${FSLDIR}/data/standard/MNI152_T1_2mm_brain.nii.gz -applyxfm -usesqform -out ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left_MNI.nii');

%% Make confusion matrix (4x4x2(sides))

dices = zeros(4,4,2);

%horn & dembek
dices(2,1,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right_MNI.nii');
dices(2,1,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left_MNI.nii');

%horn & kuncel
dices(3,1,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right_MNI.nii');
dices(3,1,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left_MNI.nii');

%horn & maedler
dices(4,1,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right_MNI.nii.gz', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right_MNI.nii.gz');
dices(4,1,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left_MNI.nii');

%dembek & kuncel
dices(3,2,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right_MNI.nii');
dices(3,2,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left_MNI.nii');

%dembek & maedler
dices(4,2,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right_MNI.nii');
dices(4,2,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left_MNI.nii');

%kuncel & maedler
dices(4,3,1) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right_MNI.nii');
dices(4,3,2) = make_dice('./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left_MNI.nii', './stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left_MNI.nii');

%make symmetric
dices = max(dices, dices');

%% Matrix

colormap bone
matrix = dices(:,:,2) + dices(:,:,1)';
imagesc(matrix);
yyaxis left
ylabel({'left'})
set(gca, 'xtick', [], 'xticklabel', [], 'ytick', [], 'yticklabel', []);
yyaxis right
ylabel({'right'})
title({'Dice co-efficients of VATs'})
set(gca, 'ytick', [], 'yticklabel', []);


set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, 'multi_VAT_bilateralmatrix', 'epsc2');
close(gcf);

%% Plotmatrix

cmap = parula(1000);

figure1 = figure('Units', 'Normalized', 'Position', [0.15 0.2 0.7 0.65], 'Color', 'w'); %whole page, white background
hold on


%Horn
subplot_1 = subplot(4, 4, 1,'Parent', figure1);
hold(subplot_1,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_right.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ', num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Horn'});

subplot_2 = subplot(4, 4, 5,'Parent', figure1);
hold(subplot_2,'on');
pgon = polyshape([0 0 1 1], [0 1 1 0]);
plot(pgon, 'FaceColor', cmap(round(dices(2,1,1)*1000), :), 'EdgeColor', cmap(round(dices(2,1,1)*1000), :));
set(gca, 'visible', 'off');

subplot_3 = subplot(4, 4, 9,'Parent', figure1);
hold(subplot_3,'on');
plot(pgon, 'FaceColor', cmap(round(dices(3,1,1)*1000), :), 'EdgeColor', cmap(round(dices(3,1,1)*1000), :));
set(gca, 'visible', 'off');

subplot_4 = subplot(4, 4, 13,'Parent', figure1);
hold(subplot_4,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,1,1)*1000), :), 'EdgeColor', cmap(round(dices(4,1,1)*1000), :));
set(gca, 'visible', 'off');


%Dembek
subplot_5 = subplot(4, 4, 2,'Parent', figure1);
hold(subplot_5,'on');
txt = ['Overlap: ', num2str((round(dices(2,1,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Dembek'});


subplot_6 = subplot(4, 4, 6,'Parent', figure1);
hold(subplot_6,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_right.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');

subplot_7 = subplot(4, 4, 10,'Parent', figure1);
hold(subplot_7,'on');
plot(pgon, 'FaceColor', cmap(round(dices(3,2,1)*1000), :), 'EdgeColor', cmap(round(dices(3,2,1)*1000), :));
set(gca, 'visible', 'off');

subplot_8 = subplot(4, 4, 14,'Parent', figure1);
hold(subplot_8,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,2,1)*1000), :), 'EdgeColor', cmap(round(dices(4,2,1)*1000), :));
set(gca, 'visible', 'off');


%Kuncel
subplot_9 = subplot(4, 4, 3,'Parent', figure1);
hold(subplot_9,'on');
txt = ['Overlap: ', num2str((round(dices(3,1,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Kuncel'});


subplot_10 = subplot(4, 4, 7,'Parent', figure1);
hold(subplot_10,'on');
txt = ['Overlap: ', num2str((round(dices(3,2,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_11 = subplot(4, 4, 11,'Parent', figure1);
hold(subplot_11,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_right.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_12 = subplot(4, 4, 15,'Parent', figure1);
hold(subplot_12,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,3,1)*1000), :), 'EdgeColor', cmap(round(dices(4,3,1)*1000), :));
set(gca, 'visible', 'off');


%Maedler
subplot_13 = subplot(4, 4, 4,'Parent', figure1);
hold(subplot_13,'on');
txt = ['Overlap: ', num2str((round(dices(4,1,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Maedler'});

subplot_14 = subplot(4, 4, 8,'Parent', figure1);
hold(subplot_14,'on');
txt = ['Overlap: ',num2str((round(dices(4,2,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_15 = subplot(4, 4, 12,'Parent', figure1);
hold(subplot_15,'on');
txt = ['Overlap: ',num2str((round(dices(4,3,1), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_16 = subplot(4, 4, 16,'Parent', figure1);
hold(subplot_16,'on')
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_right.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, 'multi_VAT_plotmatrix_right', 'epsc2');
close(gcf);


figure1 = figure('Units', 'Normalized', 'Position', [0.15 0.2 0.7 0.65], 'Color', 'w'); %whole page, white background
hold on


%Horn
subplot_1 = subplot(4, 4, 1,'Parent', figure1);
hold(subplot_1,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_horn/vat_left.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ', num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Horn'});

subplot_2 = subplot(4, 4, 5,'Parent', figure1);
hold(subplot_2,'on');
pgon = polyshape([0 0 1 1], [0 1 1 0]);
plot(pgon, 'FaceColor', cmap(round(dices(2,1,2)*1000), :), 'EdgeColor', cmap(round(dices(2,1,2)*1000), :));
set(gca, 'visible', 'off');

subplot_3 = subplot(4, 4, 9,'Parent', figure1);
hold(subplot_3,'on');
plot(pgon, 'FaceColor', cmap(round(dices(3,1,2)*1000), :), 'EdgeColor', cmap(round(dices(3,1,2)*1000), :));
set(gca, 'visible', 'off');

subplot_4 = subplot(4, 4, 13,'Parent', figure1);
hold(subplot_4,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,1,2)*1000), :), 'EdgeColor', cmap(round(dices(4,1,2)*1000), :));
set(gca, 'visible', 'off');


%Dembek
subplot_5 = subplot(4, 4, 2,'Parent', figure1);
hold(subplot_5,'on');
txt = ['Overlap: ', num2str((round(dices(2,1,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Dembek'});


subplot_6 = subplot(4, 4, 6,'Parent', figure1);
hold(subplot_6,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_dembek/vat_left.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');

subplot_7 = subplot(4, 4, 10,'Parent', figure1);
hold(subplot_7,'on');
plot(pgon, 'FaceColor', cmap(round(dices(3,2,2)*1000), :), 'EdgeColor', cmap(round(dices(3,2,2)*1000), :));
set(gca, 'visible', 'off');

subplot_8 = subplot(4, 4, 14,'Parent', figure1);
hold(subplot_8,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,2,2)*1000), :), 'EdgeColor', cmap(round(dices(4,2,2)*1000), :));
set(gca, 'visible', 'off');


%Kuncel
subplot_9 = subplot(4, 4, 3,'Parent', figure1);
hold(subplot_9,'on');
txt = ['Overlap: ', num2str((round(dices(3,1,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Kuncel'});


subplot_10 = subplot(4, 4, 7,'Parent', figure1);
hold(subplot_10,'on');
txt = ['Overlap: ', num2str((round(dices(3,2,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_11 = subplot(4, 4, 11,'Parent', figure1);
hold(subplot_11,'on');
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_kuncel/vat_left.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_12 = subplot(4, 4, 15,'Parent', figure1);
hold(subplot_12,'on');
plot(pgon, 'FaceColor', cmap(round(dices(4,3,2)*1000), :), 'EdgeColor', cmap(round(dices(4,3,2)*1000), :));
set(gca, 'visible', 'off');


%Maedler
subplot_13 = subplot(4, 4, 4,'Parent', figure1);
hold(subplot_13,'on');
txt = ['Overlap: ', num2str((round(dices(4,1,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'XColor', 'none', 'YColor', 'none');
title({'Maedler'});

subplot_14 = subplot(4, 4, 8,'Parent', figure1);
hold(subplot_14,'on');
txt = ['Overlap: ',num2str((round(dices(4,2,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_15 = subplot(4, 4, 12,'Parent', figure1);
hold(subplot_15,'on');
txt = ['Overlap: ',num2str((round(dices(4,3,2), 2))*100), '%'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

subplot_16 = subplot(4, 4, 16,'Parent', figure1);
hold(subplot_16,'on')
[~, vol] = system("fslstats ./stimulations/MNI_ICBM_2009b_NLIN_ASYM/vat_maedler/vat_left.nii -V | awk '{print $2}'");
vol = str2num(vol); vol = round(vol);
txt = ['Volume: ',num2str(vol), 'mm3'];
plot(zeros);
text(0.5,0,txt);
set(gca, 'visible', 'off');

set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf, 'multi_VAT_plotmatrix_left', 'epsc2');
close(gcf);

%% All done