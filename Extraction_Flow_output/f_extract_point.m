function f_extract_point(folder,files,startindices,extractid,iM,iN)

% extracts data on pount M=iM,N= iN
% from the south to the north of the lake  
% perhaps for a better understanding keep in mind that the horizontal resolution M x N = 64 x 224 

close all
disp(['Extracting point ',num2str(iM),'_',num2str(iN) ' ...'])

% Loop through all inputfiles starting each file from its startindex to the end

tstart = startindices(1);
tid = 1;
map02 = vs_use([folder files(1,:)]);

%time resolution
mapit=vs_let(map02,'map-info-series','ITMAPC');
tsteps_run = length(mapit);   %number of saved timesteps

% vertical resolution
ZK = vs_let(map02,'map-const','ZK');
K = length(ZK)-1;

% Extract following fields u,v,w,t,nuz,Dz,tke,epsilon
u       = zeros(tsteps_run,K);
v       = zeros(tsteps_run,K);
t       = zeros(tsteps_run,K);
w       = zeros(tsteps_run,K+1);
nuz     = zeros(tsteps_run,K+1);
Dz      = zeros(tsteps_run,K+1);
tke     = zeros(tsteps_run,K+1);
epsilon = zeros(tsteps_run,K+1);

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

  % Extract variables from current inputfile for all timesteps tsteps_file
  u_now = squeeze(vs_let(inputfile,'map-series',{[0]},'U1',{iN,iM,0}));
  u_now(u_now==-999)=nan;
  u(tid:tid+tsteps_extract-1,:)=u_now(startindices(fid):tsteps_file,:);

  v_now = squeeze(vs_let(inputfile,'map-series',{[0]},'V1',{iN,iM,0}));
  v_now(v_now==-999)=nan;
  v(tid:tid+tsteps_extract-1,:)=v_now(startindices(fid):tsteps_file,:);

  w_now = squeeze(vs_let(inputfile,'map-series',{[0]},'W',{iN,iM,0}));
  w_now(w_now==-999)=nan;
  w(tid:tid+tsteps_extract-1,:)=w_now(startindices(fid):tsteps_file,:);

  t_now = squeeze(vs_let(inputfile,'map-series',{[0]},'R1',{iN,iM,0,1}));
  t_now(t_now==-999)=nan;
  t(tid:tid+tsteps_extract-1,:)=t_now(startindices(fid):tsteps_file,:);

  nuz_now = squeeze(vs_let(inputfile,'map-series',{[0]},'VICWW',{iN,iM,0}));
  nuz_now(nuz_now==-999)=nan;
  nuz(tid:tid+tsteps_extract-1,:)=nuz_now(startindices(fid):tsteps_file,:);

  Dz_now = squeeze(vs_let(inputfile,'map-series',{[0]},'DICWW',{iN,iM,0}));
  Dz_now(Dz_now==-999)=nan;
  Dz(tid:tid+tsteps_extract-1,:)=Dz_now(startindices(fid):tsteps_file,:);

  tke_now = squeeze(vs_let(inputfile,'map-series',{[0]},'RTUR1',{iN,iM,0,1}));
  tke_now(tke_now==-999)=nan;
  tke(tid:tid+tsteps_extract-1,:)=tke_now(startindices(fid):tsteps_file,:);

  epsilon_now = squeeze(vs_let(inputfile,'map-series',{[0]},'RTUR1',{iN,iM,0,2}));
  epsilon_now(epsilon_now==-999)=nan;
  epsilon(tid:tid+tsteps_extract-1,:)=epsilon_now(startindices(fid):tsteps_file,:);

 tid = tid + tsteps_extract;

end

filename = ['extracted/p_',num2str(iM),'_',num2str(iN),'_',extractid '_days' num2str(tstart) '-' num2str(tid) '.mat'];
save(filename,'mtime','u','v','w','t','nuz','Dz','tke','epsilon','-v7.3');

disp(['Point ',num2str(iM),',',num2str(iN),' extracted'])
disp(' ')

