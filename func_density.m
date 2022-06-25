function [DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit,effective_cost,indx,removed_ride_sharing_car,removed_ride_sharing_transit] = func_density(commutes,probability,duration,data_congestiont,cost,flight,ride_sharing)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%   INITIALIZATION
hour = probability.hour;
probability = probability.value;

%   TIME
%   Now we need to extract the data about the time
transit_total_time     = commutes.trip.transit; % min
flight_transit_total_time = commutes.trip.flight_transit_trip(:,8);     % min

%   PROBABILITY SELECTION
%   We need to know the duration of the intervals in the data
interval_duration = zeros(1,length(hour));
for i = 1:length(hour)
    hour_vector = hour{i};
    interval_duration(i) = hour_vector(2)-hour_vector(1);
end

%   Now, it is time to look for the interval in the vector of intervals
loc = find(interval_duration == duration);

%   Once the position is known, the probability vector can be extracted for
%   that kind of interval
probability_selected      = probability{loc};
hour_selected             = hour{loc};
%   The next step consists of determining the number of trips
amount = size(commutes.trip,1)*probability_selected/100;

for i = 1:length(hour_selected)
    disp(i)
    %   The probability and the number of trips can be also extracted for one
    %   specific hour
    probability_selected_hour = probability_selected(hour_selected == hour_selected(i));
    amount_selected_hour      = amount(hour_selected == hour_selected(i));
    
    
    % CHANGE OF TIME DEPENDING ON THE HOUR OF THE DAY
    
    %   The time that we have is withous the inffluence of traffic, thus we
    %   must include that influence using the data from Tomtom:
    drive_total_time      = commutes.trip.drive(:,1)*(1+data_congestiont(hour_selected(i)));
    flight_car_total_time = commutes.trip.flight_car_trip(:,1)*...
        (1+data_congestiont(hour_selected(i)))+...
        sum(commutes.trip.flight_car_trip(:,2:6),2)+...
        commutes.trip.flight_car_trip(:,7)*...
        (1+data_congestiont(hour_selected(i)));     % min
    
    
    [commutes_hour.flight_car{i,1}]     = func_times(hour_selected(i),commutes,data_congestiont,flight,'flight_car');
    [commutes_hour.flight_transit{i,1}] = func_times(hour_selected(i),commutes,data_congestiont,flight,'flight_transit');
    [commutes_hour.drive{i,1}]          = func_times(hour_selected(i),commutes,data_congestiont,flight,'drive');
    [commutes_hour.transit{i,1}]        = func_times(hour_selected(i),commutes,data_congestiont,flight,'transit');
    
    %  EFFECTIVE COST
    %   We must select first the number of trips that we want to calculate
    n = length(commutes.trip.distance);
    %   Of those trips we select the number of trips more likely to happen
    %   at this hour (we select the rows of the created tables)
    rows = randsample(n,floor(amount_selected_hour));
    
    
    [effective_cost(i),indx(i),removed_ride_sharing_car(i),removed_ride_sharing_transit(i),commutes_hour] = func_effective_cost(commutes,flight,cost,rows,drive_total_time,flight_car_total_time,transit_total_time,flight_transit_total_time,ride_sharing,commutes_hour,hour_selected(i));
    
end
effective_cost = struct2table(effective_cost);
indx = struct2table(indx);

%   Now with these results we can create a dataset:
DatasetsUAMstops_flight = [];
Datasets_Drive = [];
Datasets_Transit = [];

[DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit] = func_dataset(DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit,indx,commutes_hour,effective_cost,'initial');
[DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit] = func_dataset(DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit,indx,commutes_hour,effective_cost,'short');
[DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit] = func_dataset(DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit,indx,commutes_hour,effective_cost,'long');
end



