function [h,labels] = func_boundaries_plot(community_area,line,size,centroids,UAMstops,type,map)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here

if ~isempty(line)
lines = load('Data/CTA/Data_Lines');
lines = lines.line;
end


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

labels = {};
h = [];
color   = [red; blue; green; brown; purple; purple2; yellow; pink; orange;];
% figure()
if strcmpi(type,'ecef')
    hold on
    for i = 1:length(community_area)
        plot([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],'k','Linewidth',0.8)
        if ~isempty(centroids)
            p_centroid = plot(community_area(i).centroid_x_population,community_area(i).centroid_y_population,'k.','MarkerSize',size);%     hold on
            labels(1) = {'Centroids'};
            h{1} =  p_centroid;
        end
        if ~isempty(community_area(i).UAMstops_x) && ~isempty(UAMstops)
            p_UAMstops = plot(community_area(i).UAMstops_x(1),community_area(i).UAMstops_y(1),'ko','MarkerSize',5,'LineWidth',2);
            labels(2)     = {'UAMstops/UAMports'};
            h{2}          = p_UAMstops;
        end
    end
    
    if ~isempty(line)
        for i=1:length(line_color)
            p_stations(i) = plot(lines.(char(line_color(i))).x,lines.(char(line_color(i))).y,'*','color',color(i,:));
            if i~=6
                plot(lines.(char(line_color(i))).x_line,lines.(char(line_color(i))).y_line,'color',color(i,:),'Linewidth',0.8);
            end
        end
        labels(3) = {'Stations'};
        h{3}      = p_stations;
    end
    set(gca,'XColor', 'none','YColor','none')
    
else
    for i = 1:length(community_area)
        geoplot([community_area(i).areas_lat_vector{1}],[community_area(i).areas_lon_vector{1}],'k','Linewidth',0.8)
        geobasemap(map)
        hold on
        if ~isempty(centroids)
            p_centroid = geoplot(community_area(i).centroid_lat_population,community_area(i).centroid_lon_population,'k.','MarkerSize',size);%     hold on
            labels(1) = {'Centroids'};
            h{1} =  p_centroid;
        end
        if ~isempty(community_area(i).UAMstops_x)  && ~isempty(UAMstops)
            p_UAMstops(i) = geoplot(community_area(i).UAMstops_lat(1),community_area(i).UAMstops_lon(1),'ko','MarkerSize',5,'LineWidth',2);
            labels(2) = {'UAMstops/UAMports'};
            h{2}      = p_UAMstops;
        end
    end
    
    if ~isempty(line)
        for i=1:length(line_color)
            p_stations(i) = geoplot(lines.(char(line_color(i))).latitude,lines.(char(line_color(i))).longitude,'*','color',color(i,:));
            if i~=6
                geoplot(lines.(char(line_color(i))).latitude_line,lines.(char(line_color(i))).longitude_line,'color',color(i,:),'Linewidth',0.8);
            end
        end
        labels(3) = {'Stations'};
        h{3}      = p_stations;
        
    end
    
end

if cellfun(@(x)~isempty(x),labels)
    [~,idex] = find(cellfun(@(x)~isempty(x),labels));
    legend( cellfun(@(x)x(end),h(idex)),labels{idex},'Interpreter','Latex');
end



end

