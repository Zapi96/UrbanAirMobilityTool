function [results] = func_no_flight_trip(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment)
%[results] = no_flight_func(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,alpha_increment)
%   This function calculates the time of a trip having into consideration
%   the required time of arrival and the coordinates
%   INPUT:
%      *start:            % Initial number of trip
%      *ending:           % Final number of trip
%      *arrival_time:     % Arrival time
%      *date:             % Date of the trip
%      *flight:           % Matrix with information about the origin and
%                           destintion
%      *mode:             % Chose mode for the trip: car, transit
%      *radius_0:         % Initial radius when the coordinate is not found
%      *radius_increment: % Increment to the initial radius when the
%                           coordinate is not found
%      *radius_limit:     % Maximum radius reached when finding new
%                           coordinates
%      *alpha_increment:  % Increment to the angle
%   OUTPUT:
%      *results:          % Final values of the times

%%  INITIAL DATA
%   Ellipsoid used for the function geodetic2ecef and ecef2geodetic
wgs84 = wgs84Ellipsoid('kilometer');
t = 0;
n_nan = 0;
for i = start:ending
    tic;
    disp([mode,': ',num2str(i)]);
    disp(['N nan:',num2str(n_nan)])
        disp(t)

    %   DESTINATION SEGMENT
    %   Coordinates of the destination segment are set:
    orig_coord = [num2str(flight.origin_lat(i),'%4.20f'),',',num2str(flight.origin_lon(i),'%4.20f')];
    dest_coord = [num2str(flight.destination_lat(i),'%4.20f'),',',num2str(flight.destination_lon(i),'%4.20f')];
    %   The function that uses the OTP API is called:
    [value] = func_OTP_API(orig_coord,dest_coord,mode,arrival_time,date);
    %   Temporal variables of the coordinates are created in case they must
    %   by changed if a trip cannot be computed
    temp_flight.origin_lat = flight.origin_lat(i);
    temp_flight.origin_lon = flight.origin_lon(i);
    temp_flight.destination_lat = flight.destination_lat(i);
    temp_flight.destination_lon = flight.destination_lon(i);
    %   Initialization of the angle and radius for the espiral search of
    %   the new coordinates in case that the initial ones does not work
    alpha  = 0; % Degrees
    radius = radius_0*10^-3; % 10 m
    %   As long as the field plan does not exist, it means that the initial
    %   coordinates are not useful. so an iterative process must be applied
    %   to find the new ones using a spiral search
    while ~ isfield(value,'plan')
        %   First the coordinates are turned into ECEF system to increase
        %   these values with a radius and an angle
        %   Origin:
        [temp_flight.origin_lat,temp_flight.origin_lon] = reckon(flight.origin_lat(i),flight.origin_lon(i),radius,alpha,wgs84);
        %   Destination:
        [temp_flight.destination_lat,temp_flight.destination_lon] = reckon(flight.destination_lat(i),flight.destination_lon(i),radius,alpha,wgs84);
        %   The new coordinates of the destination segment are set:
        orig_coord = [num2str(temp_flight.origin_lat,'%4.20f'),',',num2str(temp_flight.origin_lon,'%4.20f')];
        dest_coord = [num2str(temp_flight.destination_lat,'%4.20f'),',',num2str(temp_flight.destination_lon,'%4.20f')];
        %   The function that uses the OTP API is called:
        [value] = func_OTP_API(orig_coord,dest_coord,mode,arrival_time,date);
        %   The values of the angle and the radius are increased to find a
        %   new position in case the last coordinates does not work
        alpha = alpha + alpha_increment; % The angle is increased
        radius = radius +radius_increment*10^-3 ;
        %   If it reaches 360 degrees, we must reset the angle
        if alpha >=360
            alpha  = 0;
        end
        %   If the radius reaches the introduced limit, this iterative
        %   process is stoped
        if radius>radius_limit*10^-3
            break;
        end
    end
    %   If a new pair of valid coordinates has been found, the initial
    %   coordinates are updated to be used for following calculations.
    flight.origin_lat(i) = temp_flight.origin_lat;
    flight.origin_lon(i) = temp_flight.origin_lon;
    flight.destination_lat(i) = temp_flight.destination_lat;
    flight.destination_lon(i) = temp_flight.destination_lon;
    %   When the iterative process is stopped without finding a valid
    %   coordinate set, this trip is removed for all the modes setting its
    %   value as Nan
    if ~ isfield(value,'plan')
%         geoplot(flight.origin_lat(i),flight.origin_lon(i),'*k')
        hold on
%         geoplot(flight.destination_lat(i),flight.destination_lon(i),'*k')
        results.time_maps(i,1) = nan;
        results.distance_maps(i,1) = nan;
        results.time_total_fly(i,1)    = nan;
        results.time_maps_drive(i,1)   = nan;
        results.time_maps_transit(i,1) = nan;
        results.time_maps_dest(i,1)    = nan;
        results.time_maps_orig(i,1)    = nan;
        n_nan = n_nan+1;
        continue; % This makes the iterative process to continue without making the following calculations
    end
    %   There are some situations in which the result provided vi the OTP
    %   function is in a cell format, so it must be converted to a valid
    %   format
    if iscell(value.plan.itineraries)
        for j = 1:length(value.plan.itineraries)
            duration(j,:) = value.plan.itineraries{j,1}.duration;
            if strcmpi(mode,'CAR')
                distance(j,:) = value.plan.itineraries{j,1}.legs.distance;
            end
        end
        value.plan.itineraries = [];
        value.plan.itineraries.duration = duration;
        if strcmpi(mode,'CAR')
            value.plan.itineraries.legs.distance = distance;
        end
    end
    
    
    %   The duration of the trip is selected by chosing the minimum value
    %   of the different options provided
    results.time_maps(i,1) = min([value.plan.itineraries(:).duration]); % sec
    loc = find(min([value.plan.itineraries(:).duration])==[value.plan.itineraries(:).duration]);
    if strcmpi(mode,'CAR')
        results.distance_maps(i,1) = value.plan.itineraries.legs.distance(loc)/10^3;
    else
        results.distance_maps(i,1) = 0;
    end
    t = toc;
    clc;
    %  The results are saved in case something fails
    if rem(i,100000)==0
        save(['Results/OTP/Backups/results_noflight_',mode],'results')
    end
    close all
end

