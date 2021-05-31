lead
kfewfew%% Just some code for viewing ea_atlas parts as a mesh
load([ea_space([],'atlases'),'DISTAL Minimal (Ewert 2017)',filesep,'atlas_index.mat']); % manually load definition of DISTAL atlas.
ea_mnifigure(); % open up Elvis viewer
rSTN=atlases.fv{1,1}; % extract the right STN.
rSTN=reducepatch(rSTN,0.5); % reduce patch a bit.
patch('Faces',rSTN.faces,'Vertices',rSTN.vertices,'facecolor','none','edgecolor','w'); % visualize the right STN as wireframes.
