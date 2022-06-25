function [probability] = func_probability_read(filename)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

trips_to_work_hour = xlsread(filename,'p.14-15 Trips by time of day','B5:B292');
hours              = xlsread(filename,'p.14-15 Trips by time of day','A5:A292');
hours = days(hours);
hours.Format = 'hh:mm';
hours2 = hours + days(0.5/24);

%% PROBABILITY

maximum = 60;
minimum = 5;
step = 5;
w = minimum:step:maximum; % min
w = w/60; % hours
% w = 1440/60;
hour_temp = 1;
m = sum(trips_to_work_hour);
for i = 1:length(w)
    %     m = 24/w(i);
    for j = 1:24/w(i)
        loc = find(days(hour_temp(j)/24)<=days(hours2)& days(hours2)<days(hour_temp(j)/24+w(i)/24));
        motion_temp(j) = sum(trips_to_work_hour(loc));
        hour_temp(j+1) = hour_temp(j) + w(i);
    end
    hour(i) = {hour_temp(1:end-1)};
    probability_value(i) = {motion_temp/sum(motion_temp)*100};
    motion(i) = {motion_temp};
    hour_temp = 1;
    motion_temp = [];
%     J(i) = 2/((m-1)*w(i)/24)-(m+1)/((m-1)*w(i)/24)*(sum((probability{i}/100).^2));
end

probability.value  = probability_value;
probability.hour   = hour;
probability.motion = motion;


end

