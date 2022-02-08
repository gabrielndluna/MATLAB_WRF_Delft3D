function f_extract_layer(folder,files,startindices,extractid, layer)

close all
disp(['Extracting layer ' num2str(layer) ' ...'])

% Loop through all inputfiles starting each file from its startindex to the end

tstart = startindices(1);
tid = 1;

map02 = vs_use([folder files(1,:)]);

% Horizontal Grid resolution M x N 
gridfile = dir([folder,'/*.grd']);
GRID = wlgrid('read',[folder gridfile.name]);

M = size(GRID.X,1)+1;
N = size(GRID.X,2)+1;

mapit=vs_let(map02,'map-info-series','ITMAPC');
tsteps_run = length(mapit);   %number of saved timesteps

% Extract following fields u,v,w,t,nuz,windu,windv
u     = zeros(tsteps_run,N,M);
v     = zeros(tsteps_run,N,M);
w     = zeros(tsteps_run,N,M);
t     = zeros(tsteps_run,N,M);
nuz   = zeros(tsteps_run,N,M);
windu = zeros(tsteps_run,N,M);
windv = zeros(tsteps_run,N,M);

% Loop through all files
for fid = 1:size(files)
  inputfile_str = files(fid,:);
  disp('extracting data from file:');
  disp(inputfile_str);
  inputfile = vs_use([folder inputfile_str]);

  %% time extraction
  tunit = vs_let(inputfile,'map-const','TUNIT'); %in seconds
  itmapc =vs_let(inputfile,'map-info-series','ITMAPC'); %iteration
  dt = vs_let(inputfile,'map-const','DT'); %dt simulation
  itdate = vs_let(inputfile,'map-const','ITDATE'); %initial date

  time0 = datenum(num2str(itdate(1)),'yyyymmdd'); 
  mtime = time0 +  (itmapc*dt*tunit)/(60*60*24);

  tsteps_file = length(mtime);
  disp('tsteps_file is nu:');
  disp(tsteps_file);
  % determine nr of timesteps that we will extract namely the ones from startindices(fid):tsteps_file
  tsteps_extract = tsteps_file - startindices(fid) + 1;
  %add timesteps startindices(fid):tsteps_file of each variable to final variable containing all timesteps
  date_array(tid:tid+tsteps_extract-1) = mtime(startindices(fid):tsteps_file);

  % Get velocity U from current file for all timesteps tsteps_file
  u_now = squeeze(vs_let(inputfile,'map-series',{[0]},'U1',{0,0,layer}));
  u_now(u_now==-999)=nan;
  u(tid:tid+tsteps_extract-1,:,:)=u_now(startindices(fid):tsteps_file,:,:); 

  v_now = squeeze(vs_let(inputfile,'map-series',{[0]},'V1',{0,0,layer}));
  v_now(v_now==-999)=nan;
  v(tid:tid+tsteps_extract-1,:,:)=v_now(startindices(fid):tsteps_file,:,:); 
  
  % vertical velocity
  w_now = squeeze(vs_let(inputfile,'map-series',{[0]},'W',{0,0,layer}));
  w_now(w_now==-999)=nan;
  w(tid:tid+tsteps_extract-1,:,:)=w_now(startindices(fid):tsteps_file,:,:); 

  %variables in Z points
  t_now = squeeze(vs_let(inputfile,'map-series',{[0]},'R1',{0,0,layer,1}));
  t_now(t_now==-999)=nan;
  t(tid:tid+tsteps_extract-1,:,:)=t_now(startindices(fid):tsteps_file,:,:); 
  
  nuz_now = squeeze(vs_let(inputfile,'map-series',{[0]},'VICWW',{0,0,layer}));
  nuz_now(nuz_now==-999)=nan;   
  nuz(tid:tid+tsteps_extract-1,:,:)=nuz_now(startindices(fid):tsteps_file,:,:); 

  %wind in x-y direction in Z points
  %windu_now = squeeze(vs_let(inputfile,'map-series',{[0]},'WINDU')); 
  %windu_now (windu_now ==-999)=nan;
  %windu(tid:tid+tsteps_extract-1,:,:)=windu_now(startindices(fid):tsteps_file,:,:); 
  
  %windv_now = squeeze(vs_let(inputfile,'map-series',{[0]},'WINDV')); 
  %windv_now (windv_now ==-999)=nan;
  %windv(tid:tid+tsteps_extract-1,:,:)=windv_now(startindices(fid):tsteps_file,:,:); 
  %wind_now = sqrt(windu_now.^2 + windv_now .^2);
  %wind(tid:tid+tsteps_extract-1,:,:)=wind_now(startindices(fid):tsteps_file,:,:); 

  tid = tid + tsteps_extract; 
end
  
filename = ['extracted/layer' num2str(layer) '_' extractid '_days' num2str(tstart) '-' num2str(tid) '.mat'];    
save(filename,'mtime','tid','u','v','w','t','nuz','windu','windv','-v7.3');

disp(['Layer ' num2str(layer) ' extracted'])
disp(' ')
