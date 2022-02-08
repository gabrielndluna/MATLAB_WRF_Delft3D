clc
close all
clear all
point1 = matfile('C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\extraction_codes\extracted\p_7_29_Ypacarai_days1-1394.mat');
trih = matfile('C:\Users\gabri\Desktop\Lake ypacarai project\matlab_codes\extraction_codes\extracted\trihdata_Ypacarai.mat');
%% Reading outputs

whos(trih)
WL_full = trih.WL;
WL = WL_full(:,1);
Temp_full = trih.T;
Temp = Temp_full(:,1,20);
%first index is time, up to 4177, second index is point in this order =
%(29,30) - (9,61) - (7,29) - (17,10) - (32,68), third index is vertical
%location
% WL is water level and T is temperature

%% Reading excel data

data = readtable('C:\Users\gabri\Desktop\Lake ypacarai project\Datos_sanber.xlsx');
time = datetime(table2array(data(:,2)),'Format','dd/MM/yy h:mm:ss a ');
data.Date_time = time;
%% Create array of data for each time in the output
t1 = datetime(2017,9,1,0,0,0,'Format','dd/MM/yy h:mm:ss a ');
t2 = datetime(2017,9,30,0,0,0,'Format','dd/MM/yy h:mm:ss a ');
t = t1:minutes(20):t2;
t = transpose(t);
%% Evaluate if data coincides and create excel file
result = [];
times = datetime();
j = 1;
x = 1;
datestr(data.Date_time(1));
for i = 1:2089
   if  t(i,1) == data.Date_time(j);
       times(j,1) = datestr(data.Date_time(j));
       result(j,1) = WL(i,1);
       result(j,2) = Temp(i,1);
       result(j,3) = data.Nivel(j);
       result(j,4) = data.Tempagua(j);
       j = j + 1;
       x = x + 1;
   end
end

final = table(times,result);
writetable(final,'results.xlsx')
disp("Finished")
