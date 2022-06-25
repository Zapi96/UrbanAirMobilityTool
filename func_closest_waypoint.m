function [cell,distance_value] = func_closest_waypoint(UAMstop,mesh,community_area)
%[cell] = closest_waypoint(UAMstop,mesh)
%   This function looks for the closest waypoint (centroid) for the path.

UAMstops_id = [community_area(:).UAMstops_id];
UAMstops_lon  = [community_area(:).UAMstops_lon];
UAMstops_lat  = [community_area(:).UAMstops_lat];

% non_empty_idx             = find(cellfun(@(x)~isempty(x),{community_area.UAMstops_id}));
% UAMstop_id                 = zeros(size(community_area,1),1);
% UAMstop_id(non_empty_idx) = [community_area(non_empty_idx).UAMstops_id];

UAMstop_idx = find(UAMstops_id == UAMstop);
coordinates = [UAMstops_lon(UAMstop_idx),UAMstops_lat(UAMstop_idx)];
waypoints   = [mesh.centroid_lon,mesh.centroid_lat];


wgs84 = wgs84Ellipsoid('kilometer');

distance_value = distance(coordinates(:,2),coordinates(:,1),waypoints(:,2),waypoints(:,1),wgs84);

cell = find(distance_value == min(distance_value));

distance_value = min(distance_value);
end

