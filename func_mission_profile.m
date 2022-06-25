function [total_time,total_distance_air,distance_vector,distance_ground_segments] = func_mission_profile(i,j,area,total_distance_ground,total_distance_ground_straight,mesh,community_area,cells)
%function [total_time] = mission_profile(origin,destination)
%   This function calculates the total time having into consideration the
%   origin and destination of the trip and the mission profile set by Uber
%   for an eVTOL. We will use here the segments: B, C, E, F, G, I and J of the
%   mission requirements.

wgs84 = wgs84Ellipsoid('meter');

%%  DATA
total_distance_ground = total_distance_ground*10^3;
total_distance_ground_straight = total_distance_ground_straight*10^3;


UAMstops_lat = [community_area(:).UAMstops_lat];
UAMstops_lon = [community_area(:).UAMstops_lon];

origin      = [UAMstops_lat(i);UAMstops_lon(i)];
destination = [UAMstops_lat(j);UAMstops_lon(j)];
%%  CONVERSIONS
ft2m     = 0.3048;
ftmin2ms = 0.3048/60;
mph2ms   = 1609.34/3600;

%%   AIRCRAFT INFORMATION
Vstall   = 135; % km/h
Vstall   = Vstall/3.6;

%%  DEPARTURE

if inpolygon(origin(1),origin(2),area.downtown(:,1),area.downtown(:,2))
    vx_b = 0;
    vy_b = 500*ftmin2ms;
    vx_c = 0;     % m/s
    vy_c = 500*ftmin2ms;     % m/s
    vx_e = 1.2*Vstall;
    vy_e = 500*ftmin2ms;
    
    %   SEGMENT D
    distance_D = [0;0];
    time_D     = 0;
elseif inpolygon(origin(1),origin(2),area.airport1(:,1),area.airport1(:,2)) ...
        || inpolygon(origin(1),origin(2),area.airport2(:,1),area.airport2(:,2))
    vx_b = 0;
    vy_b = 500*ftmin2ms; % m/s
    vx_c = 1.2*Vstall;   % m/s
    vy_c = 500*ftmin2ms; % m/s
    vx_d = 1.2*Vstall;   % m/s
    vy_d = 0;            % m/s
    vx_e = 150*mph2ms;   % m/s
    vy_e = 500*ftmin2ms; % m/s
    
    %   SEGMENT D
    distance_D = [4000;0];            % m
    speed_D    = sqrt(vx_d^2+vy_d^2); % m/s
    time_D     = norm(distance_D)/speed_D;  % s
    
else
    vx_b = 0;                         % m/s
    vy_b = 500*ftmin2ms;              % m/s
    vx_c = 1.2*Vstall/2;                % m/s
    vy_c = 500*ftmin2ms;              % m/s
    vx_e = (150*mph2ms+1.2*Vstall)/2; % m/s
    vy_e = 500*ftmin2ms;              % m/s
     
    %   SEGMENT D
    distance_D = [0;0];
    time_D     = 0;
end

%   SEGMENT B
altitude = 50;               % ft
altitude = altitude*ft2m;    % m
speed    = [vx_b;vy_b];      % m/s
[distance_B,time_B] = func_mission_profile_components(altitude,speed);

%   SEGMENT C
altitude = 250;              % ft
altitude = altitude*ft2m;    % m
speed    = [vx_c;vy_c];      % m/s
[distance_C,time_C] = func_mission_profile_components(altitude,speed);

%   SEGMENT E
altitude = 1200;             % ft
altitude = altitude*ft2m;    % m
speed    = [vx_e;vy_e];      % m/s
[distance_E,time_E] = func_mission_profile_components(altitude,speed);

%%  APPROACH

if inpolygon(destination(1),destination(2),area.downtown(:,1),area.downtown(:,2))
    vx_j = 0;                         % m/s
    vy_j = -300*ftmin2ms;             % m/s
    vx_i = 0;                         % m/s
    vy_i = -500*ftmin2ms;             % m/s
    vx_g = 1.2*Vstall; % m/s
    vy_g = -500*ftmin2ms;             % m/s
     
    %   SEGMENT H
    distance_H = [0;0]; % m
    time_H     = 0;     % s
elseif inpolygon(destination(1),destination(2),area.airport1(:,1),area.airport1(:,2)) ...
        || inpolygon(destination(1),destination(2),area.airport2(:,1),area.airport2(:,2))
    vx_j = 0;             % m/s
    vy_j = -300*ftmin2ms; % m/s
    vx_i = 1.2*Vstall;    % m/s
    vy_i = -300*ftmin2ms; % m/s
    vx_h = 1.2*Vstall;    % m/s
    vy_h = 0;             % m/s
    vx_g = 150*mph2ms;    % m/s
    vy_g = -500*ftmin2ms; % m/s
    
    %   SEGMENT H
    distance_H = [4000;0];            % m
    speed_H    = sqrt(vx_h^2+vy_h^2); % m/s
    time_H     = norm(distance_H)/speed_H;  % s
    
else
    vx_j = 0;                         % m/s
    vy_j = -300*ftmin2ms;             % m/s
    vx_i = 1.2*Vstall/2;                % m/s
    vy_i = -(500+300)*ftmin2ms/2;             % m/s
    vx_g = (150*mph2ms+1.2*Vstall)/2; % m/s
    vy_g = -500*ftmin2ms;             % m/s
    
    %   SEGMENT H
    distance_H = [0;0];
    time_H     = 0;
end


%   SEGMENT G
altitude = 1200;          % ft
altitude = altitude*ft2m; % m
speed    = [vx_g;vy_g];   % m/s
[distance_G,time_G] = func_mission_profile_components(altitude,speed);

%   SEGMENT I
altitude = 250;           % ft
altitude = altitude*ft2m; % m
speed    = [vx_i;vy_i];   % m/s
[distance_I,time_I] = func_mission_profile_components(altitude,speed);

%   SEGMENT J
altitude = 50;            % ft
altitude = altitude*ft2m; % m
speed    = [vx_j;vy_j];   % m/s
[distance_J,time_J] = func_mission_profile_components(altitude,speed);

%%  CRUISE

%   SEGMENT F
approach_departure_distance = distance_B+distance_C+distance_D+...
    distance_E+distance_G+distance_H+distance_I+distance_J;

if total_distance_ground(1) < approach_departure_distance(1)
    %   Phase 1: B,C,D,H,I,J
    phase1 = approach_departure_distance(1)-distance_E(1)-distance_G(1);
    %   Phase 1: E,G
    phase2 = total_distance_ground(1)-phase1;
    if phase2>0 % This means that we dont have to change phase1
        %   However, we need to recalculate the profile of segments E and G
        %   knowing that they have to cover the distance represented by
        %   phase2
        
        angle_E = atan2(distance_E(2),distance_E(1));
        angle_G = atan2(-distance_G(2),distance_G(1));
        
        distance_E_y = tan(angle_G)*tan(angle_E)*phase2/(tan(angle_E)+tan(angle_G));
        distance_G_y = -distance_E_y;
        distance_E_x = distance_E_y/tan(angle_E);
        distance_G_x = phase2-distance_E_x;
        
        distance_E = [distance_E_x;distance_E_y];
        distance_G = [distance_G_x;distance_G_y];
        distance_F = [0;0];
        
        time_E = norm(distance_E)/norm([vx_e;vy_e]);
        time_G = norm(distance_G)/norm([vx_g;vy_g]);
        time_F = 0;
    else % Phase must be recalculated
        %   Phase 1: B,C,I,J
        phase1 = approach_departure_distance(1)-distance_D(1)-distance_H(1)-distance_E(1)-distance_G(1);
        %   Phase 2: E,G,H,D
        phase2 = total_distance_ground(1)-phase1;
        if phase2>0 %   This means that we can do a straight line
            
            distance_D_x = phase2/2;
            distance_H_x = phase2/2;
            distance_D_y = 0;
            distance_H_y = 0;
            
            distance_H = [distance_H_x;distance_H_y];
            distance_D = [distance_D_x;distance_D_y];
            distance_E = [0;0];
            distance_G = [0;0];
            distance_F = [0;0];
            
            vx_h = 1.2*Vstall;
            vx_d = 1.2*Vstall;

            time_H = distance_H_x/vx_h;
            time_D = distance_D_x/vx_d;
            time_E = 0;
            time_G = 0;
            time_F = 0;
        else
            %   Phase 1: B,C,I,J
        phase1 = approach_departure_distance(1)-distance_C(1)-distance_I(1)-distance_D(1)-distance_H(1)-distance_E(1)-distance_G(1);
        %   Phase 2: E,G,H,D
        phase2 = total_distance_ground(1)-phase1;
            
            angle_C = atan2(distance_C(2),distance_C(1));
            angle_I = atan2(-distance_I(2),distance_I(1));
            
            distance_C_y = tan(angle_I)*tan(angle_C)*phase2/(tan(angle_C)+tan(angle_I));
            distance_I_y = -distance_C_y;
            distance_C_x = distance_C_y/tan(angle_C);
            distance_I_x = phase2-distance_C_x;
            
            distance_C = [distance_C_x;distance_C_y];
            distance_I = [distance_I_x;distance_I_y];
            distance_H = [0;0];
            distance_D = [0;0];
            distance_E = [0;0];
            distance_G = [0;0];
            distance_F = [0;0];
            
            time_C = norm(distance_C)/norm([vx_c;vy_c]);
            time_I = norm(distance_I)/norm([vx_i;vy_i]);
            time_H = 0;
            time_D = 0;
            time_E = 0;
            time_G = 0;
            time_F = 0;
            
            
            
            
        end
    end
    
else
    distance_F = [total_distance_ground ;0]-approach_departure_distance;
    vx       = 150*mph2ms;             % m/s
    vy       = 0;                      % m/s
    speed    = [vx;vy];                % m/s
    time_F   = norm(distance_F)/norm(speed); % s
%     distance_F = [total_distance_ground_straight ;0]-approach_departure_distance;
end
%%   TOTAL TIME
total_time = time_B+time_C+time_D+time_E+time_G+time_H+time_I+time_J+time_F;

%%   DISTANCE
beta = azimuth(origin(1),origin(2),destination(1),destination(2),wgs84);
vector = [distance_B distance_C distance_D...
    distance_E distance_F distance_G distance_H distance_I distance_J];

[distance_vector] = func_profile(i,j,vector,mesh,community_area,cells);

distance_ground_segments = [total_distance_ground/1000 vector(1,:)/1000];

total_distance_air    = sum(vecnorm(vector))/1000;

end

