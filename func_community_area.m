function [community_area,population] = func_community_area(blocks,tracts,areas,data)
%[community_area,population] = func_community_area(blocks,tracts,areas,data)
%   This function creates a matrix called community_area which is going to
%   contain all the information about the communities. In this case this
%   function assigns the correspondent values of the coordinates of the
%   boundaries, centroids and population of the tracts and blocks for each
%   community area. Therefore, the resultant matrix contains as many
%   rows as community areas (77 for Chicago) and each column represent the following values:
%       -Tracts ID
%       -Tracts population
%       -Tracts X centroid coordinates
%       -Tracts Y centroid coordinates 
%       -Tracts polyshape
%       -Tracts X vector coordinates
%       -Tracts Y vector coordinates
%       -Blocks ID
%       -Blocks population
%       -Blocks X centroid coordinates
%       -Blocks Y centroid coordinates 
%       -Blocks polyshape
%       -Blocks X vector coordinates
%       -Blocks Y vector coordinates
%       -Areas population
%       -Areas X centroid coordinates
%       -Areas Y centroid coordinates 
%       -Areas polyshape
%       -Areas X vector coordinates
%       -Areas Y vector coordinates
%   INPUT:
%      *blocks:  % Blocks data
%      *tracts:  % Tracts data
%      *areas:   % Areas data
%      *data:    % General data
%
%   OUTPUT:
%      *community_area:    % General information of the community areas
%      *population:        % Total population of the city
%                  

%   First we find in which elementes in blocks.geocode also appear in the
%   data of the population of the blocks so that we can match each other
%   (This matrices are of different length)
[~,Locb] = ismember(blocks.geocode,data.population_blocks.geocode); 
%   Once the location it is established, the population of each block is
%   added to the table blocks
for i = 1:length(blocks.geometry)
    if Locb(i) ~=0
        blocks.population(i,1) = data.population_blocks.total_population(Locb(i));
    end
end

%   After determining the population on each block, the population per
%   tract and area can also be computed. Besides, the vectors of the
%   coordinates of the centroids and of the boundaries can be also included
%   for each area in the matrix.
for i = 1:length(data.community.number)
    %   The tracts that belong to an area are selected
    tracts_area = data.tract2community.tract(i==data.tract2community.area_number);
    %   TRACTS
    for j = 1:length(tracts_area)
        %   Now this function looks for the tracts that are in the selected
        %   area in the matrix tracts
        Locb2 = find(0~=ismember(tracts.tract,tracts_area(j)));
        %   When this tract is found, the function saves the results in the
        %   matrix community area
        if Locb2 ~=0
            community_area(i).tracts_id(j,:)           = tracts_area(j);
            community_area(i).tracts_population(j,:)   = sum(blocks.population(blocks.tract==tracts_area(j)));
            community_area(i).tracts_x_centroid(j,:)   = tracts.x_centroid(Locb2);
            community_area(i).tracts_y_centroid(j,:)   = tracts.y_centroid(Locb2);
            community_area(i).tracts_z_centroid(j,:)   = tracts.z_centroid(Locb2);
            community_area(i).tracts_x_vector(j,:)     = tracts.x_vector(Locb2);
            community_area(i).tracts_y_vector(j,:)     = tracts.y_vector(Locb2);
            community_area(i).tracts_z_vector(j,:)     = tracts.z_vector(Locb2);
            community_area(i).tracts_shape_ECEF(j,:)   = tracts.pgon_ECEF(Locb2);
            community_area(i).tracts_lat_centroid(j,:) = tracts.lat_centroid(Locb2);
            community_area(i).tracts_lon_centroid(j,:) = tracts.lon_centroid(Locb2);
            community_area(i).tracts_lat_vector(j,:)   = tracts.lat_vector(Locb2);
            community_area(i).tracts_lon_vector(j,:)   = tracts.lon_vector(Locb2);
            community_area(i).tracts_shape_GEO(j,:)    = tracts.pgon_ECEF(Locb2);
        end
    end
    %   BLOCKS
    %   Exactly the same procedure is followed for the blocks
    Locb = find(ismember(blocks.tract,tracts_area));
    
    community_area(i).blocks_id           = blocks.block(Locb);
    community_area(i).blocks_population   = blocks.population(Locb);
    community_area(i).blocks_x_centroid   = blocks.x_centroid(Locb);
    community_area(i).blocks_y_centroid   = blocks.y_centroid(Locb);
    community_area(i).blocks_z_centroid   = blocks.z_centroid(Locb);
    community_area(i).blocks_x_vector     = blocks.x_vector(Locb);
    community_area(i).blocks_y_vector     = blocks.y_vector(Locb);
    community_area(i).blocks_z_vector     = blocks.z_vector(Locb);
    community_area(i).blocks_shape_ECEF   = blocks.pgon_ECEF(Locb);
    community_area(i).blocks_lat_centroid = blocks.lat_centroid(Locb);
    community_area(i).blocks_lon_centroid = blocks.lon_centroid(Locb);
    community_area(i).blocks_lat_vector   = blocks.lat_vector(Locb);
    community_area(i).blocks_lon_vector   = blocks.lon_vector(Locb);
    community_area(i).blocks_shape_GEO    = blocks.pgon_GEO(Locb);
    
    %   AREAS
    %   Since the areas are not sorted in the matrix area, it is necessary 
    %   to find the location of each one on this matrix. Then the data is
    %   stored in the community_area matrix
    areas_pos = find(i == areas.area_number);
    community_area(i).population         = sum(community_area(i).tracts_population);
    community_area(i).areas_x_centroid   = areas.x_centroid(areas_pos);
    community_area(i).areas_y_centroid   = areas.y_centroid(areas_pos);
    community_area(i).areas_z_centroid   = areas.z_centroid(areas_pos);
    community_area(i).areas_x_vector     = areas.x_vector(areas_pos);
    community_area(i).areas_y_vector     = areas.y_vector(areas_pos);
    community_area(i).areas_z_vector     = areas.z_vector(areas_pos);
    community_area(i).areas_shape_ECEF   = areas.pgon_ECEF(areas_pos);
    community_area(i).areas_lat_centroid = areas.lat_centroid(areas_pos);
    community_area(i).areas_lon_centroid = areas.lon_centroid(areas_pos);
    community_area(i).areas_lat_vector   = areas.lat_vector(areas_pos);
    community_area(i).areas_lon_vector   = areas.lon_vector(areas_pos);
    community_area(i).areas_shape_GEO    = areas.pgon_GEO(areas_pos);
    
end

%   The total population of the city is finally calculated
population_quantity = 0;
for i = 1:length(data.community.number)
    population_quantity = population_quantity + sum(community_area(i).blocks_population);
end

population = [];
population.total_population = population_quantity;

end

