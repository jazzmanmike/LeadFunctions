function lead_radar( electrode_coords )
%LEAD_RADAR Analysis for systematic variance in electrode accuracy 
%
%   lead_radar(electrode_coords);
%
%   Inputs: electrode_coords,   electrode co-ordinates matrix [e.g. from Lead_DBS ea_stats.electrodes.coords_mm]
%
%   Outputs: saves .eps figure of electrode accuracy
%
%
% Michael Hart, University of British Columbia, December 2020
%% Define target
%uncomment as required
%DISAL_Medium
%co-ordinates from fslstats -c

%STN
coords_left = [-11.451222 -13.150800 -7.642420]; coords_right = [11.318733 -12.492448 -7.615416]; coords_motor_left = [-12.769799 -14.992926 -7.041483]; coords_motor_right = [13.083996 -14.583479 -7.044755];

%GPI
%coords_left = [-17.886158 -5.146724 -3.932297]; coords_right = [17.685215 -4.332600 -3.932334]; coords_motor_left = [-20.159295 -7.206499 -3.566539]; coords_motor_right = [19.588933 -6.642944 -3.342620];

%VIM
%coords_left = [-11.693818 -17.096018 6.659262]; coords_right = [11.965826 -18.760551 6.618713]; coords_motor_left = [-13.919168 -14.512344 2.253728]; coords_motor_right = [13.950011 -15.638635 2.440878];

%% Compute error

load(ea_stats.electrodes.coords_mm);
XYZ_right = ea_stats.electrodes.coords_mm{1};
XYZ_left = ea_stats.electrodes.coords_mm{2};

delta_right = zeros();
delta_left = zeros();
delta_right = [delta_right; (XYZ_right - coords_right)];
delta_left = [delta_left; (XYZ_left - coords_left)];


%Overall nucleus
%Right
Xr = electrode_coords(1,1) - coords_right(1,1);
Yr = electrode_coords(1,2) - coords_right(1,2);
Zr = electrode_coords(1,3) - coords_right(1,3);

%Left
Xl = electrode_coords(2,1) - coords_left(1,1);
Yl = electrode_coords(2,2) - coords_left(1,2);
Zl = electrode_coords(2,3) - coords_left(1,3);

%Motor nucleus
%Right
Xrm = electrode_coords(1,1) - coords_motor_right(1,1);
Yrm = electrode_coords(1,2) - coords_motor_right(1,2);
Zrm = electrode_coords(1,3) - coords_motor_right(1,3);

%Left
Xlm = electrode_coords(2,1) - coords__motor_left(1,1);
Ylm = electrode_coords(2,2) - coords__motor_left(1,2);
Zlm = electrode_coords(2,3) - coords__motor_left(1,3);



%% Matlab Surface

f = figure;
ax = axes;

s = surface(grot1);
s.EdgeColor = 'none';
view(3)


x = -2:0.25:2;
y = x;
[X,Y] = meshgrid(x);
F = X.*exp(-X.^2-Y.^2);
surf(X,Y,F)

matrix = zeros(90,90);
for i = 1:length(coords)
    x = coords(i,1); 
    y = coords(i,2); 
    matrix(x,y) = coords(i,3); 
end

%% Polar 3D

[t,r] = meshgrid(linspace(0,2*pi,361),linspace(-4,4,101)); 
[x,y] = pol2cart(t,r); 
P = peaks(x,y); % peaks function on a polar grid

% draw 3d polar plot 
figure('Color','white','NumberTitle','off','Name','PolarPlot3d v4.3'); 

polarplot3d(P,'PlotType','surfn','PolarGrid',{4 24},'TickSpacing',8,... 

'AngularRange',[30 270]*pi/180,'RadialRange',[.8 4],... 
'RadLabels',3,'RadLabelLocation',{180 'max'},'RadLabelColor','red');

% set plot attributes 
set(gca,'DataAspectRatio',[1 1 10],'View',[-12,38],... 
'Xlim',[-4.5 4.5],'Xtick',[-4 -2 0 2 4],... 
'Ylim',[-4.5 4.5],'Ytick',[-4 -2 0 2 4]); 
title('polarplot3d example');


%% Finish Up & Save

filename = 'lead_logbook.mat'; 
save(filename);
