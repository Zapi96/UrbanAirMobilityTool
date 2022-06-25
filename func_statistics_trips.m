function [statistics] = func_statistics_trips(indx, commutes,effective_cost,label)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

indx_flight_transit = indx.([char(label),'_flight_transit']);
indx_flight_car = indx.([char(label),'_flight_car']);


effective_cost_transit = effective_cost.([char(label),'_flight_transit']);
effective_cost_car = effective_cost.([char(label),'_flight_car']);

%   DURATION
statistics.duration_flight_transit = cell(size(indx,1),1);
statistics.duration_flight_car = cell(size(indx,1),1);
statistics.median_duration_flight_transit = zeros(size(indx,1),1);
statistics.median_duration_flight_car = zeros(size(indx,1),1);

statistics.duration_transit = cell(size(indx,1),1);
statistics.duration_car = cell(size(indx,1),1);
statistics.median_duration_transit = zeros(size(indx,1),1);
statistics.median_duration_car = zeros(size(indx,1),1);

statistics.duration_transit_transit = cell(size(indx,1),1);
statistics.duration_car_transit = cell(size(indx,1),1);
statistics.median_duration_transit_transit = zeros(size(indx,1),1);
statistics.median_duration_car_transit = zeros(size(indx,1),1);

statistics.duration_transit_car = cell(size(indx,1),1);
statistics.duration_car_car = cell(size(indx,1),1);
statistics.median_duration_transit_car = zeros(size(indx,1),1);
statistics.median_duration_car_car = zeros(size(indx,1),1);

%   DISTANCE
statistics.distance_transit = cell(size(indx,1),1);
statistics.distance_car = cell(size(indx,1),1);
statistics.median_distance_transit = zeros(size(indx,1),1);
statistics.median_distance_car = zeros(size(indx,1),1);

%   COST
statistics.cost_transit = cell(size(indx,1),1);
statistics.cost_car = cell(size(indx,1),1);
statistics.median_cost_transit = zeros(size(indx,1),1);
statistics.median_cost_car = zeros(size(indx,1),1);

%   COST
statistics.vtime_transit = cell(size(indx,1),1);
statistics.vtime_car = cell(size(indx,1),1);
statistics.median_vtime_transit = zeros(size(indx,1),1);
statistics.median_vtime_car = zeros(size(indx,1),1);

%   ORIGIN
statistics.origin_tract_transit      = cell(size(indx,1),1);
statistics.origin_tract_car          = cell(size(indx,1),1);
statistics.main_origin_tract_transit = cell(size(indx,1),1);
statistics.main_origin_tract_car     = cell(size(indx,1),1);

statistics.origin_area_transit      = cell(size(indx,1),1);
statistics.origin_area_car          = cell(size(indx,1),1);
statistics.main_origin_area_transit = cell(size(indx,1),1);
statistics.main_origin_area_car     = cell(size(indx,1),1);

%   DESTINATION
statistics.destination_tract_transit      = cell(size(indx,1),1);
statistics.destination_tract_car          = cell(size(indx,1),1);
statistics.main_destination_tract_transit = cell(size(indx,1),1);
statistics.main_destination_tract_car     = cell(size(indx,1),1);

statistics.destination_area_transit      = cell(size(indx,1),1);
statistics.destination_area_car          = cell(size(indx,1),1);
statistics.main_destination_area_transit = cell(size(indx,1),1);
statistics.main_destination_area_car     = cell(size(indx,1),1);


for i = 1:size(indx,1)
    if indx_flight_transit{i} ~= 0
        %   DURATION
        statistics.duration_transit_transit{i,1}         = commutes.trip.transit(indx_flight_transit{i},1);
        statistics.median_duration_transit_transit(i,1) = median(statistics.duration_transit_transit{i,1});
        statistics.duration_car_transit{i,1}         = commutes.trip.drive(indx_flight_transit{i},1);
        statistics.median_duration_car_transit(i,1) = median(statistics.duration_car_transit{i,1});
    end
    if indx_flight_car{i} ~= 0
        %   DURATION
        statistics.duration_car_car{i,1}         = commutes.trip.drive(indx_flight_car{i},1);
        statistics.median_duration_car_car(i,1) = median(statistics.duration_car_car{i,1});
        statistics.duration_transit_car{i,1}         = commutes.trip.transit(indx_flight_car{i},1);
        statistics.median_duration_transit_car(i,1) = median(statistics.duration_transit_car{i,1});
    end
    if indx_flight_transit{i} ~= 0
        %   DURATION
        statistics.duration_flight_transit{i,1}         = commutes.trip.flight_transit_trip(indx_flight_transit{i},8);
        statistics.median_duration_flight_transit(i,1) = median(statistics.duration_flight_transit{i,1});
        
        %   DISTANCE
        statistics.distance_transit{i,1}         = commutes.trip.distance(indx_flight_transit{i});
        statistics.median_distance_transit(i,1) = median(statistics.distance_transit{i,1});
        
        %   COST
        statistics.cost_transit{i,1}         = effective_cost_transit{i};
        statistics.median_cost_transit(i,1) = median(statistics.cost_transit{i,1});
        
        %   TIME VALUE
        statistics.vtime_transit{i,1}         = commutes.trip.tract_from_income_hour(indx_flight_transit{i});
        statistics.median_vtime_transit(i,1) = median(statistics.vtime_transit{i,1});
        
        %   ORIGIN
        statistics.origin_tract_transit{i,1} = commutes.trip.tract_from(indx_flight_transit{i});
        [a,b] = hist(statistics.origin_tract_transit{i,1},unique(statistics.origin_tract_transit{i,1}));
        b = b(a~=0);
        a = a(a~=0);       
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_origin_tract_transit{i,1} = b;
        statistics.main_origin_tract_transit{i,2} = a;
        
        statistics.origin_area_transit{i,1} = commutes.trip.area_from(indx_flight_transit{i});
        [a,b]=hist(statistics.origin_area_transit{i,1},unique(statistics.origin_area_transit{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_origin_area_transit{i,1} = b;
        statistics.main_origin_area_transit{i,2} = a;
        
        %   DESTINATION
        statistics.destination_tract_transit{i,1} = commutes.trip.tract_to(indx_flight_transit{i});
        [a,b]=hist(statistics.destination_tract_transit{i,1},unique(statistics.destination_tract_transit{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_destination_tract_transit{i,1} = b;
        statistics.main_destination_tract_transit{i,2} = a;
        
        statistics.destination_area_transit{i,1} = commutes.trip.area_to(indx_flight_transit{i});
        [a,b]=hist(statistics.destination_area_transit{i,1},unique(statistics.destination_area_transit{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_destination_area_transit{i,1} = b;
        statistics.main_destination_area_transit{i,2} = a;
        
        
    end
   
    if indx_flight_car{i} ~= 0
        %   DURATION
        statistics.duration_flight_car{i,1}         = commutes.trip.flight_car_trip(indx_flight_car{i},8);
        statistics.median_duration_flight_car(i,1) = median(statistics.duration_flight_car{i,1});
        
        %   DISTANCE
        statistics.distance_car{i,1}         = commutes.trip.distance(indx_flight_car{i});
        statistics.median_distance_car(i,1) = median(statistics.distance_car{i,1});
        
        %   COST
        statistics.cost_car{i,1}         = effective_cost_car{i};
        statistics.median_cost_car(i,1) = median(statistics.cost_car{i,1});
        
        %   TIME VALUE
        statistics.vtime_car{i,1}         = commutes.trip.tract_from_income_hour(indx_flight_car{i});
        statistics.median_vtime_car(i,1) = median(statistics.vtime_car{i,1});
        
        %   ORIGIN
        statistics.origin_tract_car{i,1} = commutes.trip.tract_from(indx_flight_car{i});
        [a,b]=hist(statistics.origin_tract_car{i,1},unique(statistics.origin_tract_car{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_origin_tract_car{i,1} = b;
        statistics.main_origin_tract_car{i,2} = a;
        
        statistics.origin_area_car{i,1} = commutes.trip.area_from(indx_flight_car{i});
        [a,b]=hist(statistics.origin_area_car{i,1},unique(statistics.origin_area_car{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_origin_area_car{i,1} = b;
        statistics.main_origin_area_car{i,2} = a;

        
        %   DESTINATION
        statistics.destination_tract_car{i,1} = commutes.trip.tract_to(indx_flight_car{i});
        [a,b]=hist(statistics.destination_tract_car{i,1},unique(statistics.destination_tract_car{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_destination_tract_car{i,1} = b;
        statistics.main_destination_tract_car{i,2} = a;

        
        statistics.destination_area_car{i,1} = commutes.trip.area_to(indx_flight_car{i});
        [a,b]=hist(statistics.destination_area_car{i,1},unique(statistics.destination_area_car{i,1}));
        b = b(a~=0);
        a = a(a~=0);
        [a,I] = sort(a,'descend');
        b = b(I);
        if length(b)>5
            b = b(1:5);
            a = a(1:5);
        else
            b = b(1:end);
            a = a(1:end);
        end
        statistics.main_destination_area_car{i,1} = b;
        statistics.main_destination_area_car{i,2} = a;

    end
    
end
end

