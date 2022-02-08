%extract data from trih-files (history output file d3d)
function f_extract_history(folder,files, extractid)

close all

for fid = 1:size(files)

  inputfile_str = files(fid,:);
  disp('extracting data from file:');
  disp(inputfile_str);
  inputfile = vs_use([folder inputfile_str]);

names =  squeeze(vs_let(inputfile,'his-const',{},'NAMST',{})); %names of obspoints
np = length(names); %total number of obspoints

XY = squeeze(vs_let(inputfile,'his-const',{},'XYSTAT',{}));    %xy coordinates of points (centre of the cells)
ZK =  squeeze(vs_let(inputfile,'his-const',{},'ZK',{}));       %layer interfaces depth 
Z = 0.5.*(ZK(1:end-1)+ZK(2:end)); 
UZ = squeeze(vs_let(inputfile,'his-series',{},'ZCURU',{}));    %u, v velocities defined in XY Z
VZ = squeeze(vs_let(inputfile,'his-series',{},'ZCURV',{}));
WZ = squeeze(vs_let(inputfile,'his-series',{},'ZCURW',{}));    %w velocity defined in XY ZK
WL = squeeze(vs_let(inputfile,'his-series',{},'ZWL',{}));      %water level
TURB = squeeze(vs_let(inputfile,'his-series',{},'ZTUR',{}));   %turbulent quantities: TKE and epsilon
NUZ = squeeze(vs_let(inputfile,'his-series',{},'ZVICWW',{}));  %vertical eddy viscosity
DIFF = squeeze(vs_let(inputfile,'his-series',{},'ZDICWW',{})); %vertical eddy diffusivity
T = squeeze(vs_let(inputfile,'his-series',{},'GRO',{0,0,1}));       %temperature
C1 = squeeze(vs_let(inputfile,'his-series',{},'GRO',{0,0,2}));       %concentration
C2 = squeeze(vs_let(inputfile,'his-series',{},'GRO',{0,0,3}));       %concentration

RHO = squeeze(vs_let(inputfile,'his-series',{},'ZRHO',{}));

%% time extraction
tunit = vs_let(inputfile,'his-const','TUNIT'); %in seconds
ithisc =vs_let(inputfile,'his-info-series','ITHISC'); %iteration
dt = vs_let(inputfile,'his-const','DT'); %dt simulation
itdate = vs_let(inputfile,'his-const','ITDATE'); %initial date

time0 = datenum(num2str(itdate(1)),'yyyymmdd'); 
stime = time0 +  (ithisc*dt*tunit)/(60*60*24);

filename = ['extracted/trihdata_' extractid  '.mat'];    
% save(filename,'names','XY','ZK','Z','UZ','VZ','WZ','WL','TURB','NUZ','DIFF','T','C1','C2','stime');
save(filename,'names','XY','ZK','Z','UZ','VZ','WZ','WL','TURB','NUZ','DIFF','T','RHO','C1','C2','stime');


end
end