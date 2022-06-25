function [DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit] = func_dataset(DatasetsUAMstops_flight,Datasets_Drive,Datasets_Transit,indx,commutes_hour,effective_cost,label,mode)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
for i = 1:size(indx,1)
 
    %   FINAL DATASET
    
    
    cost_flight_car     = effective_cost.([char(label),'_flight_car']){i};
    cost_flight_transit = effective_cost.([char(label),'_flight_transit']){i};
    
    cost_car     = effective_cost.([char(label),'_drive']){i};
    cost_transit = effective_cost.([char(label),'_transit']){i};
    
   
    
    temp_flight{i} = [addvars(commutes_hour.flight_car{i}(indx.([char(label),'_flight_car']){i},:),cost_flight_car,'After','destination_lon','NewVariableNames','effective_cost') ;...
        addvars(commutes_hour.flight_transit{i}(indx.([char(label),'_flight_transit']){i},:), cost_flight_transit,'After','destination_lon','NewVariableNames','effective_cost')];
    
    temp_car{i} = [addvars(commutes_hour.flight_car{i}(indx.([char(label),'_drive']){i},:),cost_car,'After','destination_lon','NewVariableNames','effective_cost')];
   
    temp_transit{i} = [addvars(commutes_hour.flight_transit{i}(indx.([char(label),'_transit']){i},:),cost_transit,'After','destination_lon','NewVariableNames','effective_cost')];


end

DatasetsUAMstops_flight.(char(label)) = [];
DatasetsUAMstops_transit.(char(label)) = [];
DatasetsUAMstops_car.(char(label)) = [];

for i = 1:size(indx,1)
    DatasetsUAMstops_flight.(char(label)) = [DatasetsUAMstops_flight.(char(label));temp_flight{i}];
    DatasetsUAMstops_car.(char(label))     = [DatasetsUAMstops_car.(char(label));temp_car{i}];
    DatasetsUAMstops_transit.(char(label)) = [DatasetsUAMstops_transit.(char(label));temp_transit{i}];
end

end

