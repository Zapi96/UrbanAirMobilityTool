clc; clear all; close all;

%%  DATA

% load('Data\Data_Community_Area.mat')
load Data/Data_Community_Area
load Data/Stations
load Data/Data
load Data/Data_Boundaries_Areas
load Data/Data_Boundaries_Blocks
load Data/Data_Boundaries_Tracts
load Data/Data_commutes
% load Data\Data_Community


% number_vector = 1:length(community_area);
nf = 0;

number_vector = 8;

%%   BOUNDARIES
nf = nf+1;
figure('Position', [100 100 700 600])
plot(areas.pgon(:),'LineWidth',1)
set(gca,'XColor', 'none','YColor','none')
hold on
for i = 1:length(community_area)
    text(areas.x_centroid(i),areas.y_centroid(i),num2str(areas.AREA_NUM_1(i)),'FontSize',7,'HorizontalAlignment','center','Interpreter','Latex')
end
save2pdf('Pictures\Chicago_Areas',nf,600)

% nf = nf+1;
% figure('Position', [100 100 600 600])
% plot(tracts.pgon(:),'LineWidth',0.5)
% set(gca,'XColor', 'none','YColor','none')
% save2pdf('Pictures\Chicago_Tracts',nf,600)

%%   CENTROIDS
nf = 0;
nf = nf+1;
figure('Position', [100 100 600 600])
plot(areas.pgon_ECEF(:),'LineWidth',1)
set(gca,'XColor', 'none','YColor','none')
hold on
size = 4;
for i = 1:length(community_area)
    p = scatter(areas.x_centroid(i),areas.y_centroid(i),size,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
end
legend(p,'Centroids','Location','best','Interpreter','Latex')
save2pdf('Pictures/Areas\Chicago_Areas_Centroids',nf,600)

% nf = nf+1;
% figure('Position', [100 100 600 600])
% plot(tracts.pgon(:),'LineWidth',0.5)
% hold on
% size = 2;
% for i = 1:length(tracts.x_centroid)
%     p = scatter(tracts.x_centroid(i),tracts.y_centroid(i),size,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
% end
% legend(p,'Centroids','Location','best','Interpreter','Latex')
% set(gca,'XColor', 'none','YColor','none')
% save2pdf('Pictures\Chicago_Tracts_Centroids',nf,600)

%%   POPULATION
number_vector = 1:77;
nf = nf+1;
boundaries_population_areas(community_area,number_vector,'Areas',[],size);
hold on
for i = 1:length(community_area)
    text(areas.x_centroid(i),areas.y_centroid(i),num2str(areas.AREA_NUM_1(i)),'FontSize',7,'HorizontalAlignment','center','Interpreter','Latex');
end
save2pdf('Pictures\Chicago_Areas_Population',nf,600)

for i =1
    nf = nf+1;
    boundaries_population_areas(community_area,number_vector(i),'Tracts',[],size)
    text(areas.x_centroid(number_vector(i)==areas.AREA_NUM_1),areas.y_centroid(number_vector(i)==areas.AREA_NUM_1),num2str(number_vector(i)),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
    title(areas.COMMUNITY(number_vector(i)==areas.AREA_NUM_1),'Interpreter','Latex')
    save2pdf(['Pictures\Chicago_Tracts_Population',num2str(number_vector(i))],nf,600)
end

% number_vector = 2;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)
% 
% number_vector = 3;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)
% 
% number_vector = 4;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)

%%  POPULATION CENTROIDS

number_vector = 1:77;
nf = nf+1;
boundaries_population_areas(community_area,number_vector,'Areas','Centroids',size);
save2pdf('Pictures\Chicago_Areas_Population_Centroids',nf,600)

size = 50;
for i = 1:length(number_vector)
    nf = nf+1;
    boundaries_population_areas(community_area,number_vector(i),'Tracts','Centroids',size)
    title(areas.COMMUNITY(number_vector(i)==areas.AREA_NUM_1),'Interpreter','Latex')
    save2pdf(['Pictures\Chicago_Tracts_Population_Centroids',num2str(number_vector(i))],nf,600)
end
% number_vector = 2;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts','Centroids',size)
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population_Centroids',num2str(number_vector)],nf,600)
% 
% number_vector = 3;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts','Centroids',size)
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population_Centroids',num2str(number_vector)],nf,600)
% 
% number_vector = 4;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts','Centroids',size)
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population_Centroids',num2str(number_vector)],nf,600)

%%  POPULATION CENTROIDS

size = 2;
nf = 1;
func_boundaries_plot(community_area,line,size,'Centroids','UAMstops','ecef',[]);
save2pdf('Pictures/Chicago\Chicago_Vertistops',nf,600)

%%   INCOME
close all
nf = 1;
size = 50;
number_vector = 1:77;
nf = nf+1;
func_boundaries_income_areas(community_area,number_vector,'Tracts',[],size);
hold on
% for i = 1:length(community_area)
%     text(areas.x_centroid(i),areas.y_centroid(i),num2str(areas.AREA_NUM_1(i)),'FontSize',7,'HorizontalAlignment','center','Interpreter','Latex');
% end
save2pdf('Pictures\Chicago/Income2',1,600)

% for i =32
%     nf = nf+1;
%     boundaries_income_areas(community_area,number_vector(i),'Tracts',[],size)
%     text(areas.x_centroid(number_vector(i)==areas.AREA_NUM_1),areas.y_centroid(number_vector(i)==areas.AREA_NUM_1),num2str(number_vector(i)),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
%     text(community_area(i).tracts_x_centroid,community_area(i).tracts_y_centroid,num2str(community_area(i).tracts_income),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% 
%     title(areas.COMMUNITY(number_vector(i)==areas.AREA_NUM_1),'Interpreter','Latex')
% %     save2pdf(['Pictures\Chicago_Tracts_Population',num2str(number_vector(i))],nf,600)
% end

% number_vector = 2;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)
% 
% number_vector = 3;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)
% 
% number_vector = 4;
% nf = nf+1;
% boundaries_population_areas(community_area,number_vector,'Tracts',[],size)
% text(areas.x_centroid(number_vector==areas.AREA_NUM_1),areas.y_centroid(number_vector==areas.AREA_NUM_1),num2str(number_vector),'FontSize',15,'HorizontalAlignment','center','Interpreter','Latex')
% title(areas.COMMUNITY(number_vector==areas.AREA_NUM_1),'Interpreter','Latex')
% save2pdf(['Chicago_Tracts_Population',num2str(number_vector)],nf,600)

%%  COMMUTES
% total_community = sum(commutes.statistics.quantity);
% 
% [B,I] = sort(total_community,'descend');
% 
% order_total_community = B;
% order_community_name  = data.community.name(I);
% 
% jobs_chicago_5  = 0.05*commutes.statistics.total_jobs;
% jobs_chicago_80 = 0.8*commutes.statistics.total_jobs;

% quantity = 0;
% for i = 1:length(order_total_community)
%    quantity = quantity+order_total_community(i);
%    
%    if quantity<0.4*jobs_chicago/length(order_total_community)
%        break;
%    end
% end

% position = find(order_total_community>0.4*commutes.statistics.total_jobs/length(order_total_community));
% 
% nf = nf+1;
% figure('Position', [100 100 1500 700])
% figure(nf)
% bar(reordercats(categorical(order_community_name(position)),order_community_name(position)),order_total_community(position)')
% set(gca, 'FontSize',14,'FontName','FixedWidthTex','TickLabelInterpreter','latex')
% title('COMMUTES','FontSize',22,'Interpreter','Latex')
% xlabel('Community Area','FontSize',18,'Interpreter','Latex')
% ylabel('Number of commutes','FontSize',18,'Interpreter','Latex')
% hold on
% yline(0.4*commutes.statistics.total_jobs/length(order_total_community), 'r','LineWidth',2);
% legend('Commutes','60\%','Interpreter','Latex')
% save2pdf('Pictures\Chicago_Commutes',nf,600)


red     = [1 0 0];
blue    = [0 0 1];
green   = [0 204/255 0];
brown   = [153/255 76/255 0];
purple  = [127/255 0 1];
purple2 = [102/255 0 204/255];
yellow  = [1 1 0];
pink    = [1 0 1];
orange  = [1 0.5 0];

color   = [red; yellow; blue; green;  pink; orange;];

nf = nf+1;
size = 4;
selected_areas = [32 8 28 76];
figure('Position', [100 100 700 600])
plot(areas.pgon_ECEF(:),'LineWidth',1)
set(gca,'XColor', 'none','YColor','none')
hold on
for i = 1:length(selected_areas)
    selected_centroids.area(i).x = community_area(selected_areas(i)).areas_x_centroid;
    selected_centroids.area(i).y = community_area(selected_areas(i)).areas_y_centroid;
    
    idx = find(commutes_flight.area_to==selected_areas(i));
    z = randsample(length(idx),15);

    for j = 1:length(z)
        plot([commutes_flight.block_from_x_centroid(idx(z(j))), selected_centroids.area(i).x],[commutes_flight.block_from_y_centroid(idx(z(j))), selected_centroids.area(i).y],'color',color(i,:))
        hold on
        scatter(selected_centroids.area(i).x,selected_centroids.area(i).y,6,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
        scatter(commutes_flight.block_from_x_centroid(idx(z(j))),commutes_flight.block_from_y_centroid(idx(z(j))),2,'o','MarkerEdgeColor','k','MarkerFaceColor','k');
    end
    
end

save2pdf('Pictures/Commutes\Chicago_Commutes_Areas',nf,600)

% figure()
% percentage = commutes.quantity(:,32)/sum(commutes.quantity(:,32))*100;
% [B,I] = sort(percentage,'descend');
% 
% order_total_community = B;
% order_community_name  = data.community.Name(I);
% order_community_name  = reordercats(categorical(order_community_name),order_community_name);
% order_community_name  = order_community_name(1:35);
% 
% bar(order_community_name(1:35),order_total_community(1:35))

%%  CENTOIDS COORDINATES
wgs84 = wgs84Ellipsoid('kilometer');

[lat,lon] = ecef2geodetic(wgs84,[community_area.C_x]',[community_area.C_y]',areas.z_centroid);

xlswrite('Results',lat,'Centroid','B4:B80')
xlswrite('Results',lon,'Centroid','C4:C80')

[lat,lon] = ecef2geodetic(wgs84,[community_area.vertistop_x]',[community_area.vertistop_y]',[community_area.vertistop_z]');

xlswrite('Results',lat,'Vertistop','B4:B45')
xlswrite('Results',lon,'Vertistop','C4:C45')

%%  FLIGHTS
close all;
nf = 0;
nf = nf+1;
set(0,'defaultLegendAutoUpdate','on');
size = 2;
p = func_boundaries_plot_nostations(areas,community_area,line,size,[]);

% trip = randsample(length(commutes.trip.distance),10);

origin_lon = commutes_flight.origin_lon(trip);
origin_lat = commutes_flight.origin_lat(trip);
origin_vertistops_lon = commutes_flight.origin_UAMstops_lon(trip);
origin_vertistops_lat = commutes_flight.origin_UAMstops_lat(trip);

destination_lon = commutes_flight.destination_lon(trip);
destination_lat = commutes_flight.destination_lat(trip);
destination_vertistops_lon = commutes_flight.destination_UAMstops_lon(trip);
destination_vertistops_lat = commutes_flight.destination_UAMstops_lat(trip);


k(1) = plot(origin_lon,origin_lat,'x','MarkerSize',8,'LineWidth',2,'DisplayName','Origin','Color',[198, 40, 40]/255);
hold on
k(2) = plot(destination_lon,destination_lat,'x','MarkerSize',8,'LineWidth',2,'DisplayName','Destination','Color',[21, 101, 192]/255);

%  FLIGHT PATH (STRAIGHT)

flight_path = [destination_vertistops_lon-origin_vertistops_lon destination_vertistops_lat-origin_vertistops_lat];

% for i = 1: length(destination_lon*2)
%     plot([origin_lon(i) ;destination_lon(i)],[origin_lat(i) ;destination_lat(i)],'k--','LineWidth',2)
% end

for i = 1: length(destination_lon*2)
    p_destination = plot([destination_lon(i) ;destination_vertistops_lon(i)],[destination_lat(i) ;destination_vertistops_lat(i)],'g-.','LineWidth',1.5,'DisplayName','Destination','Color',[21, 101, 192]/255);
    p_origin      = plot([origin_lon(i) ;origin_vertistops_lon(i)],[origin_lat(i) ;origin_vertistops_lat(i)],'c-.','LineWidth',1.5,'DisplayName','Origin','Color',[198, 40, 40]/255);
    p_flight      = plot([origin_vertistops_lon(i) ;destination_vertistops_lon(i)],[origin_vertistops_lat(i) ;destination_vertistops_lat(i)],'k-.','LineWidth',1.5,'DisplayName','Flight Path');

    p_destination.Annotation.LegendInformation.IconDisplayStyle = 'off'; % make the legend for step plot off
    p_origin.Annotation.LegendInformation.IconDisplayStyle      = 'off'; % make the legend for step plot off
    p_flight.Annotation.LegendInformation.IconDisplayStyle      = 'off'; % make the legend for step plot off



    if i == length(destination_lon*2)
        set(0,'defaultLegendAutoUpdate','on'); % make the legend for step plot off
        plot([destination_lon(i) ;destination_vertistops_lon(i)],[destination_lat(i) ;destination_vertistops_lat(i)],'-.','LineWidth',1.5,'DisplayName','Destination','Color',[21, 101, 192]/255);
        plot([origin_lon(i) ;origin_vertistops_lon(i)],[origin_lat(i) ;origin_vertistops_lat(i)],'-.','LineWidth',1.5,'DisplayName','Origin','Color',[198, 40, 40]/255);
        plot([origin_vertistops_lon(i) ;destination_vertistops_lon(i)],[origin_vertistops_lat(i) ;destination_vertistops_lat(i)],'k-.','LineWidth',1.5,'DisplayName','Flight Path')
    end
end
api_key=importdata('api_key.txt');
api_key = char(api_key);

h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude','interpreter','latex','Fontsize',16)
ylabel('Latitude','interpreter','latex','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','FontName','times','FontSize',14)

save2pdf('Pictures/Commutes/Chicago_Commutes_Flight',1,600)
