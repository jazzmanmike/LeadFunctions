function dice = make_dice( VAT1, VAT2 )
%MAKE_DICE Compares Dice
%
%   dice = make_dice(VAT1, VAT2);
%
%   dice co-efficient = 2*(overlap(VAT1,VAT2)) / (area(VAT1,VAT2))
%
%   Inputs: VAT1/VAT2,  paths to volumes to be compared (e.g. of VATs)
%
%   Outputs: dice,      dice co-efficient for volumes given
%
%   Needs FSL setup for Matlab
%   Creates .txt files in working directory
%
% Michael Hart, University of British Columbia, December 2020

%% Lets go!

system(sprintf('fslmaths %s -mul %s overlap.nii.gz', VAT1, VAT2));
system("fslstats overlap.nii.gz -V | awk '{print $2}' > overlap.txt");
system(sprintf("fslstats %s -V | awk '{print $2}' > areaVAT1.txt", VAT1));
system(sprintf("fslstats %s -V | awk '{print $2}' > areaVAT2.txt", VAT2));

overlap = load('overlap.txt');
areaVAT1 = load('areaVAT1.txt');
areaVAT2 = load('areaVAT2.txt');

dice = 2*overlap ./ (areaVAT1 + areaVAT2);

%% All done