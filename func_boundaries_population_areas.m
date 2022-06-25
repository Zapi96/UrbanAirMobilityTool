function [h,h2,h3] = func_boundaries_population_areas(community_area,lines,UAMstops,number_vector,type,type_coordinates,centroids,size_line,map)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
line_color = {'Red','Blue','Green','Brown','Purple','Purple2','Yellow','Pink','Orange'};

red     = [1 0 0];
blue    = [0 0 1];
green   = [0 204/255 0];
brown   = [153/255 76/255 0];
purple  = [127/255 0 1];
purple2 = [102/255 0 204/255];
yellow  = [1 1 0];
pink    = [1 0 1];
orange  = [1 0.5 0];

h2 = [];
h3 = [];
% blue = [0, 0.4470, 0.7410];
% orange = [0.8500, 0.3250, 0.0980];
% yellow = [0.9290, 0.6940, 0.1250];
% purple = [0.4940, 0.1840, 0.5560];
% green =	[0.4660, 0.6740, 0.1880];
% cyan =      	[0.3010, 0.7450, 0.9330];
% magenta = [0.6350, 0.0780, 0.1840];

color   = [red; blue; green; brown; purple; purple2; yellow; pink; orange;];
% color = [blue; orange; yellow; purple; green; cyan; magenta];




if strcmpi(type_coordinates,'ecef')
    switch type
        
        case 'Blocks'
            
            minimum = min(community_area(number_vector(1)).blocks_population);
            maximum = max(community_area(number_vector(1)).blocks_population);
            for i = 1:length(number_vector)
                if min(community_area(number_vector(i)).blocks_population)<minimum
                    minimum = min(community_area(number_vector(i)).blocks_population);
                end
                if max(community_area(number_vector(i)).blocks_population)<maximum
                    maximum = max(community_area(number_vector(i)).blocks_population);
                end
            end
            
            
            %             figure('Position', [100 100 700 600])
            %             colormap('winter');
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).blocks_x_vector)
                    plot(community_area(number).blocks_x_vector{i},community_area(number).blocks_y_vector{i},'k');
                    hold on
                end
                if strcmpi(centroids, 'Centroids')
                    scatter(community_area(number).blocks_x_centroid,community_area(number).blocks_y_centroid,size_line,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
                end
            end
            %             h = colorbar;
            %             set(get(h,'title'),'string');
            %             h.Label.Interpreter = 'latex';
            
            %             caxis([minimum maximum]);
        case 'Tracts'
            minimum = min(community_area(number_vector(1)).tracts_income_hour);
            maximum = max(community_area(number_vector(1)).tracts_income_hour);
%                         minimum = min(community_area(number_vector(1)).tracts_population);
%                         maximum = max(community_area(number_vector(1)).tracts_population);
            %         for i = 1:length(number_vector)
            %             if min(community_area(number_vector(i)).tracts_population)<minimum
            %                 minimum = min(community_area(number_vector(i)).tracts_population);
            %             end
            %             if max(community_area(number_vector(i)).tracts_population)<maximum
            %                 maximum = max(community_area(number_vector(i)).tracts_population);
            %             end
            %         end
            if maximum == minimum
                maximum = maximum+10;
                minimum = minimum-10;
            end
            
            %             figure('Position', [100 100 700 600])
            %             colormap('parula')
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).tracts_x_vector)
%                       patch(community_area(number).tracts_lon_vector{i},community_area(number).tracts_lat_vector{i},community_area(number).tracts_population(i),'FaceAlpha',0.7);
                    patch(community_area(number).tracts_lon_vector{i},community_area(number).tracts_lat_vector{i},community_area(number).tracts_income_hour(i),'FaceAlpha',0.7);
                    hold on
                end
                if strcmpi(centroids, 'Centroids')
                    scatter(community_area(number).tracts_x_centroid,community_area(number).tracts_y_centroid,size_line,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
                end
            end
            %            h = colorbar;
            %  set(get(h,'title'),'string','Population','Fontname','times');
            
            caxis([minimum maximum]);
        case 'Areas'
            
            %             figure('Position', [100 100 700 600])
            colormap('parula')
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).areas_x_vector)
                    %                     patch(community_area(number).areas_x_vector{i},community_area(number).areas_y_vector{i},community_area(number).population(i));
                    h = plot(community_area(number).areas_lon_vector{i},community_area(number).areas_lat_vector{i},'k','DisplayName','Community Area Border');
                    
                    hold on
                end
                if strcmpi(centroids, 'Centroids')
                    plot(community_area(number).centroid_lon_population,community_area(number).centroid_lat_population,'k.','Markersize',10);
                    %                     plot(community_area(number).areas_x_centroid,community_area(number).areas_y_centroid,'k.','Markersize',10);
                end
            end
            %             h = colorbar;
            %             set(get(h,'title'),'string');
            %             h.TickLabelInterpreter = 'latex';
            %
            %             caxis([min([community_area(:).population]) max([community_area(:).population])]);
    end
    
    if ~isempty(UAMstops)
        for i=1:length(number_vector)
            number = number_vector(i);
            if ~isempty(community_area(number).UAMstops_x)
                h3 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
            end
        end
    end
    set(gca,'XColor', 'none','YColor','none')
    %     set(gca, 'FontSize',12,'FontName','FixedWidthTex','TickLabelInterpreter','latex')
    
    if ~isempty(lines)
        
         for j = 1:length(number_vector)
            number = number_vector(j);
            colors_lines_area = unique(community_area(number).stations_colors);
            for i = 1:length(colors_lines_area)
                positions = find(community_area(number).stations_colors == colors_lines_area(i));
                x = community_area(number).stations_lon(positions);
                y = community_area(number).stations_lat(positions);
                h2 (i) = plot(x,y,'*','MarkerSize',10,'color',color(colors_lines_area(i),:),'DisplayName',[line_color{i},' line station']);
                hold on
                
            end
        end
%         for i=1:length(community_area(number_vector).stations_x)
%            h2(i) =  plot(community_area(number_vector).stations_x(i),community_area(number_vector).stations_y(i),'*','color',color(community_area(number_vector).stations_colors(i),:));
%         end
%         colors = [];
%         for i = 1:length(number_vector)
%              
%             number = number_vector(i);
%             colors = [colors; community_area(number).stations_colors_line];
%              
%         end
%         colors_lines_area = unique(colors);        
%         for i = 1:length(colors_lines_area)
%             
%             x = [];
%             y = [];
%             for j = 1:length(number_vector)
%                 number = number_vector(j);
%                 positions = find(community_area(number).stations_colors_line == colors_lines_area(i));
%                 x = [x; community_area(number).stations_lon_line(positions)];
%                 y = [y; community_area(number).stations_lat_line(positions)];
%                 
%             end
%             plot(x,y,'color',color(colors_lines_area(i),:))
%             hold on
%         end

%             for j = 1:length(number_vector)
%                 number = number_vector(j);
%                 if ~isempty(community_area(number).stations_lat_line)
%                     x = community_area(number).stations_lon_line(1);
%                     y = community_area(number).stations_lat_line(1);
%                     for i = 2:length(community_area(number).stations_lat_line)
%                         if community_area(number).stations_colors_line(i)==community_area(number).stations_colors_line(i-1)
%                             plot(x,y,'color',color(community_area(number).stations_colors_line(i-1),:),'Linewidth',2)
%                             hold on
%                         else
%                             x = [];
%                             y = [];
%                         end
%                         x = [x; community_area(number).stations_lon_line(i)];
%                         y = [y; community_area(number).stations_lat_line(i)];
%                     end
%                 end
%             end
%         
%             
%             
        
    end
    
else
    switch type
        
        case 'Blocks'
            
            figure('Position', [100 100 700 600])
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).blocks_lat_vector)
                    geoplot(community_area(number).blocks_lat_vector{i},community_area(number).blocks_lon_vector{i},'k','Linewidth',size_line)
                    geobasemap(map)
                    hold on
                end
                if strcmpi(centroids, 'Centroids')
                    %                     geoplot(community_area(number).population_lat_centroid,community_area(number).population_lon_centroid,'k.','MarkerSize',2);
                    for k = 1:length(community_area(number).blocks_lat_centroid)
                        geoplot(community_area(number).blocks_lat_centroid(k),community_area(number).blocks_lon_centroid(k),'k.','MarkerSize',2);
                    end
                end
            end
            
            
        case 'Tracts'
            
            figure('Position', [100 100 700 600])
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).tracts_lat_vector)
                    geoplot(community_area(number).tracts_lat_vector{i},community_area(number).tracts_lon_vector{i},'k','Linewidth',size_line)
                    geobasemap(map)
                    hold on
                end
                if strcmp(centroids, 'Centroids')
                    geoplot(community_area(number).population_lat_centroid,community_area(number).population_lon_centroid,'k.','MarkerSize',size_line);
                    for k = 1:length(community_area(number).tracts_lat_centroid{i})
                        geoplot(community_area(number).tracts_lat_centroid{k},community_area(number).tracts_lon_centroid{k},'k.','MarkerSize',size_line/2);
                    end
                end
            end
            
        case 'Areas'
            
            figure('Position', [100 30 900 900])
            for j = 1:length(number_vector)
                number = number_vector(j);
                for i = 1:length(community_area(number).areas_lat_vector)
                    geoplot(community_area(number).areas_lat_vector{i},community_area(number).areas_lon_vector{i},'k','Linewidth',size_line)
                    geobasemap(map)
                    %                 fill3(community_area(number).areas_x_vector{i},community_area(number).areas_y_vector{i},zeros(1,length(community_area(number).areas_x_vector{i})),color(randi(length(color)),:))
                    
                    hold on
                end
                if strcmpi(centroids, 'Centroids')
                    geoplot(community_area(number).centroid_lat_population,community_area(number).centroid_lon_population,'k.','MarkerSize',size_line);
                end
            end
            
    end
    
    if ~isempty(UAMstops)
        for j=1:length(number_vector)
            number = number_vector(j);
            if ~isempty(community_area(number).UAMstops_lat)
                geoplot(community_area(number).UAMstops_lat(1),community_area(number).UAMstops_lon(1),'ko','MarkerSize',5,'LineWidth',2)
            end
        end
    end
    set(gca, 'FontSize',12,'FontName','FixedWidthTex')
    
    if ~isempty(lines)
        for j = 1:length(number_vector)
            number = number_vector(j);
            for i=1:length(community_area(number).stations_lat)
                geoplot(community_area(number).stations_lat(i),community_area(number).stations_lon(i),'*','color',color(community_area(number).stations_colors(i),:))
            end
        end
    end
    
    if ~isempty(lines)
        if length(number_vector) == 77
            for i=1:length(line_color)
                p_stations(i) = geoplot(lines.(char(line_color(i))).latitude,lines.(char(line_color(i))).longitude,'*','color',color(i,:));
                if i~=6
                    %         [x,y,z] = geodetic2ecef(wgs84,lines.(char(line_color(i))).latitude_line,lines.(char(line_color(i))).longitude_line,0);
                    geoplot(lines.(char(line_color(i))).latitude_line,lines.(char(line_color(i))).longitude_line,'color',color(i,:),'Linewidth',2);
                end
            end
        else
            for j = 1:length(number_vector)
                number = number_vector(j);
                if ~isempty(community_area(number).stations_lat_line)
                    x = community_area(number).stations_lat_line(1);
                    y = community_area(number).stations_lon_line(1);
                    for i = 2:length(community_area(number).stations_lat_line)
                        if community_area(number).stations_colors_line(i)==community_area(number).stations_colors_line(i-1)
                            geoplot(x,y,'color',color(community_area(number).stations_colors_line(i-1),:),'Linewidth',2)
                            hold on
                        else
                            x = [];
                            y = [];
                        end
                        x = [x; community_area(number).stations_lat_line(i)];
                        y = [y; community_area(number).stations_lon_line(i)];
                    end
                end
            end
        end
    end
end
end



