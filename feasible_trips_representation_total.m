function [] = feasible_trips_representation_total(community_area,flight,lines,centroids,UAMstops,cond,indx,label,hour,type,map,size_point)
%function [] = feasible_trips_representation(flight,rows,size_point,loc,commutes)
%   This function represents the trips on a Map when the trips are
%   compared just to all the legs. It is showing yhe absolut result.
%   INPUT:
%      *flight:     % Table with information about the flights
%      *size_point: % Size of the points represented in the plot
%      *indx:       % Among the randomly selected trips specified by row,
%                   % loc establishes the position of the chosen ones
%      *commutes:   % The table commutes is used to select especific areas
%      *label       % This label specifies the type of trip that we want to
%                     represent
%      *hour        % With hour we can select the time of the day

%   LOADING DATA
%   The first step consists of loading the data about the boundaries and
%   the metro lines
load('Data/Boundaries/Data_Boundaries_Areas','areas')

%   BOUNDARIES
%   We can now plot the areas of the city without the stations of the L
p = boundaries_plot(community_area,lines,2,centroids,UAMstops,type,map);
hold on
%   Now the index for the selected type are chosen:
indexs = indx(hour).(char(label));
if ~isempty(cond)
    indexs = intersect(indexs,cond);
end
if strcmpi(type,'centroids')
    %   We must check that the vector loc is not empty
    if ~isempty(indexs)
        for i = 1:length(indexs)
            %   Each values of loc represents one commute, so we must generate a
            %   for with the length of loc
            %   The next step consists of representing the origin and
            %   destination of the trips
            h(1) = plot(flight.origin_x(indexs(i)),flight.origin_y(indexs(i)),'cx','MarkerSize',8,'LineWidth',2,'DisplayName','Origin');
            h(2) = plot(flight.destination_x(indexs(i)),flight.destination_y(indexs(i)),'gx','MarkerSize',8,'LineWidth',2,'DisplayName','Destination');
            %   Once the origin and destination are represented, the next
            %   step consists of showing the paths with a straight line
            h(3) = plot([flight.origin_x(indexs(i)) ;flight.origin_UAMstops_x(indexs(i))],[flight.origin_y(indexs(i)) ;flight.origin_UAMstops_y(indexs(i))],'c-.','LineWidth',1,'DisplayName','Origin Path');
            h(4) = plot([flight.destination_x(indexs(i)) ;flight.destination_UAMstops_x(indexs(i))],[flight.destination_y(indexs(i)) ;flight.destination_UAMstops_y(indexs(i))],'g-.','LineWidth',1,'DisplayName','Destination Path');
            h(5) = plot([flight.origin_UAMstops_x(indexs(i)) ;flight.destination_UAMstops_x(indexs(i))],[flight.origin_UAMstops_y(indexs(i)) ;flight.destination_UAMstops_y(indexs(i))],'k-.','LineWidth',1,'DisplayName','Flight Path');
            
        end
        %     legend(p(1:7))
    end
else
    %   We must check that the vector loc is not empty
    if ~isempty(indexs)
        for i = 1:length(indexs)
            %   Each values of loc represents one commute, so we must generate a
            %   for with the length of loc
            %   The next step consists of representing the origin and
            %   destination of the trips
            geoplot(flight.origin_lat(indexs(i)),flight.origin_lon(indexs(i)),'x','MarkerSize',8,'LineWidth',2,'DisplayName','Origin','Color',[0, 0.4470, 0.7410]);
            geoplot(flight.destination_lat(indexs(i)),flight.destination_lon(indexs(i)),'gx','MarkerSize',8,'LineWidth',2,'DisplayName','Destination','Color',[0.8500, 0.3250, 0.0980]);
            %   Once the origin and destination are represented, the next
            %   step consists of showing the paths with a straight line
            geoplot([flight.origin_lat(indexs(i)) ;flight.origin_UAMstops_lat(indexs(i))],[flight.origin_lon(indexs(i)) ;flight.origin_UAMstops_lon(indexs(i))],'-.','LineWidth',1,'DisplayName','Origin Path','Color',[0, 0.4470, 0.7410]);
            geoplot([flight.destination_lat(indexs(i)) ;flight.destination_UAMstops_lat(indexs(i))],[flight.destination_lon(indexs(i)) ;flight.destination_UAMstops_lon(indexs(i))],'-.','LineWidth',1,'DisplayName','Destination Path','Color',[0.8500, 0.3250, 0.0980]);
            geoplot([flight.origin_UAMstops_lat(indexs(i)) ;flight.destination_UAMstops_lat(indexs(i))],[flight.origin_UAMstops_lon(indexs(i)) ;flight.destination_UAMstops_lon(indexs(i))],'k-.','LineWidth',1,'DisplayName','Flight Path');
            
        end
        %     legend(p(1:7))
    end
end
end




