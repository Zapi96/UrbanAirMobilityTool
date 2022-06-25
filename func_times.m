function [temp] = func_times(hour_day,commutes,congestion_increase,flight,mode)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

ini = datetime('00:00:00','Format','HH:mm:ss');
columns = [  15  9 10 3 4 22 16 17 7 8 ];


if  strcmp(mode,'flight_car')
    %   DESTINATION
    temp.arrival_destination_time        = repelem(ini+seconds(hour_day*3600),size(commutes.trip,1)).'; % s
    temp.arrival_destination_UAMstop_time = temp.arrival_destination_time-...
        seconds(commutes.trip.flight_car_trip(:,7)*...
        (1+congestion_increase(hour_day))*60); % s
    %   ORIGIN
    temp.departure_origin_UAMstop_time = temp.arrival_destination_UAMstop_time-...
        seconds(commutes.trip.flight_car_trip(:,5)*60);
    temp.departure_origin_time         = temp.departure_origin_UAMstop_time-...
        seconds(commutes.trip.flight_car_trip(:,1)*...
        (1+congestion_increase(hour_day))*60);
    %   TABLE
    temp = struct2table(temp);
     %   TRIP INFORMATION
    temp = [temp flight(:,columns)];
    
elseif strcmp(mode,'flight_transit')
    %   DESTINATION
    temp.arrival_destination_time        = repelem(ini+seconds(hour_day*3600),size(commutes.trip,1)).'; % s
    temp.arrival_destination_UAMstop_time = temp.arrival_destination_time-...
        seconds(commutes.trip.flight_transit_trip(:,7)*60); % s
    %   ORIGIN
    temp.departure_origin_UAMstop_time = temp.arrival_destination_UAMstop_time-...
        seconds(commutes.trip.flight_transit_trip(:,5)*60);
    temp.departure_origin_time         = temp.departure_origin_UAMstop_time-...
        seconds(commutes.trip.flight_transit_trip(:,1)*60);
    %   TABLE
    temp = struct2table(temp);
     %   TRIP INFORMATION
    temp = [temp flight(:,columns)];
elseif strcmp(mode,'drive')
    %   DESTINATION
    temp.arrival_destination_time    = repelem(ini+seconds(hour_day*3600),size(commutes.trip,1)).'; % s
    temp.departure_origin_time       = temp.arrival_destination_time-...
        seconds(commutes.trip.drive(:,1)*60);
    %   TABLE
    temp = struct2table(temp);
     %   TRIP INFORMATION
    temp = [temp flight(:,columns)];
else
    %   DESTINATION
    temp.arrival_destination_time = repelem(ini+seconds(hour_day*3600),size(commutes.trip,1)).'; % s
    temp.departure_origin_time       = temp.arrival_destination_time-...
        seconds(commutes.trip.transit(:,1)*60);
    %   TABLE
    temp = struct2table(temp);
    %   TRIP INFORMATION
    temp = [temp flight(:,columns)];
end









end

