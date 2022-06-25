function [population] = func_population(counties_selected,counties,population_blocks)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
% clc; clear all; close all;

%% DATA

% load Data

%   We select the counties with which we want to work 
counties_selected.name   = {'Lake';'McHenry';'Kane';'DuPage';'Will';'Cook'};
counties_selected.name   = strcat(counties_selected.name,' County');
%   We select the correspondent number for the selected county
for from = 1:length(counties_selected.name)
    counties_selected.number(from) = counties.FIPS_code(contains((counties.County),(counties_selected.name(from))));
end
%   We must divide the geocode
population.state  = floor(population_blocks.CENSUSBLOCKFULL./10^13);
population.county = floor(population_blocks.CENSUSBLOCKFULL./10^10-population.state *10^3);
population.tract  = floor(rem(population_blocks.CENSUSBLOCKFULL,10^10)/10^4);
population.block  = rem(population_blocks.CENSUSBLOCKFULL,10^4);


% tracts_chicago = find(0~=ismember(population.tract,tract2community.TRACT)&population.county==chicago_county);


% save('Data_commutes','community_area','jobs_chicago')
end

