function [commutes] = func_commutes2(counties_selected,data,blocks_shape)
%[commutes] = func_commutes(counties_selected,data,selected_county,blocks)
%   This function uses the information about the commutes to generate a
%   matrix with the information about the coordinates where a commute is
%   initiated and where is finished
%   INPUT:
%      *counties_selected:  % This variable allows to selected the counties
%       to be studied
%      *data:               % This variable introduces the required data
%      *selected_county:    % Conty selected
%
%   OUTPUT:
%      *commutes:           % Matrix with data about the commutes:
                  
%%  COUNTIES

%   COUNTIES SELECTED
%   The word County must be added to the selected counties so that they can
%   be found 
counties_selected.name   = strcat(counties_selected.name,' County');
%   Now the correspondent numbers are assigned
for from = 1:length(counties_selected.name)
    counties_selected.number(from,1) = data.counties.number(contains(data.counties.name,counties_selected.name(from)));
end
counties_selected = struct2table(counties_selected);


%%  CREATION OF THE MATRICES COMMUTES FROM AND TO

%   COMMUTES ORIGIN
%   The geocode is divided into the different parts that make it
commutes_from.state  = floor(data.commutes.h_geocode./10^13);
commutes_from.county = floor(data.commutes.h_geocode./10^10-commutes_from.state*10^3);
commutes_from.tract  = floor(rem(data.commutes.h_geocode,10^10)/10^4);
commutes_from.block  = rem(data.commutes.h_geocode,10^4);
commutes_from.geocode  = data.commutes.h_geocode;
commutes_from        = struct2table(commutes_from);

%   COMMUTES DESTINATION
%   The geocode is again divided
commutes_to.state  = floor(data.commutes.w_geocode./10^13);
commutes_to.county = floor(data.commutes.w_geocode./10^10-commutes_to.state *10^3);
commutes_to.tract  = floor(rem(data.commutes.w_geocode,10^10)/10^4);
commutes_to.block  = rem(data.commutes.w_geocode,10^4);
commutes_to.geocode  = data.commutes.w_geocode;
commutes_to        = struct2table(commutes_to);

%   COMMUTES THAT ARE FROM AND TO THE SELECTED CITY
%   Now, knowing the tracts that are from a city and the county that we
%   want to study, we can obtain the commutes from and to the city
commute_from_city = find(ismember(commutes_from.county,counties_selected.number));
commute_to_city   = find(ismember(commutes_to.county,counties_selected.number));
%   Using the obtained indices of those commutes that have an origin 
%   or destination at the selected counties, we can intersect them to find 
%   those which have origin and destination in one of the selected counties:
commute_from_to_city = intersect(commute_from_city,commute_to_city);


%%  DATA EXTRACTION
%   Using the indices that intersect, we can extract the useful data from
%   the following matrices
commutes_from = commutes_from(commute_from_to_city,:); 
commutes_to = commutes_to(commute_from_to_city,:);
%   The Variable Names are changed so that we can merge both matrices
commutes_from.Properties.VariableNames = {'state_from','county_from',...
    'tract_from','block_from','geoid_from'};
commutes_to.Properties.VariableNames = {'state_to','county_to',...
    'tract_to','block_to','geoid_to'};
%   Now we merge the matrices:
commutes = [commutes_from,commutes_to];

%%  ALLOCATION OF BLOCKS DATA
%   We need to find the location of the block data for the blocks that we
%   are using in the commutes matrix, so that we can extract it
[~,lob] = ismember(commutes.geoid_from,blocks_shape.geoid);
commutes.pgon_from         = blocks_shape.pgon(lob);
commutes.centroid_lat_from = blocks_shape.centroid_lat(lob);
commutes.centroid_lon_from = blocks_shape.centroid_lon(lob);
%   We need to find the location of the block data for the blocks that we
%   are using in the commutes matrix, so that we can extract it
[~,lob] = ismember(commutes.geoid_to,blocks_shape.geoid);
commutes.pgon_to         = blocks_shape.pgon(lob);
commutes.centroid_lat_to = blocks_shape.centroid_lat(lob);
commutes.centroid_lon_to = blocks_shape.centroid_lon(lob);


end

