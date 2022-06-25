function [distance,time] = func_mission_profile_components(altitude,speed)
%[distance,time] = mission_profile_components(altitude,speed)
%   This function uses the velocity vector and the altitude data to compute
%   the distance vector and the final time.

%   Speed components:
vx = speed(1);
vy = speed(2);

%   Speed module and angle
v     = sqrt(vx^2+vy^2);
alpha = atand(vy/vx);

%   Distance components
dy = altitude*vy/abs(vy);
dx = dy/tand(alpha);

%   Distance module
d = sqrt(dx^2+dy^2);

%   Distance vector
distance = [dx;dy];

%   Time
time = d/v;






end

