function [results] = func_flight_trip(start,ending,arrival_time_initial,date_initial,flight,mode,radius_0,radius_increment,radius_limit,alpha_increment)
%[results] = flight_func(start,ending,arrival_time,date,flight,mode,radius_0,radius_increment,alpha_increment)
%   This function calculates the time of a trip having into consideration
%   the required time of arrival. In order to achieve that, this path is
%   divided into 3 parts. The first part is the one which corresponds to
%   the distance between the UAM stop and the destination. Therefore it
%   computes the distance between this two points using the OTP API and the
%   arrival time. Knowing the time at which the trip must be start, the
%   time of flight is added to know what is the arrival time of the UAM
%   stop of origin. The third part is the path correspondent to the
%   distance between the origin and the UAM stop of origin. Knowing the
%   previously calculated time of arrival, the time between the origin and
%   destination can be computed.
%   INPUT:
%      *start:            % Initial number of trip
%      *ending:           % Final number of trip
%      *arrival_time:     % Arrival time
%      *date:             % Date of the trip
%      *flight:           % Matrix with information about the origin and
%                           destintion
%      *mode:             % Chose mode for the trip: car, drive, transit
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

n_nans = 0;
t =0;
for i = start:ending
    tic;
    %%  TRANSIT + FLIGHT
    disp(['FLIGHT+',mode,': ',num2str(i)]);
    disp(['N nans: ',num2str(n_nans)])
    disp(t)
    %   DESTINATION SEGMENT
    %   Coordinates of the destination segment are set:
    orig_coord_dest = [num2str(flight.destination_UAMstops_lat(i),'%4.20f'),',',num2str(flight.destination_UAMstops_lon(i),'%4.20f')];
    dest_coord_dest = [num2str(flight.destination_lat(i),'%4.20f'),',',num2str(flight.destination_lon(i),'%4.20f')];
    %   The function that uses the OTP API is called:
    [value] = func_OTP_API(orig_coord_dest,dest_coord_dest,mode,arrival_time_initial,date_initial);
    %   Temporal variables of the coordinates are created in case they must
    %   by changed if a trip cannot be computed
    temp_flight.destination_lat            = flight.destination_lat(i);
    temp_flight.destination_lon            = flight.destination_lon(i);
    temp_flight.destination_UAMstops_lat = flight.destination_UAMstops_lat(i);
    temp_flight.destination_UAMstops_lon = flight.destination_UAMstops_lon(i);
    %   Initialization of the angle and radius for the espiral search of
    %   the new coordinates in case that the initial ones does not work
    alpha  = 0; % Degrees
    radius = radius_0*10^-3; % m
    %   As long as the field plan does not exist, it means that the initial
    %   coordinates are not useful. so an iterative process must be applied
    %   to find the new ones using a spiral search
    while ~ isfield(value,'plan')
        %   First the coordinates are turned into ECEF system to increase
        %   these values with a radius and an angle
        %   UAMstops:
%         geoplot(temp_flight.destination_lat,temp_flight.destination_lon,'*k')
%         hold on
%         geoplot(temp_flight.destination_UAMstops_lat,temp_flight.destination_UAMstops_lon,'*k')
        [temp_flight.destination_UAMstops_lat,temp_flight.destination_UAMstops_lon] = reckon(flight.destination_UAMstops_lat(i),flight.destination_UAMstops_lon(i),radius,alpha,wgs84);
        %   Destination:
        [temp_flight.destination_lat,temp_flight.destination_lon] = reckon(flight.destination_lat(i),flight.destination_lon(i),radius,-alpha,wgs84);
        %   The new coordinates of the destination segment are set:
        orig_coord_dest = [num2str(temp_flight.destination_UAMstops_lat,'%4.20f'),',',num2str(temp_flight.destination_UAMstops_lon,'%4.20f')];
        dest_coord_dest = [num2str(temp_flight.destination_lat,'%4.20f'),',',num2str(temp_flight.destination_lon,'%4.20f')];
        %   The function that uses the OTP API is called:
        [value] = func_OTP_API(orig_coord_dest,dest_coord_dest,mode,arrival_time,date_initial);
        %   The values of the angle and the radius are increased to find a
        %   new position in case the last coordinates does not work
        alpha = alpha + alpha_increment;% We must increment the angle in 1 degree
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
    close all;
    %   If a new pair of valid coordinates has been found, the initial
    %   coordinates are updated to be used for following calculations.
    flight.destination_lat(i)            = temp_flight.destination_lat;
    flight.destination_lon(i)            = temp_flight.destination_lon;
    flight.destination_UAMstops_lat(i) = temp_flight.destination_UAMstops_lat;
    flight.destination_UAMstops_lon(i) = temp_flight.destination_UAMstops_lon;
    %   When the iterative process is stopped without finding a valid
    %   coordinate set, this trip is removed for all the modes setting its
    %   value as Nan
    if ~ isfield(value,'plan')
         
        n_nans = n_nans+1;
        results.time_total(i,1)        = nan;
        results.time_maps_drive(i,1)   = nan;
        results.time_maps_transit(i,1) = nan;
        results.time_maps_dest(i,1)    = nan;
        results.time_maps_orig(i,1)    = nan;
        continue;   % This makes the iterative process to continue without making the following calculations
    end
    %   There are some situations in which the result provided by the OTP
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
        value.plan.itineraries.duration      = duration;
        if strcmpi(mode,'CAR')
            value.plan.itineraries.legs.distance = distance;
        end
    end
    
    %   The duration of the trip is selected by chosing the minimum value
    %   of the different options provided
    results.time_maps_dest(i,1) = min([value.plan.itineraries(:).duration]); % sec
    loc = find(min([value.plan.itineraries(:).duration])==[value.plan.itineraries(:).duration]);
%     results.distance_maps_dest(i,1) = value.plan.itineraries.legs.distance(loc)/10^3;
    if strcmpi(mode,'CAR')
        results.distance_maps_dest(i,1) = value.plan.itineraries.legs.distance(loc)/10^3;
    else
        results.distance_maps_dest(i,1) = 0;
    end
    
    %   ORIGIN SEGMENT
    %   Coordinates of the origin segment are set:
    dest_coord_orig = [num2str(flight.origin_UAMstops_lat(i),'%4.20f'),',',num2str(flight.origin_UAMstops_lon(i),'%4.20f')];
    orig_coord_orig = [num2str(flight.origin_lat(i),'%4.20f'),',',num2str(flight.origin_lon(i),'%4.20f')];
    %   It is necessary to know the arrival time to the otigin UAM stop. In
    %   order to achieve it, we must add the flight time to the time
    %   required for the destination segment so that we can know at what
    %   time we must be at the origin UAM stop.
    dt           = datetime([date_initial,' ',arrival_time_initial ],'InputFormat','MM-dd-yyyy HH:mm');
    dt           = dt+seconds(results.time_maps_dest(i)+flight.flight_path_time_total(i)*60);
    arrival_time = datestr(dt,'HH:MM:ss');
    date         = datestr(dt,'mm-dd-yyyy');
    disp(arrival_time)
    disp(date)
    %   The function that uses the OTP API is called:
    [value] = func_OTP_API(orig_coord_orig,dest_coord_orig,mode,arrival_time,date);
    %   Temporal variables of the coordinates are created in case they must
    %   by changed if a trip cannot be computed
    temp_flight.origin_lat       = flight.origin_lat(i);
    temp_flight.origin_lon       = flight.origin_lon(i);
    temp_flight.origin_UAMstops_lat = flight.origin_UAMstops_lat(i);
    temp_flight.origin_UAMstops_lon = flight.origin_UAMstops_lon(i);
    %   Initialization of the angle and radius for the espiral search of
    %   the new coordinates in case that the initial ones does not work
    alpha  = 0;
    radius = radius_0*10^-3; % m
    %   As long as the field plan does not exist, it means that the initial
    %   coordinates are not useful. so an iterative process must be applied
    %   to find the new ones using a spiral search
    while ~ isfield(value,'plan')
        %   First the coordinates are turned into ECEF system to increase
        %   these values with a radius and an angle
        %   UAMstops:
        geoplot(temp_flight.origin_UAMstops_lat,temp_flight.origin_UAMstops_lon,'*k')
        hold on
        geoplot(temp_flight.origin_lat,temp_flight.origin_lon,'*k')
        [temp_flight.origin_UAMstops_lat,temp_flight.origin_UAMstops_lon] = reckon(flight.origin_UAMstops_lat(i),flight.origin_UAMstops_lon(i),radius,alpha,wgs84);
        %   Origin:
        [temp_flight.origin_lat,temp_flight.origin_lon] = reckon(flight.origin_lat(i),flight.origin_lon(i),radius,-alpha,wgs84);
        %   The new coordinates of the destination segment are set:
        dest_coord_orig = [num2str(temp_flight.origin_UAMstops_lat,'%4.20f'),',',num2str(temp_flight.origin_UAMstops_lon,'%4.20f')];
        orig_coord_orig = [num2str(temp_flight.origin_lat,'%4.20f'),',',num2str(temp_flight.origin_lon,'%4.20f')];
        %   The function that uses the OTP API is called:
        [value] = func_OTP_API(orig_coord_orig,dest_coord_orig,mode,arrival_time,date);
        alpha = alpha + alpha_increment;% We must increment the angle in 1 degree
        radius = radius + radius_increment*10^-3 ;
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
    close all
     %   If a new pair of valid coordinates has been found, the initial
    %   coordinates are updated to be used for following calculations.
    flight.origin_lat(i)       = temp_flight.origin_lat;
    flight.origin_lon(i)       = temp_flight.origin_lon;
    flight.origin_UAMstops_lat(i) = temp_flight.origin_UAMstops_lat;
    flight.origin_UAMstops_lon(i) = temp_flight.origin_UAMstops_lon;
    %   When the iterative process is stopped without finding a valid
    %   coordinate set, this trip is removed for all the modes setting its
    %   value as Nan
    if ~ isfield(value,'plan')
        n_nans = n_nans +1 ;
        results.time_total(i,1) = nan;
        results.time_maps_drive(i,1)    = nan;
        results.time_maps_transit(i,1)  = nan;
        results.time_maps_dest(i,1)     = nan;
        results.time_maps_orig(i,1)     = nan;
        continue;
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
    results.time_maps_orig(i,1) = min([value.plan.itineraries(:).duration]); % sec
    loc = find(min([value.plan.itineraries(:).duration])==[value.plan.itineraries(:).duration]);
%     results.distance_maps_orig(i,1) = value.plan.itineraries.legs.distance(loc)/10^3;
    if strcmpi(mode,'CAR')
        results.distance_maps_orig(i,1) = value.plan.itineraries.legs.distance(loc)/10^3;
    else
        results.distance_maps_orig(i,1) = 0;
    end
    t = toc;

    %   The total duration of the trip is computed by adding the duration
    %   of each segment and the same for the total distance
    results.distance_total(i,1) = results.distance_maps_orig(i,1)+results.distance_maps_dest(i,1)+flight.path_distance(i);
    results.time_total(i,1) = (results.time_maps_dest(i,1)+results.time_maps_orig(i,1)+flight.flight_path_time_total(i,1)*60)/60;
    if rem(i,10000)==0
        save(['Results/OTP/results_noflight_',mode],'results')
    end
    clc;
end
end

