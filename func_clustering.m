function [community_area] = func_clustering(community_area)
%[community_area] = func_clustering(community_area)
%   This function is in charge of finding the centroid related to the
%   population and not to the shape
%   INPUT:
%      *community_area:  % Matrix with all the data about the community
%                          areas
%
%   OUTPUT:
%      *community_area:  % Matrix with all the data about the community and
%                          with the centroids of the population calculated

%%  CLUSTERING
wgs84 = wgs84Ellipsoid('kilometer');

for i = 1:length(community_area)
    %   This function uses the coordinates of the blocks defined as
    %   centroids of the block boundaries and also the population of that
    %   givlen block
    X = [community_area(i).blocks_x_centroid,community_area(i).blocks_y_centroid,community_area(i).blocks_population];
    %   The function kmeans is applied to compute the results
    [~,C] = kmeans(X,1);
    %   The results are saved in the matrix community area
    community_area(i).centroid_x_population = C(1);
    community_area(i).centroid_y_population = C(2);
    [x,y] = ecef2geodetic(wgs84,community_area(i).centroid_x_population,community_area(i).centroid_y_population,community_area(i).areas_z_centroid);
    community_area(i).centroid_lat_population = x;
    community_area(i).centroid_lon_population = y;
end


end

