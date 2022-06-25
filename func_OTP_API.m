function [value] = func_OTP_API(orig_coord,dest_coord,mode,arrival_time,date)
%[value] = google_maps(orig_coord,dest_coord,mode,arrival_time)
%   This function calculates the time from two points using Google Maps API
%   INPUT:
%      *orig_coord: % Main matrix with most of the information
%   OUTPUT:
%      *dest_coord: % Main matrix with most of the information and
%                         now with the information of the UAMstops
%      *modes:      % Walking, transit, driving, bicycling
%      *arrival_time: % Time of arrival

%   Then it creates an URL depending on the kind of mode
url = ['http://localhost:8080/otp/routers/default/plan?fromPlace=',...
    orig_coord,'&toPlace=',dest_coord,...
    '&time=',arrival_time,'&date=',date,'&mode=',mode,'&arriveBy=true'];


str = urlread(url);
%   The json format is turned into structure
value = jsondecode(str);
end

