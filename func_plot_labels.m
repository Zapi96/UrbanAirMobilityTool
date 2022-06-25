function [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

lat = linspace(min(lat),max(lat),7);
lon = linspace(min(lon),max(lon),7);

for i = 1:length(lat)
    if lat(i)<0
        lat_labels{i} = [num2str(round(lat(i),1)),'º',' S'];
    else
        lat_labels{i} = [num2str(round(lat(i),1)),'º',' N'];
    end
    
    if lon(i)<0
        lon_labels{i} = [num2str(round(lon(i),1)),'º',' W'];
    else
        lon_labels{i} = [num2str(round(lon(i),1)),'º',' E'];
    end
end
end

