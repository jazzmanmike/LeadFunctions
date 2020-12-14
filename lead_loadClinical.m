%% LEAD_LOADCLINICAL
% Script for importing clinical data on DBS outcomes
%
% Generates file 'outcomes' for subsequent analysis
%
% Michael Hart, University of British Columbia, December 2020

%% Setup the Import Options and import the data

%set path to data
datapath='/Volumes/LaCie/DBS_Cambridge/DBS_matlab.xlsx';

opts = spreadsheetImportOptions("NumVariables", 15);

% Specify sheet and range
opts.Sheet = "Outcomes";
opts.DataRange = "A2:O32";

% Specify column names and types
opts.VariableNames = ["ID", "Diagnosis", "Target", "ORDate", "Weight_pre", "Weight_post", "UPDRS3_pre", "UPDRS3_post", "UPDRS4_pre", "UPDRS4_post", "LEDD_pre", "LEDD_post", "PDQ39_pre", "PDQ39_post", "MOCA"];
opts.VariableTypes = ["string", "categorical", "categorical", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify variable properties
opts = setvaropts(opts, ["ID", "ORDate"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["ID", "Diagnosis", "Target", "ORDate"], "EmptyFieldRule", "auto");

% Import the data
outcomes = readtable(datapath, opts, "UseExcel", false);

%% Clear temporary variables
%clear opts