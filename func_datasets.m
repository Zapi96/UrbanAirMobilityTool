function [DatasetsUAMstops,DatasetsDrive,DatasetsTransit] = func_datasets(commutes_hour,indx)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% dest_idx = 1:size(commutes.trip,1);
% 
% commutes_initial_car = cellfun(@(x) commutes.trip(x,:),indx.initial_flight_car,'UniformOutput',false);
% commutes_short_car   = cellfun(@(x) commutes.trip(x,:),indx.short_flight_car,'UniformOutput',false);
% commutes_long_car    = cellfun(@(x) commutes.trip(x,:),indx.long_flight_car,'UniformOutput',false);
% 
% commutes_initial_transit = cellfun(@(x) commutes.trip(x,:),indx.initial_flight_transit,'UniformOutput',false);
% commutes_short_transit   = cellfun(@(x) commutes.trip(x,:),indx.short_flight_transit,'UniformOutput',false);
% commutes_long_transit    = cellfun(@(x) commutes.trip(x,:),indx.long_flight_transit,'UniformOutput',false);
% 
% ids = unique([flight.origin_UAMstops_id;flight.destination_UAMstops_id]);

% columns = [ 19 20 21 14 15 8 9 10 3 4];
% duration_car     = commutes.trip.flight_car_trip(:,7);
% duration_transit = commutes.trip.flight_transit_trip(:,7);
% trips_data       = flight(:,columns);
% trips_data       = addvars(trips_data,duration_car,'Before','origin_lat');
% trips_data       = addvars(trips_data,duration_transit,'Before','origin_lat');

for i = 1:size(indx,1)
    %   FINAL DATASET  
    initial_flight{i} = [commutes_hour.flight_car.data{i}(indx.initial_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.initial_flight_transit{i},:)];
    short_flight{i}   = [commutes_hour.flight_car.data{i}(indx.short_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.short_flight_transit{i},:)];
    long_flight{i}    = [commutes_hour.flight_car.data{i}(indx.long_flight_car{i},:);commutes_hour.flight_transit.data{i}(indx.long_flight_transit{i},:)];
    
    initial_drive{i} = [commutes_hour.drive.data{i}(indx.initial_drive{i},:)];
    short_drive{i}   = [commutes_hour.drive.data{i}(indx.short_drive{i},:)];
    long_drive{i}    = [commutes_hour.drive.data{i}(indx.long_drive{i},:)];
    
    initial_transit{i} = [commutes_hour.transit.data{i}(indx.initial_transit{i},:)];
    short_transit{i}   = [commutes_hour.transit.data{i}(indx.short_transit{i},:)];
    long_transit{i}    = [commutes_hour.transit.data{i}(indx.long_transit{i},:)];
end

DatasetsUAMstops.initial = [];
DatasetsUAMstops.short   = [];
DatasetsUAMstops.long    = [];
DatasetsDrive.initial = [];
DatasetsDrive.short   = [];
DatasetsDrive.long    = [];
DatasetsTransit.initial = [];
DatasetsTransit.short   = [];
DatasetsTransit.long    = [];

for i = 1:size(indx,1)
    DatasetsUAMstops.initial = [DatasetsUAMstops.initial;initial_flight{i}];
    DatasetsUAMstops.short   = [DatasetsUAMstops.shor   ;short_flight{i}];
    DatasetsUAMstops.long    = [DatasetsUAMstops.long   ;long_flight{i}];
    
    DatasetsDrive.initial = [DatasetsDrive.initial;initial_drive{i}];
    DatasetsDrive.short   = [DatasetsDrive.shor   ;short_drive{i}];
    DatasetsDrive.long    = [DatasetsDrive.long   ;long_drive{i}];
    
    DatasetsTransit.initial = [DatasetsTransit.initial;initial_drive{i}];
    DatasetsTransit.short   = [DatasetsTransit.shor   ;short_drive{i}];
    DatasetsTransit.long    = [DatasetsTransit.long   ;long_drive{i}];
end



end

