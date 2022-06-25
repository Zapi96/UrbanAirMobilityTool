clear all; close all; clc;

%%   LOAD DATA
load Data/Commutes/Data_Commutes_Maps3
load Results/Probability/Results_Probability
load Data/Community Area/Data_Community_Area
load Data/Boundaries/Data_Boundaries_Areas
load Data/CTA/Data_Lines
load Data/TomTom/Data_Congestion

%%  INITIALIZATION
%   First we must select the interval of arrival to be studied
duration = 1;                 % Width of the interval in hours
hour_day = 1:24;                 % Hour of arrival

%%  FLIGHT INFORMATION
dest_idx = 1:size(commutes.trip,1);
flight = flight_information(commutes,community_area,dest_idx);
flight = struct2table(flight);

%%  TIME
%   Now we need to extract the data about the time
commutes_hour.transit.total_time     = commutes.trip.transit; % min
commutes_hour.flight_transit.total_time = commutes.trip.flight_transit_trip(:,8);     % min

%%   PROBABILITY SELECTION

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

for i = 1:length(hour_day)
    %   The probability and the number of trips can be also extracted for one
    %   specific hour
    probability_selected_hour = probability_selected(hour_selected == hour_day(i));
    amount_selected_hour      = amount(hour_selected == hour_day(i));
    
    
    % CHANGE OF TIME DEPENDING ON THE HOUR OF THE DAY
    
    %   The time that we have is withous the inffluence of traffic, thus we
    %   must include that influence using the data from Tomtom:
    commutes_hour.drive.total_time   = commutes.trip.drive(:,1)*(1+DataCongestion(hour_day(i)));
    commutes_hour.flight_car.total_time = commutes.trip.flight_car_trip(:,1)*...
        (1+DataCongestion(hour_day(i)))+...
        sum(commutes.trip.flight_car_trip(:,2:6),2)+...
        commutes.trip.flight_car_trip(:,7)*...
        (1+DataCongestion(hour_day(i)));     % min
    
    
    [commutes_hour.flight_car.data{i,1}] = func_times(hour_day(i),commutes,DataCongestion,flight,'flight_car');
    [commutes_hour.flight_transit.data{i,1}] = func_times(hour_day(i),commutes,DataCongestion,flight,'flight_transit');
    [commutes_hour.drive.data{i,1}] = func_times(hour_day(i),commutes,DataCongestion,flight,'drive');
    [commutes_hour.transit.data{i,1}] = func_times(hour_day(i),commutes,DataCongestion,flight,'transit');
    
    %  EFFECTIVE COST
    
    %   We must select first the number of trips that we want to calculate
    
    n = length(commutes.trip.distance);
    % k = int32(amount(hour_selected == hour_day));
    rows = randsample(n,floor(amount_selected_hour));
    
    %   For the effective cost we need the value of time and this is going to
    %   be related to the hour income
    cost.drive   = 0.53; % $/mile (Apoorv data)
    cost.transit = 2.5; % $
    
    %   Cost uber:
    
    % initial_cost    = [2.97 2.09 ]; % $/mile
    % short_term_cost = [0.98 0.69 ]; % $/mile
    % long_term_cost  = [0.47 0.33 ];  % $/mile
    
    cost.initial    = 5.73; % $/pax-mile
    cost.short = 1.86; % $/pax-mile
    cost.long  = 0.44;  % $/pax-mile
    
    [effective_cost(i),indx(i)] = effective_cost_func(commutes,flight,cost,rows,commutes_hour);
    
end
effective_cost = struct2table(effective_cost);
indx = struct2table(indx);
save('Results/Density/Results_Density_Distribution','effective_cost','indx')

