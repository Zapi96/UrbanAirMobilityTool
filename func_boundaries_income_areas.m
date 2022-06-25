function [] = func_boundaries_income_areas(community_area,number_vector,type,centroids,size)
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

color   = [red; blue; green; brown; purple; purple2; yellow; pink; orange;];

switch type
    
    case 'Tracts'
        minimum = min(community_area(number_vector(1)).tracts_income);
        maximum = max(community_area(number_vector(1)).tracts_income);
        
        if maximum == minimum
            maximum = maximum+10;
            minimum = minimum-10;
        end
        
        figure('Position', [100 30 900 900])
%         colormap(flipud(summer ))
        for j = 1:length(number_vector)
            number = number_vector(j);
            for i = 1:length(community_area(number).tracts_x_vector)
                patch(community_area(number).tracts_x_vector{i},community_area(number).tracts_y_vector{i},community_area(number).tracts_income(i))
                hold on
            end
            if strcmp(centroids, 'Centroids')
                scatter(community_area(number).C_x,community_area(number).C_y,size,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
            end
        end
        h = colorbar;
        set(get(h,'title'),'string',{'Population Income [$]',' '});
        h.TickLabelInterpreter = 'latex';
        h.Label.Interpreter = 'latex';
        
        caxis([minimum maximum]);
        case 'Areas'
        
        figure('Position', [100 100 700 600])
        colormap(flipud(summer ))
        for j = 1:length(number_vector)
            number = number_vector(j);
            for i = 1:length(community_area(number).areas_x_vector)
                patch(community_area(number).areas_x_vector{i},community_area(number).areas_y_vector{i},community_area(number).areas_income(i))
                hold on
            end
            if strcmp(centroids, 'Centroids')
                scatter(community_area(number).C_x,community_area(number).C_y,size,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
            end
        end
        h = colorbar;
        set(get(h,'title'),'string');
        h.TickLabelInterpreter = 'latex';

        caxis([min([community_area(:).population]) max([community_area(:).population])]);
end

% for i=1:length(community_area(number).stations_x)
%     plot(community_area(number).stations_x(i),community_area(number).stations_y(i),'*','color',color(community_area(number).stations_colors(i),:))    
%     hold on
%     if ~isempty(community_area(i).vertistop_x)
%         plot(community_area(number).vertistop_x(1),community_area(number).vertistop_y(1),'ko','MarkerSize',5,'LineWidth',2)
%     end
% end
set(gca,'XColor', 'none','YColor','none')
set(gca, 'FontSize',12,'FontName','FixedWidthTex','TickLabelInterpreter','latex')

% x = community_area(number).stations_x_line(1);
% y = community_area(number).stations_y_line(1);
% for i = 2:length(community_area(number).stations_x_line)
%     if community_area(number).stations_colors_line(i)~=community_area(number).stations_colors_line(i-1)
%         plot(x,y,'color',color(community_area(number).stations_colors_line(i-1),:))
%         hold on
%         x = [];
%         y = [];
%     end 
%     x = [x; community_area(number).stations_x_line(i)];
%     y = [y; community_area(number).stations_y_line(i)];
%     
% end

end

