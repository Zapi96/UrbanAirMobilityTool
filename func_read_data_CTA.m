function [CTA] = func_read_data_CTA(filename_CTA)
%[CTA] = read_data_CTA(filename_CTA)
%   This function 
% clc; clear all; close all;

%%  IMPORT DATA

CTA = readtable(filename_CTA);

CTA = removevars(CTA,{'DIRECTION_ID','STATION_DESCRIPTIVE_NAME','MAP_ID'});

CTA.Properties.VariableNames = {'stop_id     '
    'stop_name   '
    'station_name'
    'ada         '
    'Red         '
    'Blue        '
    'Green       '
    'Brown       '
    'Purple      '
    'Purple2     '
    'Yellow      '
    'Pink        '
    'Orange      '
    'location    '};

CTA = table2struct(CTA,'ToScalar',true);

for i = 1:length(CTA.location)
    str       = char(CTA.location(i));
    latitude  = extractBetween(str,'(',',');
    longitude = extractBetween(str,',',')');
    
    CTA.latitude(i,1)  = str2double(latitude);
    CTA.longitude(i,1) = str2double(longitude);
end

%%  SAVE DATA
% save('Data\Data_CTA','CTA')
end

