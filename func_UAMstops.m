function community_area = func_UAMstops(community_area)
%community_area = vertistops(community_area)
%   This function calculate the position of the UAMstops knowing the
%   location of the metro stops and the location of the centroid of a given
%   area. It computes then the distance between this two points to find the
%   closest one.
%   INPUT:
%      *community_area: % Main matrix with most of the information
%   OUTPUT:
%      *community_area: % Main matrix with most of the information and
%                         now with the information of the UAMstops

%   One UAM stop is going to be assigned to each area
for  i = 1:length(community_area)
    %   The locations of the metro stations in a given area are first
    %   saved.
    stations_x = community_area(i).stations_x;
    stations_y = community_area(i).stations_y;
    stations_z = community_area(i).stations_z;
    stations_lat = community_area(i).stations_lat;
    stations_lon = community_area(i).stations_lon;
    stations_id = community_area(i).stations_numbers;
    %   The coordinates of the centroid of an area is also saved
    centroid_x = community_area(i).centroid_x_population;
    centroid_y = community_area(i).centroid_y_population;
    %   If in a given area there are stations, the distance to the
    %   different stations from the centroid are calculated
    if ~isempty(stations_x)
        distance = vecnorm([stations_x-centroid_x stations_y-centroid_y],2,2);
        %   The index of the minnimum distance is stored
        distance_min_idx = find(distance==min(distance));
        %   Using the previous index, the location of the selected station
        %   can be stored
        community_area(i).UAMstops_x = stations_x(distance_min_idx(1));
        community_area(i).UAMstops_y = stations_y(distance_min_idx(1));
        community_area(i).UAMstops_z = stations_z(distance_min_idx(1));
        community_area(i).UAMstops_lat = stations_lat(distance_min_idx(1));
        community_area(i).UAMstops_lon = stations_lon(distance_min_idx(1));
        community_area(i).distance2centroid = distance;
        community_area(i).UAMstops_id = stations_id(distance_min_idx(1));
    end
end
end

