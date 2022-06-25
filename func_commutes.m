function [commutes] = func_commutes(counties_selected,data,selected_county,blocks,community_area)
%[commutes] = func_commutes(counties_selected,data,selected_county,blocks)
%   This function uses the information about the commutes to generate a
%   matrix with the information about the coordinates where a commute is
%   initiated and where is finished
%   INPUT:
%      *counties_selected:  % This variable allows to selected the counties
%       to be studied
%      *data:               % This variable introduces the required data
%      *selected_county:    % Conty selected
%      *blocks:             % Blocks data
%
%   OUTPUT:
%      *commutes:           % Matrix with data about the commutes:
                  
% %%  COUNTIES
% 
% %   COUNTIES SELECTED
% %   The word County must be added to the selected counties so that they can
% %   be found 
% counties_selected.name   = strcat(counties_selected.name,' County');
% %   Now the correspondent numbers are assigned
% for from = 1:length(counties_selected.name)
%     counties_selected.number(from,1) = data.counties.number(contains(data.counties.name,counties_selected.name(from)));
% end
% counties_selected = struct2table(counties_selected);

wgs84 = wgs84Ellipsoid('kilometer');

%%  CREATION OF THE MATRICES COMMUTES FROM AND TO

%   COMMUTES ORIGIN
%   The geocode is divided into the different parts that make it
commutes_from.state  = floor(data.commutes.h_geocode./10^13);
commutes_from.county = floor(data.commutes.h_geocode./10^10-commutes_from.state *10^3);
commutes_from.tract  = floor(rem(data.commutes.h_geocode,10^10)/10^4);
commutes_from.block  = rem(data.commutes.h_geocode,10^4);
commutes_from        = struct2table(commutes_from);

%   COMMUTES DESTINATION
%   The geocode is again divided
commutes_to.state  = floor(data.commutes.w_geocode./10^13);
commutes_to.county = floor(data.commutes.w_geocode./10^10-commutes_to.state *10^3);
commutes_to.tract  = floor(rem(data.commutes.w_geocode,10^10)/10^4);
commutes_to.block  = rem(data.commutes.w_geocode,10^4);
commutes_to        = struct2table(commutes_to);

%   COMMUTES THAT ARE FROM AND TO THE SELECTED CITY
%   Now, knowing the tracts that are from a city and the county that we
%   want to study, we can obtain the commutes from and to the city
commute_from_city = find(ismember(commutes_from.tract,data.tract2community.tract)&commutes_from.county==selected_county);
commute_to_city   = find(ismember(commutes_to.tract,data.tract2community.tract)&commutes_from.county==selected_county);
%   Calculating the intersection, the commutes inside the city can be
%   determined (commute_from_to_city is a vector with the positions of the
%   matrices that match each other)
commute_from_to_city = intersect(commute_from_city,commute_to_city);

%   COMMUTES ORIGIN MATRIX 
%   First the matrix commutes_from is initialized for the centroids
commutes_from.x_centroid   = zeros(length(commutes_from.state),1);
commutes_from.y_centroid   = zeros(length(commutes_from.state),1);
commutes_from.lat_centroid = zeros(length(commutes_from.state),1);
commutes_from.lon_centroid = zeros(length(commutes_from.state),1);
%   Then the commutes geocode must match the geocodes of the boundaries
%   so that we obtain a vector which establishes which position of the
%   matrix blocks.geocode corresponds to the one in data.commutes.h_geocode
[~,Locb] = ismember(data.commutes.h_geocode,blocks.geocode);
%   The position of those who match are saved
non_zero = find(Locb>0);
%   The blocks of origin are assigned to the matrix commutes_from
commutes_from.x_centroid(non_zero)   = blocks.x_centroid(Locb(non_zero));
commutes_from.y_centroid(non_zero)   = blocks.y_centroid(Locb(non_zero));
commutes_from.lat_centroid(non_zero) = blocks.lat_centroid(Locb(non_zero));
commutes_from.lon_centroid(non_zero) = blocks.lon_centroid(Locb(non_zero));

%   COMMUTES DESTINATION MATRIX 
%   First the matrix commutes_to is initialized
commutes_to.x_centroid   = zeros(length(commutes_to.state),1);
commutes_to.y_centroid   = zeros(length(commutes_to.state),1);
commutes_to.lat_centroid = zeros(length(commutes_to.state),1);
commutes_to.lon_centroid = zeros(length(commutes_to.state),1);
%   Then the commutes geocode must match the geocodes of the boundaries
%   so that we obtain a vector which establishes which position of the
%   matrix blocks.geocode corresponds to the one in data.commutes.h_geocode
[~,Locb] = ismember(data.commutes.w_geocode,blocks.geocode);
%   The position of those who match are saved
non_zero = find(Locb>0);
%   The blocks of origin are assigned to the matrix commutes_from
commutes_to.x_centroid(non_zero)   = blocks.x_centroid(Locb(non_zero));
commutes_to.y_centroid(non_zero)   = blocks.y_centroid(Locb(non_zero));
commutes_to.lat_centroid(non_zero) = blocks.lat_centroid(Locb(non_zero));
commutes_to.lon_centroid(non_zero) = blocks.lon_centroid(Locb(non_zero));


%%  MATRIX COMMUTES
%   TOTAL NUMBER OF JOBS
%   The first step consists fo calculating the amount of jobs in the city
commutes.statistics.total_jobs = sum(data.commutes.people(commute_from_to_city));

%   INITILIZATION OF MATRICES
%   The matrix 'from' is initialized
commutes.trip.block_from              = [];
commutes.trip.tract_from              = [];
commutes.trip.area_from               = [];
commutes.trip.geoid_from              = [];
commutes.trip.block_from_x_centroid   = [];
commutes.trip.block_from_y_centroid   = [];
commutes.trip.block_from_lat_centroid = [];
commutes.trip.block_from_lon_centroid = [];
commutes.trip.tract_from_income       = [];
commutes.trip.tract_from_income_hour  = [];

%   The matrix 'to' is initialized
commutes.trip.block_to              = [];
commutes.trip.tract_to              = [];
commutes.trip.area_to               = [];
commutes.trip.geoid_to              = [];
commutes.trip.block_to_x_centroid   = [];
commutes.trip.block_to_y_centroid   = [];
commutes.trip.block_to_lat_centroid = [];
commutes.trip.block_to_lon_centroid = [];

commutes.trip.block_quantity = [];

%   DATA ALLOCATION
%   The function is going to look for the tracts in a given area, that is
%   why it starts using the number of each areas
for from = 1:length(data.community.number)
    %   First it selects the tracts of the selected area where the trips
    %   start
    tracts_area_from = data.tract2community.tract(from==data.tract2community.area_number);
    %   Now it is necessary to know the position of this tracts in the
    %   matrix commutes_from using the data of those trips that are within the city
    %   (members_from is a vector with the positions
    %   of the matrix commute_from which correspond to the tracts of the
    %   selected area)
    members_from    = commute_from_to_city(ismember(commutes_from.tract(commute_from_to_city),tracts_area_from));
    for to = 1:length(data.community.number)
        %   Now that the origin tracts are selected, the next step will
        %   consist of defining the tracts of destination
        tracts_area_to = data.tract2community.tract(to==data.tract2community.area_number);
        %   It is followed the same procedure but for the destination
        members_to    = commute_from_to_city(0~=ismember(commutes_to.tract(commute_from_to_city),tracts_area_to));
        %   Finally, once the position within the matrices commutes_from
        %   and commutes_to are known for the given areas, it can be
        %   calculated the intersection. Then the variable intersection
        %   will correspond to the position in the matrices which match
        %   each other.
        intersection   = intersect(members_from,members_to);
        %   There are values of the matrix whose centroid is 0 because
        %   there is not information about that block, thus it will be
        %   removed.
        intersection(commutes_from.x_centroid(intersection)==0)=[];
        intersection(commutes_to.x_centroid(intersection)==0)  =[];
        %   Now the data will be assigned using the positions of the
        %   matrices determined by intersection
        commutes.statistics.quantity(from,to) = sum(data.commutes.people(intersection));
        
        %   Number of trips information
        people = data.commutes.people(intersection);
        commutes.trip.block_quantity = [commutes.trip.block_quantity; ones(sum(people),1)];
        
        %   Geocode information
        commutes.trip.block_from     = [commutes.trip.block_from;     repelem(commutes_from.block(intersection),people,1)];
        commutes.trip.block_to       = [commutes.trip.block_to;       repelem(commutes_to.block(intersection),people,1)];
        commutes.trip.tract_from     = [commutes.trip.tract_from;     repelem(commutes_from.tract(intersection),people,1)];
        commutes.trip.tract_to       = [commutes.trip.tract_to;       repelem(commutes_to.tract(intersection),people,1)];
        commutes.trip.area_from      = [commutes.trip.area_from;      repelem(repmat(from,length(intersection),1),people,1)];
        commutes.trip.area_to        = [commutes.trip.area_to;        repelem(repmat(to,length(intersection),1),people,1)];
        commutes.trip.geoid_from     = [commutes.trip.geoid_from;     repelem(data.commutes.h_geocode(intersection),people,1)];
        commutes.trip.geoid_to       = [commutes.trip.geoid_to;       repelem(data.commutes.w_geocode(intersection),people,1)];
        
        
        %   Centroid information (origin)
        commutes.trip.block_from_x_centroid   = [commutes.trip.block_from_x_centroid;   repelem(commutes_from.x_centroid(intersection),people,1)];
        commutes.trip.block_from_y_centroid   = [commutes.trip.block_from_y_centroid;   repelem(commutes_from.y_centroid(intersection),people,1)];
        commutes.trip.block_from_lat_centroid = [commutes.trip.block_from_lat_centroid; repelem(commutes_from.lat_centroid(intersection),people,1)];
        commutes.trip.block_from_lon_centroid = [commutes.trip.block_from_lon_centroid; repelem(commutes_from.lon_centroid(intersection),people,1)];
        
        %   Centroid information (destination)
        commutes.trip.block_to_x_centroid   = [commutes.trip.block_to_x_centroid;   repelem(commutes_to.x_centroid(intersection),people,1)];
        commutes.trip.block_to_y_centroid   = [commutes.trip.block_to_y_centroid;   repelem(commutes_to.y_centroid(intersection),people,1)];
        commutes.trip.block_to_lat_centroid = [commutes.trip.block_to_lat_centroid; repelem(commutes_to.lat_centroid(intersection),people,1)];
        commutes.trip.block_to_lon_centroid = [commutes.trip.block_to_lon_centroid; repelem(commutes_to.lon_centroid(intersection),people,1)];    
        
        %   Income information (origin)
        [~,out] = ismember(commutes_from.tract(intersection),community_area(from).tracts_id);
        commutes.trip.tract_from_income      = [commutes.trip.tract_from_income;   repelem(community_area(from).tracts_income(out),people,1)];
        commutes.trip.tract_from_income_hour = [commutes.trip.tract_from_income_hour;   repelem(community_area(from).tracts_income_hour(out),people,1)];

    
    end
end
%   The commutes struct matrix is turned into a table 
commutes.trip = struct2table(commutes.trip);

%   The commutes distance in a straigth line is computed.

% commutes.trip.distance = sqrt((commutes.trip.block_to_x_centroid-...
%     commutes.trip.block_from_x_centroid).^2+...
%     (commutes.trip.block_to_y_centroid-...
%     commutes.trip.block_from_y_centroid).^2);
commutes.trip.distance = distance(commutes.trip.block_to_lat_centroid,...
    commutes.trip.block_to_lon_centroid,commutes.trip.block_from_lat_centroid,...
    commutes.trip.block_from_lon_centroid,wgs84);

commutes.trip(commutes.trip.distance<=1.2,:)=[];

%   Some statistics are calculated now
commutes.statistics.percentage_total = commutes.statistics.quantity./commutes.statistics.total_jobs.*100;
commutes.statistics.percentage_area  = commutes.statistics.quantity./sum(commutes.statistics.quantity,2).*100;

commutes.statistics.total_quantity = sum(commutes.statistics.quantity);
end

