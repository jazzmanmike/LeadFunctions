%% All in one DBS analysis

% Complete lead_DBS analysis 

% Load clinical data
lead_loadClinical;

% Load imaging (Lead-DBS) data
lead_loadImaging;

% Analyse clinical data
lead_plotClinical(outcomes);

% Analyse imaging data (electrode distances & VAT's)
lead_plotDistances(electrodes);
lead_plotDistancesNBP(electrode);

% Predict outcomes (outcome versus VAT)
lead_plotVATOutcomes(electrode, outcomes);