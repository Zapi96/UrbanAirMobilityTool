function [h] = boundaries_plot_nostations(areas,community_area,lines,size,centroids)
%UNTITLED12 Summary of this function goes here
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

color   = [red; blue; green; brown; purple; purple2; yellow; pink; orange;];
figure('Position', [100 100 900 900])
% plot(areas.pgon_ECEF(:))
hold on
for i = 1:length(community_area)
    plot([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],'k','Linewidth',0.8)
    if strcmp(centroids,'Centroids')
        p_centroid = scatter(community_area(i).C_x,community_area(i).C_y,size,'o','MarkerEdgeColor','k','MarkerFaceColor','k');%     hold on
    end
    
    if ~isempty(community_area(i).UAMstops_x)
        p_UAMstops(i) = plot(community_area(i).UAMstops_lon(1),community_area(i).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2);
    end
    
%     if ~isempty(community_area(i).helipads_x)
%         p_helipad(i) = scatter(community_area(i).helipads_x,community_area(i).helipads_y,'ro','LineWidth',1.5);
%     end
%     
    
end
wgs84 = wgs84Ellipsoid('kilometer');



for i=1:length(line_color)
    if i~=6
        %         [x,y,z] = geodetic2ecef(wgs84,lines.(char(line_color(i))).latitude_line,lines.(char(line_color(i))).longitude_line,0);
        plot(lines.(char(line_color(i))).longitude_line,lines.(char(line_color(i))).latitude_line,'color',color(i,:),'Linewidth',1);
        
    end
    
    hold on
    
end
if strcmp(centroids,'Centroids')
    h = [p_UAMstops(end);p_centroid(end);p_helipad(end)];
    legend( h,'UAMstops/Vertiport','Centroid','Helipad','Interpreter','Latex')
    
else
    h = [p_UAMstops(end)];
    legend(p_UAMstops(end),'UAMstops/UAMport','Interpreter Latex')
    legend( h,'UAMstops/UAMport','Helipads','Interpreter','Latex')
end


set(gca,'XColor', 'none','YColor','none')





end

