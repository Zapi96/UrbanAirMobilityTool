function [] = func_feasible_trips_representation(flight,rows,size_point,loc,commutes)
%function [] = feasible_trips_representation(flight,rows,size_point,loc,commutes)
%   This function represents the trips on a Map when the trips are
%   compared just to another leg like drive or transit.
%   INPUT:
%      *flight:     % Table with information about the flights
%      *rows:       % Elements of the table that are selected
%      *size_point: % Size of the points represented in the plot
%      *loc:        % Among the randomly selected trips specified by row,
%                   % loc establishes the position of the chosen ones
%      *commutes:   % The table commutes is used to select especific areas

%   LOADING DATA
%   The first step consists of loading the data about the boundaries and
%   the metro lines
load('Data/Data_Community_Area','community_area')
load('Data/Data_Boundaries_Areas','areas')
load('Data/Data_Lines','line')

%   BOUNDARIES
%   We can now plot the areas of the city without the stations of the L
p(1) = func_boundaries_plot_nostations(areas,community_area,line,size_point,[]);
hold on
%   We must check that the vector loc is not empty
if ~isempty(loc)
    %   Each values of loc represents one commute, so we must generate a
    %   for with the length of loc
    for i = 1:length(loc)
        %   We can set a condition so that we only show the desired trips
        if commutes.trip.area_to(rows(loc(i))) == 32 || commutes.trip.area_to(rows(loc(i))) == 8
            %   The next step consists of representing the origin and
            %   destination of the trips
            p(2) = plot(flight.origin_x(rows(loc(i))),flight.origin_y(rows(loc(i))),'cx','MarkerSize',8,'LineWidth',2,'DisplayName','Origin');
            p(3) = plot(flight.destination_x(rows(loc(i))),flight.destination_y(rows(loc(i))),'gx','MarkerSize',8,'LineWidth',2,'DisplayName','Destination');
            %   Once the origin and destination are represented, the next
            %   step consists of showing the paths with a straight line
            p(4) = plot([flight.origin_x(rows(loc(i))) ;flight.origin_vertistops_x(rows(loc(i)))],[flight.origin_y(rows(loc(i))) ;flight.origin_vertistops_y(rows(loc(i)))],'c-.','LineWidth',1,'DisplayName','Origin Path');
            p(5) = plot([flight.destination_x(rows(loc(i))) ;flight.destination_vertistops_x(rows(loc(i)))],[flight.destination_y(rows(loc(i))) ;flight.destination_vertistops_y(rows(loc(i)))],'g-.','LineWidth',1,'DisplayName','Destination Path');
            p(6) = plot([flight.origin_vertistops_x(rows(loc(i))) ;flight.destination_vertistops_x(rows(loc(i)))],[flight.origin_vertistops_y(rows(loc(i))) ;flight.destination_vertistops_y(rows(loc(i)))],'k-.','LineWidth',1,'DisplayName','Flight Path');
        end
    end
    %   Finally a legend is added
    legend(p(1:6))
end
end

