AUTHOR: Marina Amadori and Gabriel Duarte-Luna

Matlab codes for conversion of WRF output variables to space/time varying forcing files for Delft3D simulation.

Inputs and outputs of the codes "WRFtxt_to_Delft3D.m" and "f_writefile_meteo.m" are in the folder "Inputs"
WRF output files are provided as txt files.
D3D files are produced as *.am* files + one grid file *.grd, which is the WRF model simulation grid. The meteofiles are created assuming that the atmospheric forcing is provided on another equidistant grid not coinciding with the lake grid. 

Note: WRF is usually provided on a spherical grid (LAT/LON coordinates), while Lake Ypacaraì is given on East/North coordinates. T
In the example given, the code f_writefile_meteo.m creates a grid file with spherical coordinates named "meteo_2017-08_spherical.grd". 

1) Load  "meteo_2017-08_spherical.grd" in the RGFGRID tool (Delft3D GUI --> GRID --> RGFGRID ) 
File --> Import --> "meteo_2017-08_spherical.grd" 
2) convert it into a Cartesian coordinate system: 
--> Co-ordinate System --> From Spherical to Cartesian coordinate system --> type 1 (==UTM) in the first line (under "Give the new Co-ordinate system) and insert the correct UTM zone and emispher where required
3) Export the new grid and rename it without "_spherical"
File --> Export --> GRID (RGFGRID) --> save it as "meteo_2017-08.grd" 
4) Check the differences between "meteo_2017-08_spherical.grd"  and "meteo_2017-08.grd" by opening the two files with notepad.
5) Load one of the .am* files in quickplot (Delft3D GUI --> FLOW--> QUICKPLOT), e.g. meteo_2017-08.amt (air temperature file) and plot the second time step. Verify that the map produced by Quickplot is coherent with the one produced by the matlab code "WRFnc2Delft3D.m". 

Note: If you encounter errors loading *.am* files in quickplot, there might be problems with the meteo grid. Be sure that the meteo grid is present in the same directory as *.am* files and that the name of the files has not been modified. The name of the meteo grid (without "spherical") is written inside *.am* files, hence if you want to modify it be sure that all files *.am* are updated.
