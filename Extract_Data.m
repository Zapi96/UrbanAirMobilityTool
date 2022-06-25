%% 1.Areas
load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Data\Boundaries\Data_Boundaries_Areas.mat')

A = [areas.area_number,areas.x_centroid,areas.y_centroid,areas.z_centroid,areas.lat_centroid,areas.lon_centroid];
title = {'area_number','x_centroid','y_centroid','z_centroid','lat_centroid','lon_centroid'};
t = array2table(A, 'VariableNames', title);
writetable(t, 'data_areas.csv');

%% 2.Tracts/3.Blocks
% load Data/Community/Data_Community_Area

data_tracts = [];
data_blocks = [];

title_tracts = {'area_id','tracts_id','tracts_population',...
    'tracts_x_centroid','tracts_y_centroid','tracts_z_centroid',...
    'tracts_lat_centroid','tracts_lon_centroid'};
title_blocks = {'area_id','blocks_id','blocks_population',...
    'blocks_x_centroid','blocks_y_centroid','blocks_z_centroid',...
    'blocks_lat_centroid','blocks_lon_centroid'};

for i = 1:length(community_area)
    area = community_area(i);
    
    aux_tracts = [repmat(i,length(area.tracts_id),1),area.tracts_id,area.tracts_population,...
        area.tracts_x_centroid,area.tracts_y_centroid,area.tracts_z_centroid,...
        area.tracts_lat_centroid,area.tracts_lon_centroid];
    
    aux_blocks = [repmat(i,length(area.blocks_id),1),area.blocks_id,area.blocks_population,...
        area.blocks_x_centroid,area.blocks_y_centroid,area.blocks_z_centroid,...
        area.blocks_lat_centroid,area.blocks_lon_centroid];
    
    data_tracts = [data_tracts; aux_tracts];
    data_blocks = [data_blocks; aux_blocks];
    
end

data_tracts = array2table(data_tracts,'VariableNames',title_tracts);
data_blocks = array2table(data_blocks,'VariableNames',title_blocks);


writetable(data_tracts,'data_tracts.csv')
writetable(data_blocks,'data_blocks.csv')

%% 4.Commutes 

load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Data\Commutes\Data_Commutes.mat')
T = commutes.trip(:,[1:3,5:8,11:13,15:20]);
writetable(T,'data_commutes.csv')

%% 5.Commutes

load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\Density\Version6\Results_Datasets.mat')

writetable(DatasetsUAMstops.initial,'DatasetsUAMstops6_initial.csv')
writetable(DatasetsUAMstops.short,'DatasetsUAMstops6_short.csv')
writetable(DatasetsUAMstops.long,'DatasetsUAMstops6_long.csv')

%% 6.Commutes

load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\OTP\Version1\Results_Commutes_Maps.mat')
writetable(commutes_maps.trip(:,[1:3,5:13,15:24]),'data_commutes_full1.csv')


%% 7.UAMstops

%load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Data\Community\Data_Community_Area.mat')
UAMstops = [[community_area.area_number]',[community_area.UAMstops_id]',[community_area.UAMstops_x]',[community_area.UAMstops_y]',[community_area.UAMstops_z]'...
    [community_area.UAMstops_lat]',[community_area.UAMstops_lon]'];
title = {'area_number','UAMstop_id','UAMstop_x','UAMstop_y','UAMstop_z','UAMstop_lat','UAMstop_lon'};

t = array2table(UAMstops, 'VariableNames', title);
save t
writetable(t, 'data_UAMstops.csv');

%% 8. UAMstops trips

version_list = 2:6;

version_list = 2;

%load('D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Data\Community\Data_Community_Area.mat')

for version = version_list
    fprintf('Version: %g \n', version);

    load(join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\Results\Density\Version',string(version),'\Results_Datasets.mat'],''))

    UAMstops_id = [community_area.UAMstops_id];

    origin_UAMstops = UAMstops_id;



    hours = [];
    for i = 0:23
        hours = [hours,join(['H' string(i) ],'')];

    end

    title1 = cellstr([{'destination_UAMstop_id','landings'},hours]);
    title2 = cellstr([{'origin_UAMstop_id','takeoffs'},hours]);
    title3 = cellstr([{'origin_UAMstop_id','destination_UAMstop_id','total'},hours]);
    title4 = cellstr([{'destination_UAMstop_id','origin_UAMstop_id','total'},hours]);

    for tp = {'initial','short','long'}
        tp = tp{1};
        disp(tp)
        landing = [];
        takeoff = [];
        complete = [];
        complete2 = [];

        for origin = origin_UAMstops
            destination_UAMstops = origin_UAMstops(origin_UAMstops~=origin);
            total = 0;
            total_hour = zeros(1,24);
            for destination = destination_UAMstops
                cond = ((DatasetsUAMstops.(tp).origin_UAMstops_id == origin) & (DatasetsUAMstops.(tp).destination_UAMstops_id == destination));
                t = DatasetsUAMstops.(tp)(cond,:);
                if ~isempty(t)

                    [total_aux,~]= size(t);

                    
                    total_hour_aux = [];
                    for h =0:23
                        cond = hour(t.arrival_destination_UAMstop_time) == h;
                        th = t(cond,:);
                        [totalh,~]= size(th);
                        total_hour_aux = [total_hour_aux,totalh];

                    end
                    complete = [complete; [origin,destination,total_aux,total_hour_aux]];
                    
                    
                    total_hour = total_hour+total_hour_aux;
                    total = total+total_aux;
                    
             
                end
            end
            takeoff = [takeoff; [origin,total,total_hour]];
        end

        for destination = destination_UAMstops
            origin_UAMstops = destination_UAMstops(destination_UAMstops~=destination);
            total = 0;
            total_hour = zeros(1,24);
            for origin = origin_UAMstops

                cond = ((DatasetsUAMstops.(tp).origin_UAMstops_id == origin) & (DatasetsUAMstops.(tp).destination_UAMstops_id == destination));
                t = DatasetsUAMstops.(tp)(cond,:);
                if ~isempty(t)
%                     fprintf('[');
%                     fprintf('%g ', [origin,destination]);
%                     fprintf(']\n');

                    [total_aux,~]= size(t);
                    
                    total_hour_aux = [];
                    for h =0:23
                        cond = hour(t.arrival_destination_UAMstop_time) == h;
                        th = t(cond,:);
                        [totalh,~]= size(th);
                        total_hour_aux = [total_hour_aux,totalh];
                    end
                    
                    complete2 = [complete2; [destination,origin,total_aux,total_hour_aux]];

                    
                    total_hour = total_hour+total_hour_aux;
                    total = total+total_aux;
                    
                    
                end
            end
            landing = [landing; [destination,total,total_hour]];
        end
        
        if ~isempty(landing) && ~isempty(takeoff) && ~isempty(complete)

            landing = array2table(landing,'VariableNames',title1);
            takeoff = array2table(takeoff,'VariableNames',title2);
            complete = array2table(complete,'VariableNames',title3);
            complete2 = array2table(complete2,'VariableNames',title4);

            
            writetable(landing, join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_landings_',tp,string(version-1),'.csv'],''));
            writetable(takeoff, join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_takeoffs_',tp,string(version-1),'.csv'],''));
            writetable(complete, join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_complete_',tp,string(version-1),'.csv'],''));
            save(join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_landings_',tp,string(version-1),'.mat'],''),'landing')
            save(join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_takeoffs_',tp,string(version-1),'.mat'],''),'takeoff')
            save(join(['D:\Google Drive\Aeroespacial\2º Master\Research project\MATLAB Drive\YueYu data\6.UAMstops\Version',string(version-1),'\data_UAMstops_complete_',tp,string(version-1),'.mat'],''),'complete')
    
        end
    end
end



