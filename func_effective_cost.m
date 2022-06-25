function [effective_cost,indx,removed_ride_sharing_car,removed_ride_sharing_transit,commutes_hour,commutes] = func_effective_cost(commutes,flight,cost,rows,drive_total_time,flight_car_total_time,transit_total_time,flight_transit_total_time,ride_sharing,commutes_hour,hour)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

%   Factor of conversion from kilometers to miles
km2miles = 0.62;

%   Value of commutes_hour:

value_time = commutes.trip.tract_from_income_hour(rows);

%   Cost car:
% cost.drive = cost.drive*car_speed;

for i = 1:length(cost.initial)
    
    
    %% RIDE-SHARING
    car_origin_UAMstop         = commutes_hour.flight_car{hour}{:,9};
    car_destination_UAMstop    = commutes_hour.flight_car{hour}{:,5};
    car_arrival_dest_UAMstop   = datenum(dateshift(commutes_hour.flight_car{hour}{:,2}, 'start', 'minute', 'nearest'));
    car_departure_orig_UAMstop = datenum(dateshift(commutes_hour.flight_car{hour}{:,3}, 'start', 'minute', 'nearest'));
    
    transit_origin_UAMstop         = commutes_hour.flight_transit{hour}{:,9};
    transit_destination_UAMstop    = commutes_hour.flight_transit{hour}{:,5};
    transit_arrival_dest_UAMstop   = datenum(dateshift(commutes_hour.flight_transit{hour}{:,2}, 'start', 'minute', 'nearest'));
    transit_departure_orig_UAMstop = datenum(dateshift(commutes_hour.flight_transit{hour}{:,3}, 'start', 'minute', 'nearest'));
    
    removed_ride_sharing_car = 0;
    removed_ride_sharing_transit = 0;
    
    %     ride_sharing_car = 0;
    %     ride_sharing_transit = 0;
    
    commutes_hour.flight_transit{hour}.ride_sharing(1:size(transit_origin_UAMstop)) = 0;
    commutes_hour.flight_car{hour}.ride_sharing(1:size(transit_origin_UAMstop)) = 0;
    
    car_ride_sharing_matrix = zeros(length(transit_origin_UAMstop),1);
    transit_ride_sharing_matrix = zeros(length(transit_origin_UAMstop),1);
    if ride_sharing == true
        for j = 1:length(rows)
            
            %         disp(j)
            
            comp = rows(rows~=rows(j));
            
            matrix_car = [car_origin_UAMstop(comp), car_destination_UAMstop(comp),...
                car_arrival_dest_UAMstop(comp), car_departure_orig_UAMstop(comp)];
            matrix_transit = [transit_origin_UAMstop(comp), transit_destination_UAMstop(comp),...
                transit_arrival_dest_UAMstop(comp), transit_departure_orig_UAMstop(comp)];
            
            [r,c] = size(matrix_car);
            
            matrix_row_car  = repmat([car_origin_UAMstop(rows(j)), car_destination_UAMstop(rows(j)),...
                car_arrival_dest_UAMstop(rows(j)), car_departure_orig_UAMstop(rows(j))],r,1);
            matrix_row_transit  = repmat([transit_origin_UAMstop(rows(j)), transit_destination_UAMstop(rows(j)),...
                transit_arrival_dest_UAMstop(rows(j)), transit_departure_orig_UAMstop(rows(j))],r,1);
            
            vector_comparison_car = sum(matrix_car-matrix_row_car,2);
            vector_comparison_transit = sum(matrix_transit-matrix_row_transit,2);
            
            idx_car = find(vector_comparison_car==0);
            idx_transit = find(vector_comparison_transit==0);
            
            remove_car = length(find(idx_car))+1;
            remove_transit = length(idx_transit)+1;
            
            remove_car = floor(remove_car/2);
            remove_transit = floor(remove_transit/2);
            
            if remove_car>0
                commutes_hour.flight_car{hour}.ride_sharing(rows(j)) = 1;
                commutes_hour.flight_car{hour}.ride_sharing(comp(idx_car(1:remove_car))) = 1;
                car_ride_sharing_matrix(rows(j)) = 1;
                car_ride_sharing_matrix(comp(idx_car(1:remove_car))) = 1;
                
            end
            
            if remove_transit>0
                commutes_hour.flight_transit{hour}.ride_sharing(rows(j)) = 1;
                commutes_hour.flight_transit{hour}.ride_sharing(rows(idx_transit(1:remove_transit))) = 1;
                transit_ride_sharing_matrix(rows(j)) = 1;
                transit_ride_sharing_matrix(comp(idx_transit(1:remove_transit))) = 1;
            end
            
            %         commutes_hour.flight_car{hour}.trips(rows(j)) = length(find(vector_comparison_car==0))+1-match_car;
            %         commutes_hour.flight_transit{hour}.trips(rows(j)) = length(find(vector_comparison_transit==0))+1-match_transit;
            %
            %         commutes_hour.flight_car{hour}.trips(rows(idx_car)) = 0;
            %         commutes_hour.flight_transit{hour}.trips(rows(idx_car)) = 0;
            
            removed_ride_sharing_car = removed_ride_sharing_car + remove_car;
            removed_ride_sharing_transit = removed_ride_sharing_transit + remove_transit;
            
            
            
            car_origin_UAMstop(comp(idx_car))         = nan;
            car_destination_UAMstop(comp(idx_car))     = nan;
            car_arrival_dest_UAMstop(comp(idx_car))    = nan;
            car_departure_orig_UAMstop(comp(idx_car))  = nan;
            
            transit_origin_UAMstop(comp(idx_transit))         = nan;
            transit_destination_UAMstop(comp(idx_transit))    = nan;
            transit_arrival_dest_UAMstop(comp(idx_transit))   = nan;
            transit_departure_orig_UAMstop(comp(idx_transit)) = nan;
            
        end
    end
    %   DRIVING AND TRANSIT COST
    commutes.trip.drive(rows,3)               = cost.drive*commutes.trip.drive(rows,2)*km2miles+value_time.*drive_total_time(rows)/60;
    commutes.trip.transit(rows,2)             = cost.transit+transit_total_time(rows)/60.*value_time;
    
    %   INITIAL
    %   Effective cost per trip
    commutes.trip.flight_transit_trip(rows,10) = cost.initial(i)*flight.path_distance(rows)*km2miles./2.^transit_ride_sharing_matrix(rows)+cost.transit*2+value_time.*flight_transit_total_time(rows)/60;
    commutes.trip.flight_car_trip(rows,12)    = cost.initial(i)*flight.path_distance(rows)*km2miles./2.^car_ride_sharing_matrix(rows)+...
        (commutes.trip.flight_car_trip(rows,9)+commutes.trip.flight_car_trip(rows,11))*km2miles*cost.drive+...
        value_time.*flight_car_total_time(rows)/60;
    
    %   SHORT-TERM
    %   Effective cost per trip:
    commutes.trip.flight_transit_trip(rows,11) = cost.short(i)*flight.path_distance(rows)*km2miles./2.^transit_ride_sharing_matrix(rows)+cost.transit*2+value_time.*flight_transit_total_time(rows)/60;
    commutes.trip.flight_car_trip(rows,13)     = cost.short(i)*flight.path_distance(rows)*km2miles./2.^car_ride_sharing_matrix(rows)+...
        (commutes.trip.flight_car_trip(rows,9)+commutes.trip.flight_car_trip(rows,11))*km2miles*cost.drive+...
        value_time.*flight_car_total_time(rows)/60;
    
    %   LONG-TERM
    %   Effective cost per trip:
    commutes.trip.flight_transit_trip(rows,12) = cost.long(i)*flight.path_distance(rows)*km2miles./2.^transit_ride_sharing_matrix(rows)+cost.transit*2+value_time.*flight_transit_total_time(rows)/60;
    commutes.trip.flight_car_trip(rows,14)     = cost.long(i)*flight.path_distance(rows)*km2miles./2.^car_ride_sharing_matrix(rows)+...
        (commutes.trip.flight_car_trip(rows,9)+commutes.trip.flight_car_trip(rows,11))*km2miles*cost.drive+...
        value_time.*flight_car_total_time(rows)/60;
    
    %%  TOTAL TIME COST COMPARISON
    
    
    %   To make the things easier we are going to join the matrices:
    
    initial_cost_matrix = [commutes.trip.flight_car_trip(rows,12)...
        commutes.trip.flight_transit_trip(rows,10)...
        commutes.trip.drive(rows,3)...
        commutes.trip.transit(rows,2)];
    
    short_term_cost_matrix = [commutes.trip.flight_car_trip(rows,13)...
        commutes.trip.flight_transit_trip(rows,11)...
        commutes.trip.drive(rows,3)...
        commutes.trip.transit(rows,2)];
    
    long_term_cost_matrix =   [commutes.trip.flight_car_trip(rows,14)...
        commutes.trip.flight_transit_trip(rows,12)...
        commutes.trip.drive(rows,3)...
        commutes.trip.transit(rows,2)];
    
    %   INITIAL
    [~, minIndices] = min(initial_cost_matrix,[],2);
    
    loc1 = find(minIndices==1);
    loc2 = find(minIndices==2);
    loc3 = find(minIndices==3);
    loc4 = find(minIndices==4);
    
    indx.initial_flight_car     = rows(loc1);
    indx.initial_flight_transit = rows(loc2);
    indx.initial_drive          = rows(loc3);
    indx.initial_transit        = rows(loc4);
    
    effective_cost.initial_flight_car     = initial_cost_matrix(loc1,1) ;
    effective_cost.initial_flight_transit = initial_cost_matrix(loc2,2);
    effective_cost.initial_drive          = initial_cost_matrix(loc3,3);
    effective_cost.initial_transit        = initial_cost_matrix(loc4,4);
    
    %   SHORT
    [~, minIndices] = min(short_term_cost_matrix,[],2);
    
    loc1 = find(minIndices==1);
    loc2 = find(minIndices==2);
    loc3 = find(minIndices==3);
    loc4 = find(minIndices==4);
    
    indx.short_flight_car     = rows(loc1);
    indx.short_flight_transit = rows(loc2);
    indx.short_drive          = rows(loc3);
    indx.short_transit        = rows(loc4);
    
    effective_cost.short_flight_car     = short_term_cost_matrix(loc1,1);
    effective_cost.short_flight_transit = short_term_cost_matrix(loc2,2);
    effective_cost.short_drive          = short_term_cost_matrix(loc3,3);
    effective_cost.short_transit        = short_term_cost_matrix(loc4,4);
    
    %   LONG
    [~, minIndices] = min(long_term_cost_matrix,[],2);
    
    loc1 = find(minIndices==1);
    loc2 = find(minIndices==2);
    loc3 = find(minIndices==3);
    loc4 = find(minIndices==4);
    
    indx.long_flight_car     = rows(loc1);
    indx.long_flight_transit = rows(loc2);
    indx.long_drive          = rows(loc3);
    indx.long_transit        = rows(loc4);
    
    effective_cost.long_flight_car     = long_term_cost_matrix(loc1,1);
    effective_cost.long_flight_transit = long_term_cost_matrix(loc2,2);
    effective_cost.long_drive          = long_term_cost_matrix(loc3,3);
    effective_cost.long_transit        = long_term_cost_matrix(loc4,4);
    
    %   REPRESENTATION
    %     effective_cost.total_time_flight_car     = [total_time_effective_cost_flight_car_initial     total_time_effective_cost_flight_car_short     total_time_effective_cost_flight_car_long];
    %     effective_cost.total_time_flight_transit = [total_time_effective_cost_flight_transit_initial total_time_effective_cost_flight_transit_short total_time_effective_cost_flight_transit_long];
    %     effective_cost.drive          = [total_time_effective_cost_drive_initial          total_time_effective_cost_drive_short          total_time_effective_cost_drive_long];
    %     effective_cost.transit        = [total_time_effective_cost_transit_initial        total_time_effective_cost_transit_short        total_time_effective_cost_transit_long];
    
end
end

