function f_extract_plane(folder,file, extractid)
close all

map02 = vs_use([folder file]);

gridfile = dir([folder,'/*.grd']);
GRID = wlgrid('read',[folder gridfile.name]);
X = squeeze(vs_let(map02,'map-const','XZ'));
Y =  squeeze(vs_let(map02,'map-const','YZ'));
X(X==0)=nan;
Y(Y==0)=nan;
XGRID = permute(GRID.X, [2 1]);
YGRID = permute(GRID.Y, [2 1]);
ZK = vs_let(map02,'map-const','ZK');
nlayer = length(ZK)-1;
Z = 0.5*(ZK(2:end) + ZK(1:end-1));

batfile = dir([folder,'/*.dep']);
bat = wldep('read', [folder batfile.name], GRID);
bat(bat==-999)=nan;
bat = -permute(bat, [2 1]);

% grid angles
alphas= squeeze(vs_let(map02,'map-const','ALFAS'));

% frid areas
areas= squeeze(vs_let(map02,'map-const','GSQS'));
%drawgrid(map02)
areas(areas==1)=nan;

%filename = ['extracted/grid_' extractid '_' file '.mat'];    
filename = ['extracted/grid_' extractid  '.mat'];    
save(filename,'X','Y','Z','bat','alphas','areas');
