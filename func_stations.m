function [community_area,line] = func_stations(data,areas,community_area)
%[community_area,line] = stations(CTA,areas,community_area)
%   This function introduces the information about the metro lines of the
%   city into the matrix community_area
%   INPUT:
%      *data:           % Matrix with general data 
%      *areas:          % Matrix with information about the areas
%      *community_area: % Main matrix with most of the information
%   OUTPUT:
%      *community_area: % Main matrix with most of the information and
%                         now with the information of the stations per area
%      *line:  % Matrix with the same information found in the magtrix CTA
%                but classified depending on the lines

%%  DATA

%   Ellipsoid definition of the Earth
wgs84 = wgs84Ellipsoid('kilometer');
cta = func_kml2struct('Maps/cta.kml');

%%  LINES DIVISION

%   The function CTA_lines is used to classify the existing data in CTA
%   depending on the color of the line:
[line] = func_CTA_lines(data);
%   The list of colors of the lines is defined
line_color = {'Red','Blue','Green','Brown','Purple','Purple2','Yellow','Pink','Orange'};
%   The names of the lines provided by the CTA are saved in the following
%   variable
cta_names = {cta.Name};
%   IconDir is used to assign icons when they are represented in Google
%   Earth
%   UNCOMMENT FOR PIN REPRESENTATION ON A MAPS
% iconDir = 'D:\Google Drive\Aeroespacial\2º Master\Research project\Matlab\icon';

for i = 1:length(line_color)
    %   First this function looks for the position of each line in
    %   the matrix cta so that the coordinates can be selected
    [~,Locb] = ismember([line_color{i},' Line'],cta_names);
    
    %   UNCOMMENT FOR PIN REPRESENTATION ON MAPS
%     icon         = ['pin_',char(line_color(i)),'.png'];
%     iconFilename = fullfile(iconDir,icon);
    
    %   The coordinates are extracted 
    latitude  = line.(char(line_color(i))).latitude;
    longitude = line.(char(line_color(i))).longitude;
    name      = line.(char(line_color(i))).station_name;
    stop_id   = line.(char(line_color(i))).stop_id;
    stop_name = line.(char(line_color(i))).stop_name;

    
    %   The repeated stations are removed for all the data
    [name,m1] = unique(name,'first');
    latitude  = latitude(m1);
    longitude = longitude(m1);
    stop_id  = stop_id(m1);
    stop_name = stop_name(m1);
    
    line.(char(line_color(i))).stop_id = stop_id;
    line.(char(line_color(i))).latitude = latitude;
    line.(char(line_color(i))).longitude = longitude;
    line.(char(line_color(i))).stop_name  = stop_name;
    line.(char(line_color(i))).station_name = name;
    
    
    %   The coordinates are transformed to ecef
    [line.(char(line_color(i))).x,line.(char(line_color(i))).y,line.(char(line_color(i))).z] = geodetic2ecef(wgs84,latitude,longitude,0);
    
    %   Now the coordinates of the entire line are assigned
    if Locb >0
        line.(char(line_color(i))).latitude_line = cta(Locb).Lat;
        line.(char(line_color(i))).longitude_line = cta(Locb).Lon;
        [line.(char(line_color(i))).x_line, line.(char(line_color(i))).y_line,line.(char(line_color(i))).z_line] = geodetic2ecef(wgs84,cta(Locb).Lat,cta(Locb).Lon,0); 
    end
%     UNCOMMENT IF A KML MUST BE CREATED  
%     kmlwritepoint(['line_',char(line_color(i))],latitude,longitude,'Name',name,'Icon',iconFilename)
%     
%     filename = ['line_',char(line_color(i)),'.kml'];
%     %         winopen(filename)
end

areas = sortrows(areas, 'area_number');

line_color = {'Red','Blue','Green','Brown','Purple','Purple2','Yellow','Pink','Orange'};

%   Now the stations aregoing to be located in their correspondent area
for j = 1:length(community_area)
    %   The new data of the community_area is initialized
    community_area(j).stations_x           = [];
    community_area(j).stations_y           = [];
    community_area(j).stations_z           = [];
    community_area(j).stations_x_line      = [];
    community_area(j).stations_y_line      = [];
    community_area(j).stations_z_line      = [];
    community_area(j).stations_lat         = [];
    community_area(j).stations_lon         = [];
    community_area(j).stations_lat_line    = [];
    community_area(j).stations_lon_line    = [];
    community_area(j).stations_colors      = [];
    community_area(j).stations_colors_line = [];
    community_area(j).stations_numbers     = [];
    %   Every line will be analyzed
    for i = 1:length(line_color)
        %   The coordinates of the selected line are extracted
        x_stations      = line.(char(line_color(i))).x;
        y_stations      = line.(char(line_color(i))).y;
        z_stations      = line.(char(line_color(i))).z;
        lat_stations    = line.(char(line_color(i))).latitude;
        lon_stations    = line.(char(line_color(i))).longitude;
        name_stations   = line.(char(line_color(i))).stop_id;
        %   The line Purple2 will not be used
        if i ~=6
            x_stations_line = line.(char(line_color(i))).x_line;
            y_stations_line = line.(char(line_color(i))).y_line;
            z_stations_line = line.(char(line_color(i))).z_line;
            lat_stations_line    = line.(char(line_color(i))).latitude_line;
            lon_stations_line    = line.(char(line_color(i))).longitude_line;
        end
        %   The function inpolygon uses the coordinates of the boundaries of
        %   the areas to find which coordinates of the stations or of the
        %   lines are within those borders
        in_stations = inpolygon(x_stations,y_stations,areas.x_vector{j},areas.y_vector{j});
        in_line     = inpolygon(x_stations_line,y_stations_line,areas.x_vector{j},areas.y_vector{j});
        %   When there are stations within an area, the data are saved in
        %   the community_area matrix
        if sum(in_stations)~=0
            %   First the location of the stations within a given area
            community_area(j).stations_x   = [community_area(j).stations_x;x_stations(in_stations)];
            community_area(j).stations_y   = [community_area(j).stations_y;y_stations(in_stations)];
            community_area(j).stations_z   = [community_area(j).stations_z;z_stations(in_stations)];
            community_area(j).stations_lat = [community_area(j).stations_lat;lat_stations(in_stations)];
            community_area(j).stations_lon = [community_area(j).stations_lon;lon_stations(in_stations)];
            %   The colors are also saved
            stations_colors = repmat(i,length(x_stations(in_stations)),1);
            community_area(j).stations_colors = [community_area(j).stations_colors; stations_colors];
            community_area(j).stations_numbers = [community_area(j).stations_numbers; name_stations(in_stations)];
            %   The same procedure is followed for the stations 
            if i ~=6
                community_area(j).stations_x_line = [community_area(j).stations_x_line;line.(char(line_color(i))).x_line(in_line)];
                community_area(j).stations_y_line = [community_area(j).stations_y_line;line.(char(line_color(i))).y_line(in_line)];
                community_area(j).stations_z_line = [community_area(j).stations_z_line;line.(char(line_color(i))).z_line(in_line)];
                community_area(j).stations_lat_line = [community_area(j).stations_lat_line;line.(char(line_color(i))).latitude_line(in_line)];
                community_area(j).stations_lon_line = [community_area(j).stations_lon_line;line.(char(line_color(i))).longitude_line(in_line)];
                stations_colors_lines = ones(length(line.(char(line_color(i))).x_line(in_line)),1).*i;
                
                community_area(j).stations_colors_line = [community_area(j).stations_colors_line; stations_colors_lines];
                
            end
        end
    end
end

end

