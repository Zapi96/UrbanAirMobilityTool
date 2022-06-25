function [boundaries] = func_create_centroids(boundaries)
%[boundaries] = create_centroids(boundaries)
%   Once the areas of the different boundaries used to discretize the city 
%   are known, this information is applied to obtain the correspondent
%   centroid
%   INPUT:
%      *boundaries:    % Table with information of the coordinates of the
%                        boundaries
%
%   OUTPUT:
%      *boundaries:    % Table with information of the coordinates of the
%                        centroids


% The warnings are deactivated
warning('off','all')

% A description of the Earth shape is selected for the geodetic2ecef
% function
wgs84 = wgs84Ellipsoid('kilometer');

% iconDir = 'D:\Google Drive\Aeroespacial\2º Master\Research project\Matlab\icon';
% icon         = ['pin_red','.png'];

% A loop is used to select the coordinates whose centroid is going to be
% calculated
for i = 1:length(boundaries.position_vector)
    % A temporal vector with the coordinated of a given boundari is created
    vector = boundaries.position_vector{i};
    % The latitude and longitude values are obtained from the previous
    % vector:
    latitude  = vector(2:2:end);
    longitude = vector(1:2:end-1);
    % The coordinates of the boundaries in geodetic are stored:
    lat_vector{i} = latitude;
    lon_vector{i} = longitude;
    % Knowing the latitude and longitude, the ecef coordinates can be
    % easily computed:
    [x,y,z] = geodetic2ecef(wgs84,latitude,longitude,0);
    % The coordinates of the boundaries in ecef are stored:
    x_vector{i} = x;
    y_vector{i} = y;
    z_vector{i} = z;
    % Poligonal shapes are generated using the information of the
    % boundaries and the function polyshape:
    pgon_ECEF(i) = polyshape(x,y);
    pgon_GEO(i)  = polyshape(longitude,latitude);
    % The function centroid allows to obtain the value of the centroid of a
    % polyshape
    [x_centroid(i),y_centroid(i)] = centroid(pgon_ECEF(i),1);
    z_centroid(i) = z(1);
    
    %   So that the trip generator works properly, the centroid at the
    %   airport must be located at the terminal
    if strcmp(inputname(1),'blocks')
        if x_centroid(i) <178 && y_centroid(i)>-4748
            [x_centroid(i),y_centroid(i),z_centroid(i)] = geodetic2ecef(wgs84,41.976931,-87.904569,0);
            lat(i) = 41.976931;
            lon(i) = -87.904569;
            h(i)   = 0;
        else
            [lat(i),lon(i),h(i)] = ecef2geodetic(wgs84,x_centroid(i),y_centroid(i),z_centroid(i));
        end
    else
        % The values of the centroids in ecef are converted to geodetic again
        [lat(i),lon(i)] = centroid(pgon_GEO(i),1);
        h(i) = 0;
    end
            
    
end

% All the results are then saved
boundaries.pgon_ECEF = pgon_ECEF';
boundaries.pgon_GEO  = pgon_GEO';

boundaries.x_centroid = x_centroid';
boundaries.y_centroid = y_centroid';
boundaries.z_centroid = z_centroid';

boundaries.lat_centroid = lat';
boundaries.lon_centroid = lon';
boundaries.h_centroid   = h';

boundaries.x_vector   = x_vector';
boundaries.y_vector   = y_vector';
boundaries.z_vector   = z_vector';

boundaries.lat_vector   = lat_vector';
boundaries.lon_vector   = lon_vector';


%   We have to made this to remove bad points for the area of O'hare
if strcmp(inputname(1),'areas')
    boundaries.x_vector(75)   = {x_vector{75}(1:2227)};
    boundaries.y_vector(75)   = {y_vector{75}(1:2227)};
    boundaries.pgon_ECEF(75)  = polyshape(boundaries.x_vector(75),boundaries.y_vector(75));
    boundaries.lat_vector(75) = {lat_vector{75}(1:2227)};
    boundaries.lon_vector(75) = {lon_vector{75}(1:2227)};
    boundaries.pgon_GEO(75)   = polyshape(boundaries.lat_vector(75),boundaries.lon_vector(75));
end
end

