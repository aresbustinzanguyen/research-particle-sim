%%
% clear workspace/clear command window
clear
clc

%importing files from excel
airtemp = readmatrix('air_temp.xlsx');
humidity = readmatrix('humidity.xlsx');
solar = readmatrix('solar.xlsx');

%{
The most important values are timestamps and solar readings from solar.xlsx
So we will list every single reading from that, and repeat the closest
value of air_temp and humidity to fit the measurements. 
%}
sizeof_solar = max(size(solar));
tot = zeros(sizeof_solar,4);
% Solar col 2 (timestamp) -> tot col 1
% solar col 3 (solar reading) -> tot col 4
tot(:,1)=solar(:,2);
tot(:,4)=solar(:,3);

% Finding all indexes of solar, where humidity and airtemp exists
search_time_air = airtemp(:, 2);
row_indices_air = find(ismember(tot(:,1), search_time_air));
search_time_hum = humidity(:, 2);
row_indices_hum = find(ismember(tot(:,1), search_time_hum));


j=1;
for i = 1:length(row_indices_air)
    num = row_indices_air(i);
    tot(num,3)=airtemp(j,3);
    j=j+1;
end

j=1;
for i = 1:length(row_indices_hum)
    num = row_indices_hum(i);
    tot(num,2)=humidity(j,3);
    j=j+1;
end

% Wherever applicable, duplicate airtemp and humidity temps to adjacent

for i = 1:length(row_indices_air)
    num = row_indices_air(i);
    if num+1 <=sizeof_solar && tot(num+1,3)==0
        tot(num+1,3) = tot(num,3);
    end
    if num+2<=sizeof_solar && tot(num+2,3)==0
        tot(num+2,3) = tot(num,3);
    end
    if num+3<=sizeof_solar && tot(num+3,3)==0
        tot(num+3,3) = tot(num,3);
    end
end
for i = 1:length(row_indices_hum)
    num = row_indices_hum(i);
    if num+1<=sizeof_solar && tot(num+1,2)==0 
        tot(num+1,2) = tot(num,2);
    end
    if num+2<=sizeof_solar && tot(num+2,2)==0
        tot(num+2,2) = tot(num,2);
    end
    if num+3<=sizeof_solar && tot(num+3,2)==0
        tot(num+3,2) = tot(num,2);
    end
end
%%
fmt = repmat('%0.7e\t', 1, size(tot, 2));
fmt = [fmt '\n'];
fid = fopen('aresaresaresaresares.txt', 'w');
for i = 1:length(tot)
    fprintf(fid, fmt, tot(i,:));
end
fclose(fid);
clear i j fid fmt ans t_str airtemp humidity num row_indices_air;
clear row_indices_hum search_time_air search_time_hum sizeof_solar solar;
