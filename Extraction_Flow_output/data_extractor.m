clc
clear
close all
% This script extracts all data of a Delft3D-FLOW simulation for post-processing

MATDIR = ['C:\Program Files (x86)\Deltares\Delft3D 4.01.00\win32\delft3d_matlab'];
addpath(MATDIR);

%%% USER SECTION %%%
simID = {'Ypacarai'}; %change with the name of your simulation folder --> make it coincident with .mdf file name

mdfname = simID;
% Location and output files of the simulation
for nfiles = 1:length(simID)
    folder = ['C:\Users\gabri\Desktop\Lake ypacarai project\Ypakarai Modelo de Marina\Ypacarai_base\']; %change with the path to your simulations folder
    trimfiles  = ['trim-',mdfname{nfiles},'.dat'];
    trihfiles = ['trih-',mdfname{nfiles},'.dat'];
    
    extractid =simID{nfiles};
    startindex = [1];
    
    % grid and bathymetry
    flag_grid=0;                    % extract the grid and bathy data: 1 = yes, 0 = no
    
    % transects
    flag_transect = 0;              % extract the data: 1 = yes, 0 = no
    transectsM    = [0];        % IDs of M transects (south to north) to be extracted.  [0] means all transects, [] means no one
    transectsN    = [0];           % IDs of N transects (west to east)   to be extracted.  [0] means all transects, [] means no one
    
    % horizontal layer
    flag_layer   = 0;               % extract the data: 1 = yes, 0 = no
    layer        = [20 19];         % layer(s) to be extracted
    
    flag_history = 1;
    
    %points
    flag_point = 1;
    M = [27,9,7,17,32];
    N= [46,61,29,10,68];
    points = [M; N];
    
    %%% END USER SECTION %%%
    
    % create a directory 'extracted' in this directory
    mkdir extracted
    
    if flag_grid==1
        f_extract_grid(folder, trimfiles(1,:), extractid)
    end
    
    if flag_transect==1
        ntM=length(transectsM);
        for i=1:ntM
            f_extract_transectM(folder, trimfiles, startindex, extractid, transectsM(i),'m')
        end
        ntN=length(transectsN);
        for i=1:ntN
            f_extract_transectN(folder, trimfiles, startindex, extractid, transectsN(i),'n')
        end
    end
    
    if flag_layer==1
        nl=length(layer);
        for i=1:nl
            f_extract_layer(folder, trimfiles, startindex, extractid, layer(i))
        end
    end
    
    if flag_history==1
        f_extract_history(folder, trihfiles, extractid)
    end
    
    if flag_point==1
        ntp=length(points);
        for i=1:ntp
            f_extract_point(folder, trimfiles, startindex, extractid, M(i),N(i))
        end
    end
end




