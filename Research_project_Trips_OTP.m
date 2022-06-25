clear all; clc; close all;

wgs84 = wgs84Ellipsoid('kilometer');


%%  ORIGIN AND DESTINATION FLIGHT PATH
dest_idx          = size(commutes.trip,1);
[flight,commutes] = func_flight_information(commutes,community_area,dest_idx);

%%  OTP
%   CONFIGURATION
%   The configuration introduced to the OTP program can be set here
arrival_time     = '9:00';                              % Time of arrival
date             = datetime('now');
date             = datestr(date+days(2),'mm-dd-yyyy');  % Date
%   The OTP API sometimes fails when the origin or destination coordinates
%   are not useful to determine a trip. As a consequence, we must determine
%   circles with different radius to find a new valid position. We can now
%   define the increment of that radius and angle, as well as the limit of
%   radius that we are going to try. If the algorithm reaches the
%   threshold, it will establish that commute as Nan
radius_0         = 100; % Initial radius for the search
radius_increment = 50;  % Increment of the radius after one circle is done
radius_limit     = 800; % Maximum radius
alpha_increment  = 30;  % Increment of the angle on each iteration
%   If we want to compute just some specific trips we can set the starting
%   commute and the last commute index:
start = 1;
ending = length(flight.destination_x);

%%   OTP FUNCTIONS
version = 1;
%   NO FLIGHT (CAR/TRANSIT)
%   The function 'func_no_flight' is used when the air taxi is not used:
%   Car:
mode = 'CAR'; % Mode
[results_noflight_drive] = func_no_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_drive'],'results_noflight_drive')
%   Transit or walk:
mode = 'TRANSIT,WALK'; % Mode
[results_noflight_transit] = func_no_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_transit'],'results_noflight_transit')

%   FLIGHT
%   The function 'flight_fun' is implemented when the air taxi is used:
%   Car:
mode = 'CAR';
[results_flight_car] = func_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_flight_car'],'results_flight_car')
%   Transit or walk
mode = 'TRANSIT,WALK';
[results_flight_transit] = func_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_flight_transit'],'results_flight_transit')

%%  RESULTS
%   In case there are Nan, we have to locate them to remove those rows
if ~isempty(results_noflight_drive)
    pos_nonans.noflight_drive = find(~isnan(results_noflight_drive.time_maps));
    pos_ans.noflight_drive    = find(isnan(results_noflight_drive.time_maps));
end
if ~isempty(results_noflight_transit)
    pos_nonans.noflight_transit = find(~isnan(results_noflight_transit.time_maps));
    pos_ans.noflight_transit    = find(isnan(results_noflight_transit.time_maps));
end
if ~isempty(results_flight_drive)
    pos_nonans.flight_drive = find(~isnan(results_flight_drive.time_total));
    pos_ans.flight_drive    = find(isnan(results_flight_drive.time_total));
end
if ~isempty(results_flight_transit)
    pos_nonans.flight_transit = find(~isnan(results_flight_drive.time_total));
    pos_ans.flight_transit    = find(isnan(results_flight_drive.time_total));
end

%   Now we must put all of the indexes for the nans together and remove the
%   repeated ones:
pos_noans.all = unique([pos_nonans.noflight_drive pos_nonans.noflight_transit...
                pos_nonans.flight_drive pos_nonans.flight_transit]);
pos_ans.all   = unique([pos_ans.noflight_drive pos_ans.noflight_transit...
                pos_ans.flight_drive pos_ans.flight_transit]);

%   The next step will consists of removing the data that is Nan and saving
%   the data in the commutes matrix 
if ~isempty(results_noflight_drive)
    results_noflight_drive = results_noflight_drive(pos_noans.all,:);
    time_total_drive       = results_noflight_drive.time_maps/60;
    time_drive             = [60-time_total_drive, time_total_drive];
    distance_total_drive   = results_noflight_drive.distance_maps;
    save(['Results/OTP/Version', num2str(version),'/result_drive'],...
        'results_noflight_drive','time_total_drive','time_drive',...
        'distance_total_drive','posnonans','posans')
    %   Now we save the results in the commutes matrix
    commutes.trip.drive(:,1) = time_total_drive;
    commutes.trip.drive(:,2) = distance_total_drive;
end
if ~isempty(results_noflight_transit)
    results_noflight_transit = results_noflight_transit(pos_noans.all,:);
    time_total_transit       = results_noflight_transit.time_maps/60;
    time_transit             = [60-time_total_transit,time_total_transit];
    save(['Results/OTP/Version', num2str(version),'/result_transit'],...
        'results_noflight_transit','time_total_transit','time_transit',...
        'posnonans','posans')
    %   Now we save the results in the commutes matrix
    commutes.trip.transit = time_total_transit;
end
if ~isempty(results_flight_drive)
    results_flight_drive = results_flight_drive(pos_noans.all,:);
    time_fly_drive = [60-results_flight_drive.time_total,...
        results_flight_drive.time_maps_orig/60,...
        repmat(flight.time2wait,length(results_flight_drive.time_maps_orig),1),...
        repmat(flight.time2warmup,length(results_flight_drive.time_maps_orig),1),...
        repmat(flight.time2board,length(results_flight_drive.time_maps_orig),1),...
        flight.path_time,...
        repmat(flight.time2deboard,length(results_flight_drive.time_maps_orig),1),...
        results_flight_drive.time_maps_dest/60,zeros(length(results_flight_drive.time_maps_orig),1),...
        zeros(length(results_flight_drive.time_maps_orig),1)];
    distance_total_drive = results_flight_drive.distance_maps;
    distance_orig_drive  = results_flight_drive.distance_maps_orig;
    distance_dest_drive  = results_flight_drive.distance_maps_dest;
    save(['Results/OTP/Version', num2str(version),'/result_fligh_car'],...
        'results_flight_drive','time_fly_drive','distance_total_drive',...
        'distance_orig_drive','distance_dest_drive','posnonans','posans')
    %   Now we save the results in the commutes matrix
    commutes.trip.flight_car_trip = [ time_fly_drive(:,2:end-2)...
                                    results_flight_drive.time_total(:,1)...
                                    results_flight_drive.distance_maps_orig...
                                    results_flight_drive.path_distance...
                                    results_flight_drive.distance_maps_dest];
end
if ~isempty(results_flight_transit)
    results_flight_transit = results_flight_transit(pos_noans.all,:);
    %   Now we can create some matrices with the results with all the times in
    %   order
    time_fly_transit = [60-results_flight_transit.time_total,...
        results_flight_transit.time_maps_orig/60,...
        repmat(flight.time2wait,length(results_flight_transit.time_maps_orig),1),...
        repmat(flight.time2warmup,length(results_flight_transit.time_maps_orig),1),...
        repmat(flight.time2board,length(results_flight_transit.time_maps_orig),1),...
        flight.path_time,...
        repmat(flight.time2deboard,length(results_flight_transit.time_maps_orig),1),...
        results_flight_transit.time_maps_dest/60,zeros(length(results_flight_transit.time_maps_orig),1),...
        zeros(length(results_flight_transit.time_maps_orig),1)];
    save(['Results/OTP/Version', num2str(version),'/result_fligh_transit'],...
        'time_fly_transit','posnonans','posans')
    %   Now we save the results in the commutes matrix
    commutes.trip.flight_transit_trip = [ time_fly_transit(:,2:end-2)...
                                    results_flight_transit.time_total(:,1)...
                                    results_flight_drive.path_distance];
end

save(['Results/OTP/Version', num2str(version),'/Results_Commutes_Maps'],...
        'commutes')

