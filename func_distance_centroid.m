function [distance] = func_distance_centroid(centroid_x,centroid_y,centroid_neighbor_x,centroid_neighbor_y)
%[distance] = distance_centroid(centroid_x,centroid_y,centroid_neighbor_x,centroid_neighbor_y)
%   This function calculates the distance between a point and a set of
%   points
point1 = [centroid_x;centroid_y];
point2 = [centroid_neighbor_x.';centroid_neighbor_y.'];
distance = vecnorm(point2-point1);


end

