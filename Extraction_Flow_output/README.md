AUTHOR: Sebastiano Piccolroaz
MODIFIED BY: Marina Amadori and Gabriel Duarte-Luna

Matlab codes for extraction of Delf3D output variables in .mat files for Matlab.

The main code is "data_extractor". All codes named as "f_*" are functions extracting layers and transects from mapfiles outputs (trim) or profiles from history outputs (trih). 

The code "extract_mapfiles" is an example of code for the extraction of the full 4D domain of output variables (T x M x N x K).

Notes: 
1) Change the paths to the folder containing the Delft3D outputs (your simulations folder) and the Delft3D-matlab functions (should be named "delft3d_matlab" in your installation folder under "C:/"). 
2) Not all the variables produced by the simulation are extracted. If you need something more than what you get, just write me and I'll tell you how to extract additional variables (if available from Delft3D). 
3) The extracted matfiles are saved in the folder "extracted" within "extraction_codes". This can be changed by changing the path.
4) The geometrical features of the simulation domain are saved in the file "grid_MDFID.mat"
5) In all .mat files except grid_*.mat the time array is saved. In those files saved from mapfiles (layers, transects, points) the time vector is "mtime", in those from history files the time array is called "stime". Both are written in datenum matlab format (https://it.mathworks.com/help/matlab/ref/datenum.html)
6) If you get errors on the extraction of variables, e.g. with concentrations C1/C2, it's because you don't have those variables saved in the trim/trih files, either because you didn't tell Delft3D to save them or because you are not simulating some processes, e.g. transport of passive tracers --> concentration. If you can't figure out what is the problem, just email me.


