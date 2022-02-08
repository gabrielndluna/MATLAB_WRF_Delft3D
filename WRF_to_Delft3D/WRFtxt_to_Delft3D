clear all
close all
clc

tgtbase1 = '_2017-09';
tgtpath1 = [pwd,'/Inputs/'];

%% SETTING UP WRF DATA
%%%%%%%%%%%%%%%%%%%%%% TEMPERATURE

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\temperature\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
T = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    T = cat(3,T,thisdata);
end

%%%%%%%%%%%%%%%%%%%%%% WIND

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\wind-direction\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
wind_dir = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    wind_dir = cat(3,wind_dir,thisdata);
end

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\wind-speed\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
wind_vel = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    wind_vel = cat(3,wind_vel,thisdata);
end
u = times(wind_vel,sin(wind_dir*pi()/180));
v = times(wind_vel,cos(wind_dir*pi()/180));

%%%%%%%%%%%%%%%%%%%%% PRESSURE

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\surface-pressure\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
p = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    p = cat(3,p,thisdata);
end

%%%%%%%%%%%%%%%%%%%%% SOLAR RADIATION

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\radiation\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
solr = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    solr = cat(3,solr,thisdata);
end

%%%%%%%%%%%%%%%%%%%%% CLOUDINESS

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\cloud-fraction\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
cloud = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    cloud = cat(3,cloud,thisdata);
end

%%%%%%%%%%%%%%%%%%%%%%%% HUMIDITY

PathStr='C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\relative-humidity\'
textFiles=dir([PathStr '*.txt']);
data_amount = length(textFiles);
filenames = fullfile(PathStr, {textFiles.name});
rh = table2array(readtable(filenames{1}));
for K = 2 : data_amount
    thisfile = filenames{K};
    thisdata = table2array(readtable(thisfile));
    rh = cat(3,rh,thisdata);
end

%% WRITE AM* FILES

%create the time vector either loading it directly from WRF outputs (if available) 
%or by knowing the startdate and the timestep as follows:
startdate = datenum('01/09/2017','dd/mm/yyyy'); 
tstep = 60; %(minutes)
disp(startdate)
DateArray = startdate + tstep/60/24.*[1:size(u,3)];
disp(size(DateArray));
disp(size(u,3));
disp(size(u))

f_writefile_meteo(tgtpath1,tgtbase1,u,v,p,solr,cloud,rh,T,DateArray,startdate);
