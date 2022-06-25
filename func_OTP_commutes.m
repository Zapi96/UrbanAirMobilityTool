function [commutes,flight] = func_OTP_commutes(flight,commutes,data)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%%  OTP
%   CONFIGURATION
%   The configuration introduced to the OTP program can be set here
arrival_time = data.arrival_time ;
date         = datetime(2020,05,7);
date         = datestr(date,'mm-dd-yyyy');  % Date 
%   The OTP API sometimes fails when the origin or destination coordinates
%   are not useful to determine a trip. As a consequence, we must determine
%   circles with different radius to find a new valid position. We can now
%   define the increment of that radius and angle, as well as the limit of
%   radius that we are going to try. If the algorithm reaches the
%   threshold, it will establish that commute as Nan
radius_0         = data.radius_0; % Initial radius for the search
radius_increment = data.radius_increment;  % Increment of the radius after one circle is done
radius_limit     = data.radius_limit; % Maximum radius
alpha_increment  = data.alpha_increment;  % Increment of the angle on each iteration
%   If we want to compute just some specific trips we can set the starting
%   commute and the last commute index:
start = data.start;
ending = length(flight.destination_x);

%%   OTP FUNCTIONS
version = data.version;
%   NO FLIGHT (CAR/TRANSIT)
%   The function 'func_no_flight' is used when the air taxi is not used:
%   Car:
% mode = 'CAR'; % Mode
% [results_noflight_drive] = func_no_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
% save(['Results/OTP/Version', num2str(version),'/result_drive'],'results_noflight_drive')
%   Transit or walk:
% mode = 'TRANSIT,WALK'; % Mode
% [results_noflight_transit] = func_no_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
% save(['Results/OTP/Version', num2str(version),'/result_transit'],'results_noflight_transit')

%   FLIGHT
%   The function 'flight_fun' is implemented when the air taxi is used:
%   Car:
mode = 'CAR';
[results_flight_car] = func_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_flight_car'],'results_flight_car')
% %   Transit or walk
mode = 'TRANSIT,WALK';
[results_flight_transit] = func_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment);
save(['Results/OTP/Version', num2str(version),'/result_flight_transit'],'results_flight_transit')

%%  RESULTS

load(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\OTP\Version',num2str(version),'\result_drive.mat'])
load(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\OTP\Version',num2str(version),'\result_flight_car.mat'])
load(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\OTP\Version',num2str(version),'\result_flight_transit.mat'])
load(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\OTP\Version',num2str(version),'\result_transit.mat'])

%   In case there are Nan, we have to locate them to remove those rows
if ~isempty(results_noflight_drive)
    pos_nonans.noflight_drive = find(~isnan(results_noflight_drive.time_maps));
    pos_ans.noflight_drive    = find(isnan(results_noflight_drive.time_maps));
end
if ~isempty(results_noflight_transit)
    pos_nonans.noflight_transit = find(~isnan(results_noflight_transit.time_maps));
    pos_ans.noflight_transit    = find(isnan(results_noflight_transit.time_maps));
end
if ~isempty(results_flight_car)
    pos_nonans.flight_drive = find(~isnan(results_flight_car.time_total));
    pos_ans.flight_drive    = find(isnan(results_flight_car.time_total));
end
if ~isempty(results_flight_transit)
    pos_nonans.flight_transit = find(~isnan(results_flight_transit.time_total));
    pos_ans.flight_transit    = find(isnan(results_flight_transit.time_total));
end

%   Now we must put all of the indexes for the nans together and remove the
%   repeated ones:
pos_ans.all   = unique([pos_ans.noflight_drive; pos_ans.noflight_transit;...
                pos_ans.flight_drive; pos_ans.flight_transit]);

pos_nonans.all = [1:size(commutes.trip,1)]';
pos_nonans.all(pos_ans.all) = [];

flight = flight(pos_nonans.all,:);
commutes.trip = commutes.trip(pos_nonans.all,:);
            
%   The next step will consists of removing the data that is Nan and saving
%   the data in the commutes matrix 
if ~isempty(results_noflight_drive)
    results_noflight_drive.time_maps = results_noflight_drive.time_maps(pos_nonans.all,:);
    results_noflight_drive.distance_maps = results_noflight_drive.distance_maps(pos_nonans.all,:);
    time_total_drive       = results_noflight_drive.time_maps/60;
    time_drive             = [60-time_total_drive, time_total_drive];
    distance_total_drive   = results_noflight_drive.distance_maps;
%     save(['Results/OTP/Version/OTP_nonans', num2str(version),'/result_drive'],...
%         'results_noflight_drive','time_total_drive','time_drive',...
%         'distance_total_drive','pos_nonans','pos_ans')
    %   Now we save the results in the commutes matrix
    commutes.trip.drive(:,1) = time_total_drive;
    commutes.trip.drive(:,2) = distance_total_drive;
end
if ~isempty(results_noflight_transit)
    results_noflight_transit.time_maps = results_noflight_transit.time_maps(pos_nonans.all,:);
    results_noflight_transit.distance_maps = results_noflight_transit.distance_maps(pos_nonans.all,:);
    time_total_transit       = results_noflight_transit.time_maps/60;
    time_transit             = [60-time_total_transit,time_total_transit];
%     save(['Results/OTP/Version/OTP_nonans', num2str(version),'/result_transit'],...
%         'results_noflight_transit','time_total_transit','time_transit',...
%         'pos_nonans','pos_ans')
    %   Now we save the results in the commutes matrix
    commutes.trip.transit = time_total_transit;
end
if ~isempty(results_flight_car)
    results_flight_car.time_maps_dest     = results_flight_car.time_maps_dest(pos_nonans.all,:);
    results_flight_car.distance_maps_dest = results_flight_car.distance_maps_dest(pos_nonans.all,:);
    results_flight_car.time_maps_orig     = results_flight_car.time_maps_orig(pos_nonans.all,:);
    results_flight_car.distance_maps_orig = results_flight_car.distance_maps_orig(pos_nonans.all,:);
    results_flight_car.time_total         = results_flight_car.time_total(pos_nonans.all,:);
    results_flight_car.distance_total     = results_flight_car.distance_total(pos_nonans.all,:);    
    
    time_fly_drive = [60-results_flight_car.time_total,...
        results_flight_car.time_maps_orig/60,...
        flight.time2wait,...
        flight.time2warmup,...
        flight.time2board,...
        flight.path_time,...
        flight.time2deboard,...
        results_flight_car.time_maps_dest/60,zeros(length(results_flight_car.time_maps_orig),1),...
        zeros(length(results_flight_car.time_maps_orig),1)];
    distance_total_drive = results_flight_car.distance_total;
    distance_orig_drive  = results_flight_car.distance_maps_orig;
    distance_dest_drive  = results_flight_car.distance_maps_dest;
%     save(['Results/OTP/Version/OTP_nonans', num2str(version),'/result_fligh_car'],...
%         'results_flight_car','time_fly_drive','distance_total_drive',...
%         'distance_orig_drive','distance_dest_drive','pos_nonans','pos_ans')
    %   Now we save the results in the commutes matrix
    commutes.trip.flight_car_trip = [ time_fly_drive(:,2:end-2)...
                                    results_flight_car.time_total(:,1)...
                                    results_flight_car.distance_maps_orig...
                                    flight.path_distance...
                                    results_flight_car.distance_maps_dest];
end
if ~isempty(results_flight_transit)
    results_flight_transit.time_maps_dest     = results_flight_transit.time_maps_dest(pos_nonans.all,:);
    results_flight_transit.distance_maps_dest = results_flight_transit.distance_maps_dest(pos_nonans.all,:);
    results_flight_transit.time_maps_orig     = results_flight_transit.time_maps_orig(pos_nonans.all,:);
    results_flight_transit.distance_maps_orig = results_flight_transit.distance_maps_orig(pos_nonans.all,:);
    results_flight_transit.time_total         = results_flight_transit.time_total(pos_nonans.all,:);
    results_flight_transit.distance_total     = results_flight_transit.distance_total(pos_nonans.all,:);    
    %   Now we can create some matrices with the results with all the times in
    %   order
    time_fly_transit = [60-results_flight_transit.time_total,...
        results_flight_transit.time_maps_orig/60,...
        flight.time2wait,...
        flight.time2warmup,...
        flight.time2board,...
        flight.path_time,...
        flight.time2deboard,...
        results_flight_transit.time_maps_dest/60,zeros(length(results_flight_transit.time_maps_orig),1),...
        zeros(length(results_flight_transit.time_maps_orig),1)];
%     save(['Results/OTP/Version/OTP_nonans', num2str(version),'/result_fligh_transit'],...
%         'time_fly_transit','pos_nonans','pos_ans')
    %   Now we save the results in the commutes matrix
    commutes.trip.flight_transit_trip = [ time_fly_transit(:,2:end-2)...
                                    results_flight_transit.time_total(:,1)...
                                    flight.path_distance];
end



end

