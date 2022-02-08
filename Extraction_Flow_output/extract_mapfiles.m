clear all
close all

MATDIR = ['C:\Users\User\Documents\MATLAB\delft3d_matlab'];
addpath(MATDIR);

%%% USER SECTION %%%
simID = {'sim1','sim2','sim3'}; %change with the name of your simulation folder --> make it coincident with .mdf file name

% simID = {'S2016_B3','S2016_B4','S2016_A3','S2016_A4'};
mdfname =simID;

% Location and output files of the simulation
for nfiles = 1:length(simID)
    
    clear U V W WL NUZ DIFFZ T TKE EPS mtime mtime_extr RHO C1 C2
    
    folder = ['C:\Users\User\Desktop\simulations_path\']; %change with the path to your simulations folder
    trimfiles  = ['trim-',mdfname{nfiles},'.dat'];
    extractid =simID{nfiles};
    
    inputfile = vs_use([folder trimfiles]); %carica map file
    % %variabili principali da estrarre:
    XZ = squeeze(vs_let(inputfile,'map-const','XZ'));
    YZ = squeeze(vs_let(inputfile,'map-const','YZ'));
    ZK = squeeze(vs_let(inputfile,'map-const','ZK'));
    
    %choose whether you want to extract all timesteps or single timesteps or one every N timesteps.  
    %0 means "all timesteps"
    time_extr = 0;%[12:12:841]; 

    
    WINDU = vs_let(inputfile,'map-series',{time_extr},'WINDU',{0,0}); WINDU(WINDU==-999) = nan;
    WINDV = vs_let(inputfile,'map-series',{time_extr},'WINDV',{0,0});WINDV(WINDV==-999) = nan;
    
    U = vs_let(inputfile,'map-series',{time_extr},'U1',{0,0,0}); U(U==-999) = nan;
    V = vs_let(inputfile,'map-series',{time_extr},'V1',{0,0,0});V(V==-999) = nan;
    W = vs_let(inputfile,'map-series',{time_extr},'W',{0,0,0}); W(W==-999) = nan;
    WL = vs_let(inputfile,'map-series',{time_extr},'S1',{0,0}); WL(WL==-999) = nan;
    
    T = vs_let(inputfile,'map-series',{time_extr},'R1',{0,0,0,1}); T(T==-999) = nan;
    RHO = vs_let(inputfile,'map-series',{time_extr},'RHO',{0,0,0}); RHO(RHO==-999) = nan;
    C1 = vs_let(inputfile,'map-series',{time_extr},'R1',{0,0,0,2}); C1(C1==-999) = nan;
    C2 = vs_let(inputfile,'map-series',{time_extr},'R1',{0,0,0,3}); C2(C2==-999) = nan;
    
    NUZ = vs_let(inputfile,'map-series',{time_extr},'VICWW',{0,0,0}); NUZ(NUZ==-999) = nan;
    DIFFZ = vs_let(inputfile,'map-series',{time_extr},'DICWW',{0,0,0}); DIFFZ(DIFFZ==-999) = nan;
    TKE= vs_let(inputfile,'map-series',{time_extr},'RTUR1',{0,0,0,1}); TKE(TKE==-999) = nan;
    EPS= vs_let(inputfile,'map-series',{time_extr},'RTUR1',{0,0,0,2}); EPS(EPS==-999) = nan;
    
    tunit = vs_let(inputfile,'map-const','TUNIT'); %in seconds
    itmapc =vs_let(inputfile,'map-info-series','ITMAPC'); %iteration
    dt = vs_let(inputfile,'map-const','DT'); %dt simulation
    itdate = vs_let(inputfile,'map-const','ITDATE'); %initial date
    
    time0 = datenum(num2str(itdate(1)),'yyyymmdd');
    mtime = time0 +  (itmapc*dt*tunit)/(60*60*24);
    if time_extr == 0
        mtime_extr = mtime; %mtime is the time array in the trimfiles
    else
        mtime_extr = mtime(time_extr);
        %mtime_extr is the time array actually extracted. 
        %If time_extr ==0, mtime_extr = mtime as all timesteps have been extracted
    end
    
    filename = ['extracted/trimdata_' extractid  '.mat'];
    save(filename,'XZ','YZ','ZK','U','V','W','WINDU','WINDV','WL','T','RHO','C1','C2','NUZ','DIFFZ','TKE','EPS','mtime','mtime_extr','-v7.3');
end