function f_writefile_meteo(tgtpath,tgtbase,u,v,p,solr,c,rh,T,Date,startdate_num)
%original function: WRFnc2Delft3D modified by Marina Amadori
%convert NetCDF files from WRF to Delft3D meteo files
%
%    This function requires that WLGRID (included in Delft3D-MATLAB
%    toolbox) is on the search path as well as the MEXNC and SNCTOOLS
%    toolboxes needed to read the NetCDF file.

%tgtpath: destination folder for the output file
%tgtbase: name of the output file .scc
%sd: matrix K x N x M values of Secchi depth, with K time dimension
% dx, dy: grid spacing to be written in the header of .scc file
%xll, yll: coordinates (lat/lon or East/West) of the low-left border of the
%grid
%Date: time vector in Datenum format
%start date: reference time of the simulation

%
startdate = datestr(startdate_num,'yyyy-mm-dd');
kstart = 1; %modify kstart if not all available time series is meant to be written in the .scc file

% prepare files for each output variable
uwnd = fullfile(tgtpath,['meteo',tgtbase '.amu']);
vwnd = fullfile(tgtpath,['meteo',tgtbase '.amv']);
airp = fullfile(tgtpath,['meteo',tgtbase '.amp']);
grd  = fullfile(tgtpath,['meteo',tgtbase '_spherical.grd']);
cldfra = fullfile(tgtpath,['meteo',tgtbase '.amc']);
relhum = fullfile(tgtpath,['meteo',tgtbase '.amr']);
airT = fullfile(tgtpath,['meteo',tgtbase '.amt']);
solRad = fullfile(tgtpath,['meteo',tgtbase '.ams']);
nodata = -999.999;

% get lon/lat: if mlat/mlon are (M,N,K), store lat and long as (M,N,1)
lon = xlsread('C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\LON.csv');
lat = xlsread('C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\WRF2D3D\Inputs\LAT.csv');
u0 = lon;
[N,M,K] = size(u)
TimeOut = K;

%correct matrix dimensions MxN: check if necessary to varget
%for n = 1:N
%    for m = 1:M
%        lon(n,m) = mlon(1,n,m);
%        lat(n,m) = mlat(1,n,m);
%        u0(n,m) = u(1,n,m);
%    end
%end

%lon = lon';
%lat = lat';
%u0 = u0';

%for a curvilinear grid meteorogical data have to be mirrored vertically
%with respect to the grid
lonflip = flip(lon);
latflip = flip(lat);

lonrot = rot90(lonflip,2);
latrot = rot90(latflip,2);

% check if lon/lat are one dimensional
curvi = sum(size(lon)>1)>1;
if curvi
    % NO: curvilinear grid
    wlgrid('write','filename',grd,'coordinatesystem','spherical','x',lonrot,'y',latrot)
else
    % YES: rectilinear grid
    dlon = diff(lon);
    dlat = diff(lat);
    if all(abs(dlon-dlon(1))<1e-7) && all(abs(dlat-dlat(1))<1e-7)
        % simple equidistant rectilinear grid
    else
        % non-equidistant rectilinear grid -> should be treated as curvi
        % grid fof Delft3D
        curvi = true;
        wlgrid('write','filename',grd,'coordinatesystem','spherical','x',lonrot,'y',latrot)
    end
end


dataline_format = [repmat('%10.4f ',1,size(u0,1)) '\n'];
u(isnan(u)) = nodata;
v(isnan(v)) = nodata;
p(isnan(p)) = nodata;
c(isnan(c)) = nodata;
rh(isnan(rh)) = nodata;
T(isnan(T)) = nodata;
solr(isnan(solr)) = nodata;

% open files
ufid = fopen(uwnd,'w');
vfid = fopen(vwnd,'w');
pfid = fopen(airp,'w');
cfid = fopen(cldfra,'w');
rhfid = fopen(relhum,'w');
Tfid = fopen(airT,'w');
srfid = fopen(solRad,'w');

uvpfd = [ufid vfid pfid cfid rhfid Tfid srfid];

% write file headers
mfprintf(uvpfd,'FileVersion      = 1.03\n');
if curvi
    mfprintf(uvpfd,'Filetype         = meteo_on_curvilinear_grid\n');
    mfprintf(uvpfd,'grid_file        = %s.grd\n',['meteo',tgtbase]);
    mfprintf(uvpfd,'first_data_value = grid_ulcorner\n');
    mfprintf(uvpfd,'data_row         = grid_row\n');
else
    mfprintf(uvpfd,'Filetype         = meteo_on_equidistant_grid\n');
    mfprintf(uvpfd,'n_cols           = %i\n',size(c0,1));
    mfprintf(uvpfd,'n_rows           = %i\n',size(c0,2));
    mfprintf(uvpfd,'grid_unit        = degree\n');
    % code currently assumes lon and lat are increasing
    mfprintf(uvpfd,'x_llcenter       = %g\n',lon(1,:));
    mfprintf(uvpfd,'dx               = %g\n',dlon(1,:));
    mfprintf(uvpfd,'y_llcenter       = %g\n',lat(1,:));
    mfprintf(uvpfd,'dy               = %g\n',dlat(1,:));
end
mfprintf(uvpfd,'NODATA_value     = %7.3f\n',nodata);
mfprintf(uvpfd,'n_quantity       = 1\n');

%wind airp
fprintf (ufid,'quantity1        = x_wind\n');
fprintf (vfid,'quantity1        = y_wind\n');
fprintf (pfid,'quantity1        = air_pressure\n');
fprintf (ufid,'unit1            = m s-1\n');
fprintf (vfid,'unit1            = m s-1\n');
fprintf (pfid,'unit1            = Pa\n');
%heat fluxes terms
fprintf (cfid,'quantity1        = cloudiness\n');
fprintf (rhfid,'quantity1        = relative_humidity\n');
fprintf (Tfid,'quantity1        = air_temperature\n');
fprintf (srfid,'quantity1        = sw_radiation_flux\n');
fprintf (cfid,'unit1            = %%\n');
fprintf (rhfid,'unit1            = %%\n');
fprintf (Tfid,'unit1            = Celsius\n');
fprintf (srfid,'unit1            = W/m2\n');

% write time blocks for TIME = 0;
time_block = ['TIME = %d minutes since ',startdate,' 00:00:00 +00:00\n'];

for k = kstart:K
    u_k(:,:)=u(:,:,k);
    v_k(:,:)= v(:,:,k);
    p_k(:,:)= p(:,:,k);
    
    c_k(:,:)=c(:,:,k);
    rh_k(:,:)= rh(:,:,k);
    T_k(:,:)= T(:,:,k);
    sr_k(:,:)= solr(:,:,k);
    
    %correct matrix dimensions MxN
    up = permute(u_k, [2 1]);
    vp = permute(v_k, [2 1]);
    pp = permute(p_k, [2 1]);
    cp = permute(c_k, [2 1]);
    rhp = permute(rh_k, [2 1]);
    Tp = permute(T_k, [2 1]);
    srp = permute(sr_k, [2 1]);

    if (k==kstart)
        mfprintf(uvpfd,sprintf(time_block,0));
        fprintf (ufid,dataline_format,up);
        fprintf (vfid,dataline_format,vp);
        fprintf (pfid,dataline_format,pp);
        fprintf (cfid,dataline_format,cp);
        fprintf (rhfid,dataline_format,rhp);
        fprintf (Tfid,dataline_format,Tp);
        fprintf (srfid,dataline_format,srp);
    else
        time =(Date(k) - Date(kstart))*24*60;
        mfprintf(uvpfd,sprintf(time_block,time));
        fprintf (ufid,dataline_format,up);
        fprintf (vfid,dataline_format,vp);
        fprintf (pfid,dataline_format,pp);
        fprintf (cfid,dataline_format,cp);
        fprintf (rhfid,dataline_format,rhp);
        fprintf (Tfid,dataline_format,Tp);
        fprintf (srfid,dataline_format,srp);
        disp(['timestep ', num2str(k),' of ',num2str(K)]);
        disp(['Writing date ',datestr(Date(k))])

    end
end

% close files
fclose(ufid);
fclose(vfid);
fclose(pfid);

fclose(cfid);
fclose(rhfid);
fclose(Tfid);
fclose(srfid);

% support function to write two (or more) similar files
function mfprintf(fids,varargin)
for i=1:length(fids)
    fprintf(fids(i),varargin{:});
end
