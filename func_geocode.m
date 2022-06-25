function [population] = func_geocode(census_blocks)
%[population] = geocode(census_blocks)
%   This function divides the geocode in the different components

population.state  = floor(census_blocks.CENSUSBLOCKFULL./10^13);
population.county = floor(census_blocks.CENSUSBLOCKFULL./10^10-population.state *10^3);
population.tract  = floor(rem(census_blocks.CENSUSBLOCKFULL,10^10)/10^4);
population.block  = rem(census_blocks.CENSUSBLOCKFULL,10^4);
end

