close all; clc; clear all

%%  DATA

load Data/Community/Data_Community_Area

nf = 1;

%%   AREAS
close all
load Data/Community/Data_Community_Area

api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])
func_boundaries_plot(community_area,[],1,[],[],'ecef','streets');

h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Areas/Chicago_Areas2',nf,600)

%%   AREAS
close all
api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])
number_vector = 32;
for j = 1:length(number_vector)
    number = number_vector(j);
    for i = 1:length(community_area(number).areas_x_vector)
        plot(community_area(number).areas_lon_vector{i},community_area(number).areas_lat_vector{i},'k');
        hold on
    end
end
hold on
h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Tracts/Chicago_Area32',nf,600)

%%   TRACTS
close all
api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])
number_vector = 32;
for j = 1:length(number_vector)
    number = number_vector(j);
    for i = 1:length(community_area(number).tracts_x_vector)
        plot(community_area(number).tracts_lon_vector{i},community_area(number).tracts_lat_vector{i},'k');
        hold on
    end
end
hold on
h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Tracts/Chicago_Tracts2',nf,600)


%%   BLOCKS
close all
api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])
number_vector = 32;
for j = 1:length(number_vector)
    number = number_vector(j);
    for i = 1:length(community_area(number).blocks_x_vector)
        plot(community_area(number).blocks_lon_vector{i},community_area(number).blocks_lat_vector{i},'k');
        hold on
    end
end
hold on
h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Blocks/Chicago_Blocks2',nf,600)

%%  TRIPS DISTRIBUTION
clear all;
load Data/Probability/Data_Probability
load Data/TomTom/Data_Congestion
close all

fig = figure('Position', [200 200 1100 600]);

left_color = [0, 0.4470, 0.7410];
right_color = [1, 0, 0];
set(fig,'defaultAxesColorOrder',[left_color; right_color]);


hours = 2:2:24;
i = 0;
nf = 1;
for hour = hours
    i = i +1;
    if hour>12
        hour = hour-12;
        label_hours{i} = [num2str(floor(hour)),':00 PM'];
    else
        label_hours{i} = [num2str(floor(hour)),':00 AM'];
    end
    
end

yyaxis left
plot(1:24,probability.value{12},'Linewidth',1.5)
hour = find(probability.value{12}==max(probability.value{12}));
hold on
h = plot(hour,max(probability.value{12}),'.k','Markersize',10);
text(hour,max(probability.value{12}),['    Max. (',num2str(round(max(probability.value{12}),1)),' %)'],'HorizontalAlignment','left','Fontname','times','Fontsize',12)
ylabel('Probability of arrival, %','fontname','times','Fontsize',16)

yyaxis right
plot(1:24,DataCongestion*100,'--r','Linewidth',1.5)
ylabel({'Percentage of increase in',' duration of a commute, %'},'fontname','times','Fontsize',14)

xticks(hours)
xticklabels(label_hours)
xtickangle(45)

title('Arrival time distribution','fontname','times','FontSize',20)
xlabel('Hour','fontname','times','Fontsize',16)
set(gca,'fontname','times','Fontsize',16)
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
legend('Probability of arrival','Increase in commute time','location','northwest','Fontsize',12,'fontname','times')
grid on
save2pdf('Pictures/Commutes/Probability',nf,600)


%%  COMMUTES TIME
close all

colors = [27,79,114;
    33, 97, 140;
    40, 116, 166;
    46, 134, 193;
    52, 152, 219;
    93, 173, 226;
    133, 193, 233;
    174, 214, 241]/255;
figure()

xlabels = categorical({'Walk','Bycicle','Drive alone','Carpool','Taxi/motorcycle','Subway','Bus','Rail'});
time = [13 23 29 31 35 43 45 65].*eye(8);
b = bar(time,'stacked');
title('Commuting time','Fontname','times','FontSize',20)
xlabel('Mode of transportation','Fontname','times','Fontsize',14)
ylabel('Time, min','Fontname','times','Fontsize',14)
xtickangle(45)
set(gca,'xticklabel',xlabels,'Fontsize',12,'Fontname','times');
% legend(xlabels,'Location','northwest','Fontname','times')
h = yline(31,'--r');
hold on
set(get(get(h,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
text(1,31,'Average','VerticalAlignment','bottom','Color','r','Fontname','times','Fontsize',12)
for k = size(colors,1):-1:1
    b(end+1-k).FaceColor = colors(k,:);
    b(end+1-k).EdgeColor = 'none';
    b(end+1-k).BarWidth = 0.6;
    
end

grid on
save2pdf('Pictures/Commutes/Duration',1,600)

%% CLUSTERING
% load Data/Community/Data_Community_Area
close all
nf = 1;
figure('Position', [200 200 750 750])
number_vector = 32;
for j = 1:length(number_vector)
    number = number_vector(j);
    h1 = func_boundaries_population_areas(community_area,[],[],number,'Areas','ecef',[],2,[]);
    for i = 1:length(community_area(number).blocks_x_centroid)
        h2 = plot(community_area(number).blocks_x_centroid(i),community_area(number).blocks_y_centroid(i),'.b','MarkerSize',5);
        hold on
    end
end
box on
h3 = plot(community_area(number).centroid_x_population,community_area(number).centroid_y_population,'xr','MarkerSize',10,'Linewidth',2);
x = h3.XData;
y = h3.YData;
set(gca,'XColor', 'k','YColor','k','xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[])
legend([h1,h2,h3],'Community Area Border','Population Points','Centroid','Location','northwest')
xlabel('Longitude, º','fontname','times','Fontsize',18)
ylabel('Latitude, º','fontname','times','Fontsize',18)
% xticks(lon)
% xticklabels(lon_labels)
% yticks(lat)
% yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',12)
title('Clustering K-means','Fontname','times','FontSize',20)
save2pdf('Pictures/Centroids/Clustering',nf,600)

%%  POPULATION
close all
api_key=importdata('api_key.txt');
api_key = char(api_key);
nf = 1;
load Data/Community/Data_Community_Area
colors = [27,79,114;
    33, 97, 140;
    40, 116, 166;
    46, 134, 193;
    52, 152, 219;
    93, 173, 226;
    133, 193, 233]/255;
colors = flipud(colors);
figure('Position', [200 200 650 750])
colormap(colors)
h = colorbar;
set(get(h,'title'),'string','Population','Fontname','times','Fontsize',10);
func_boundaries_population_areas(community_area,[],[],1:77,'Tracts','ecef',[],1,[])

h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title('Tracts Population','fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Population',nf,600)


%%  INCOME
close all
api_key=importdata('api_key.txt');
api_key = char(api_key);

% load Data/Community/Data_Community_Area
colors = [27,79,114;
    33, 97, 140;
    40, 116, 166;
    46, 134, 193;
    52, 152, 219;
    93, 173, 226;
    133, 193, 233;
    174, 214, 241;
    214, 234, 248]/255;
colors = flipud(colors);
figure('Position', [200 200 650 750])
colormap(colors)
h = colorbar;
set(get(h,'title'),'string',{'Average Hourly','Income [$/h]'},'Fontname','times','Fontsize',10);
func_boundaries_population_areas(community_area,[],[],1:77,'Tracts','ecef',[],1,[])

h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Tracts Population's Income per hour",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Income',1,600)

%%  COMMUTES ORIGIN
nf = 1;
close all
load Data/Commutes/Data_Commutes
load Data/Data
total_community = sum(commutes.statistics.quantity);

[B,I] = sort(total_community,'descend');

order_total_community = B;
order_community_name  = data.community.name(I);

percentage = order_total_community/commutes.statistics.total_jobs;

jobs_chicago_5  = 0.05*commutes.statistics.total_jobs;
jobs_chicago_80 = 0.8*commutes.statistics.total_jobs;

position = find(order_total_community>0.7*commutes.statistics.total_jobs/length(order_total_community));

colors = [27,79,114;
    33, 97, 140;
    40, 116, 166;
    46, 134, 193;
    52, 152, 219;
    93, 173, 226;
    133, 193, 233;
    174, 214, 241;
    214, 234, 248]/255;

figure()
i = 0;
percentage_total = 0;
while percentage_total<0.6
    i = i +1;
    b(i) = bar(reordercats(categorical(order_community_name(i)),order_community_name(i)),order_total_community(i)');
    b(i).FaceColor = colors(i,:);
    b(i).EdgeColor = 'none';
    b(i).BarWidth = 0.6;
    hold on
    text(i,order_total_community(i),[num2str(round(percentage(i)*100,1)),'%'],'vert','bottom','horiz','center');
    percentage_total = percentage_total + percentage(i);
    
end
grid on
set(gca, 'FontSize',12,'FontName','times')
ylim([0 2.6*10^5])
xtickangle(45)
title('Number of commutes','FontSize',14,'Fontname','times')
xlabel('Community Area of Destination','FontSize',14,'Fontname','times')
ylabel('Number of commutes, %','FontSize',14,'Fontname','times')
save2pdf('Pictures/Chicago/Chicago_Commutes_destination',1,600)

%%  COMMUTES DESTINATION
nf = 1;
close all
load Data/Commutes/Data_Commutes
load Data/Data
total_community = sum(commutes.statistics.quantity,2);

[B,I] = sort(total_community,'descend');

order_total_community = B;
order_community_name  = data.community.name(I);

percentage = order_total_community/commutes.statistics.total_jobs;

jobs_chicago_5  = 0.05*commutes.statistics.total_jobs;
jobs_chicago_80 = 0.8*commutes.statistics.total_jobs;

position = find(order_total_community>0.7*commutes.statistics.total_jobs/length(order_total_community));

colors = [27,79,114;
    33, 97, 140;
    40, 116, 166;
    46, 134, 193;
    52, 152, 219;
    93, 173, 226;
    133, 193, 233;
    174, 214, 241;
    214, 234, 248]/255;

figure()
i = 0;
percentage_total = 0;
while percentage_total<0.30
    i = i +1;
    b(i) = bar(reordercats(categorical(order_community_name(i)),order_community_name(i)),order_total_community(i)');
    b(i).FaceColor = colors(i,:);
    b(i).EdgeColor = 'none';
    b(i).BarWidth = 0.6;
    hold on
    text(i,order_total_community(i),[num2str(round(percentage(i)*100,1)),'%'],'vert','bottom','horiz','center');
    percentage_total = percentage_total + percentage(i);
    
end
grid on
set(gca, 'FontSize',12,'FontName','times')
ylim([0 0.5*10^5])
xtickangle(45)
title('Number of commutes','FontSize',14,'Fontname','times')
xlabel('Community Area of Origin','FontSize',14,'Fontname','times')
ylabel('Number of commutes, %','FontSize',14,'Fontname','times')
save2pdf('Pictures/Chicago/Chicago_Commutes_origin',1,600)


%% UAMSTOP
wgs84 = wgs84Ellipsoid('kilometer');
%load Data/Community/Data_Community_Area
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
number_vector = 32;
for j = 1:length(number_vector)
    number = number_vector(j);
    [h1,h2,h4] = func_boundaries_population_areas(community_area,'lines','UAMstops',number,'Areas','ecef',[],2,[]);
    
end
box on
[lat,lon,h] = ecef2geodetic(wgs84,community_area(number).centroid_x_population,community_area(number).centroid_y_population,4235.732)
h3 = plot(lon,lat,'xr','MarkerSize',10,'Linewidth',2,'DisplayName','Centroid');
x = h3.XData;
y = h3.YData;
set(gca,'XColor', 'k','YColor','k','xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[])
legend([h1,h4,h2(1),h2(2),h2(end),h3],'Location','Northwest')
h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Tracts Population's Income per hour",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
title('UAMstops','Fontname','times','FontSize',18)
save2pdf('Pictures/Centroids/UAMstops',nf,600)
%% UAMSTOP ALL
% load Data/Community/Data_Community_Area
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
number_vector = 1:77;
for j = 1:length(number_vector)
    number = number_vector(j);
    [h1,h2,h4] = func_boundaries_population_areas(community_area,[],'UAMstops',number,'Areas','ecef',[],2,[]);
    
end

box on
% h3 = plot(community_area(number).centroid_lon_population,community_area(number).centroid_lat_population,'xr','MarkerSize',10,'Linewidth',2,'DisplayName','Centroid');
% x = h3.XData;
% y = h3.YData;
set(gca,'XColor', 'k','YColor','k','xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[])
legend([h1,h4(end)],'Community Area','UAMstop')
h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Tracts Population's Income per hour",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
title('UAMstops','Fontname','times','FontSize',18)
save2pdf('Pictures/Centroids/UAMstops_all',nf,600)


%% AIRSPACE
% load Data/Community/Data_Community_Area
load Data/Mesh/Data_MEsh
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
%   Airspace existence in Chicago (intersection with curise altitude)

colors = [183, 28, 28 ]/255;
for i = 1:length(mesh.restricted_airspace)
    h1 = patch(mesh.cell_lon{mesh.restricted_airspace(i)},mesh.cell_lat{mesh.restricted_airspace(i)},colors,'FaceAlpha',0.7,'EdgeColor','none','DisplayName','Restricted Airspace (B or C)');
    hold on
end

% xlim([min(x) max(x)])
axis tight
number_vector = 1:77;
for i=1:length(number_vector)
    number = number_vector(i);
    if ~isempty(community_area(number).UAMstops_x)
        h2 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
    end
end
box on
h = plot_google_map('width',640,'height',640,'ShowLabels',0,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Restricted airspace",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace',nf,600)

%% BUILDINGS
% load Data/Community/Data_Community_Area
% load Data/Mesh/Data_MEsh
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
%   Airspace existence in Chicago (intersection with curise altitude)

colors = [183, 28, 28 ]/255;
for i = 1:length(mesh.restricted_buildings)
    h1 = patch(mesh.cell_lon{mesh.restricted_buildings(i)},mesh.cell_lat{mesh.restricted_buildings(i)},colors,'FaceAlpha',0.7,'EdgeColor','none','DisplayName','Buildings');
    hold on
end

% xlim([min(x) max(x)])
axis tight
number_vector = 32;
for i=1:length(number_vector)
    number = number_vector(i);
    if ~isempty(community_area(number).UAMstops_x)
        h2 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
    end
end
box on
h = plot_google_map('width',640,'height',640,'ShowLabels',0,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Restricted airspace",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_buildings',nf,600)


%% CORRIDORS
% load Data/Community/Data_Community_Area
% load Data/Mesh/Data_MEsh
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
%   Airspace existence in Chicago (intersection with curise altitude)

colors = [183, 28, 28 ]/255;
for i = 1:length(mesh.restricted_airspace)
    if all(mesh.restricted_airspace(i) ~= mesh.unrestricted)
        h1 = patch(mesh.cell_lon{mesh.restricted_airspace(i)},mesh.cell_lat{mesh.restricted_airspace(i)},colors,'FaceAlpha',0.7,'EdgeColor','none','DisplayName','Restricted Airspace (B or C)');
    end
    hold on
end

% xlim([min(x) max(x)])
axis tight
number_vector = 1:77;
for i=1:length(number_vector)
    number = number_vector(i);
    if ~isempty(community_area(number).UAMstops_x)
        h2 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
    end
end
box on
h = plot_google_map('width',640,'height',640,'ShowLabels',0,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Restricted airspace (with corridors)",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_corridors',nf,600)

%% CORRIDORS BUILDINGS
% load Data/Community/Data_Community_Area
% load Data/Mesh/Data_MEsh
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
%   Airspace existence in Chicago (intersection with curise altitude)

colors = [183, 28, 28 ]/255;
for i = 1:length(mesh.restricted_buildings)
    if all(mesh.restricted_buildings(i) ~= mesh.unrestricted)
        h1 = patch(mesh.cell_lon{mesh.restricted_buildings(i)},mesh.cell_lat{mesh.restricted_buildings(i)},colors,'FaceAlpha',0.7,'EdgeColor','none','DisplayName','Buildings');
    end
    hold on
end

% xlim([min(x) max(x)])
axis tight
number_vector = 32;
for i=1:length(number_vector)
    number = number_vector(i);
    if ~isempty(community_area(number).UAMstops_x)
        h2 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
        plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ro','MarkerSize',40,'LineWidth',2)
    end
end
box on
h = plot_google_map('width',640,'height',640,'ShowLabels',0,'autoaxis',1,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Restricted airspace (with corridors)",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_buildings_corridors',nf,600)


%%  2D PATH

load Data/Path/Data_Real_Flight_Path
% load Data/Mesh/Data_Mesh


api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
%   Airspace existence in Chicago (intersection with curise altitude)

for i = 1:length(mesh.restricted_airspace)
    if all(mesh.restricted_airspace(i) ~= mesh.unrestricted)
        h1 = patch(mesh.cell_lon{mesh.restricted_airspace(i)},mesh.cell_lat{mesh.restricted_airspace(i)},colors,'FaceAlpha',0.7,'EdgeColor','none');
    end
    hold on
end

colors = [183, 28, 28 ]/255;
for i = 1:length(mesh.restricted_buildings)
    if all(mesh.restricted_buildings(i) ~= mesh.unrestricted)
        h1 = patch(mesh.cell_lon{mesh.restricted_buildings(i)},mesh.cell_lat{mesh.restricted_buildings(i)},colors,'FaceAlpha',0.7,'EdgeColor','none','DisplayName','Restricted Airspace');
    end
    hold on
end


axis tight
number_vector = 1:77;
for i=1:length(number_vector)
    number = number_vector(i);
    if ~isempty(community_area(number).UAMstops_x)
        h2 = plot(community_area(number).UAMstops_lon(1),community_area(number).UAMstops_lat(1),'ko','MarkerSize',5,'LineWidth',2,'DisplayName','UAMstop');
    end
end

for i = 1:size(flight_path.cells,1)
    for j = 1:size(flight_path.cells,2)
        cells = flight_path.cells{i,j}{:};
        if cells ~= 0
            h3 = plot(mesh.centroid_lon(cells),mesh.centroid_lat(cells),'-k','Linewidth',1);
        end
    end
end

h = plot_google_map('width',640,'height',640,'ShowLabels',0,'autoaxis',1,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Flight paths",'fontname','times','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)],'Location','Southwest')
set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
save2pdf('Pictures/Commutes/Flight_paths',nf,600)


%%  ONE SELECTED TRIP
close all

version = 6;

load(['Results/EffectiveCost/','Version',num2str(version),'/Results_Effective_cost'])
load(['Results/OTP/Version', num2str(version),'/Results_Commutes_Maps'])
label = 'short_flight_car';
hour  = 7;

% index = selected_trips.(char(label)){hour,1};
trip  = index(1);

time_fly_drive = [90-commutes_maps.trip.flight_car_trip(:,8),...
    commutes_maps.trip.flight_car_trip(:,1:7)];

time_fly_transit = [90-commutes_maps.trip.flight_transit_trip(:,8),...
    commutes_maps.trip.flight_transit_trip(:,1:7)];

time_drive = [90-commutes_maps.trip.drive(:,1), commutes_maps.trip.drive(:,1)];

time_transit = [90-commutes_maps.trip.transit(:,1), commutes_maps.trip.transit(:,1)];

nf = 1;
x = categorical({'VTOL ','VTOL (TRANSIT)','TRANSIT','CAR'});
for i =  trip
    figure('Position', [100 100 1100 200])
    vector = [time_fly_drive(i,:),zeros(1,length(time_fly_drive(i,:))-1),0,0; ...
        time_fly_transit(i,1),zeros(1,length(time_fly_drive(i,:))-1),time_fly_transit(i,2:end),0,0;
        [time_transit(i,1),zeros(1,2*(length(time_fly_drive(i,:)))-2), time_transit(i,2),0 ];
        [time_drive(i,1), zeros(1,2*(length(time_fly_drive(i,:)))-2), 0,time_drive(i,2)]];
    h = barh(x,vector,'stacked','BarWidth',0.6);
    h(1).FaceColor      = 'none'; % color
    h(1).EdgeColor      = 'none';
    h(1).BaseLine.Color = 'none';
    h(2).FaceColor      = [184, 84, 80]/255; % Drive
    h(3).FaceColor      = [187, 143, 206]/255; % Waiting
    h(4).FaceColor      = [202, 207, 210 ]/255; % Warmup
    h(5).FaceColor      = [130, 179, 102]/255; % Boarding
    h(6).FaceColor      = [108, 142, 191]/255; % Fly
    h(7).FaceColor      = h(5).FaceColor; % Deboarding
    h(8).FaceColor      = h(2).FaceColor; % Drive
    h(9).FaceColor      = [214, 182, 86]/255; % Transit
    h(10).FaceColor     = h(3).FaceColor; % Waiting
    h(11).FaceColor     = h(4).FaceColor; % Warmup
    h(12).FaceColor     = h(5).FaceColor; % Boarding
    h(13).FaceColor     = h(6).FaceColor; % Fly
    h(14).FaceColor     = h(5).FaceColor; % Deboarding
    h(15).FaceColor     = h(9).FaceColor; % Transit
    h(16).FaceColor     = h(9).FaceColor; % Transit
    h(17).FaceColor     = h(2).FaceColor; % Drive
    
    for j = 1:length(h)
        h(j).EdgeColor      = 'none';
    end
    title('Time comparison (without ride-sharing)','FontSize',18,'Fontname','Times')
    xlim([min([min(time_fly_drive(i,1)) min(time_fly_transit(i,1)) min(time_transit(i,1)) min(time_drive(i,1))] )-3 100-7])
    xticks([30 60 90])
    xticklabels({'6:00','6:30','7:00'})
    legend( [h(2) h(9) h(3) h(4) h(5) h(6)],...
        'Driving time','Transit time','Waiting time','Warmup time','Boarding/deboarding time','Flying time',...
        'Location','eastoutside')
    set(gca, 'FontSize',14,'FontName','times')
    mkdir('Pictures/Commutes',['Version',num2str(version)])
    save2pdf(['Pictures/Commutes/','Version',num2str(version),'/Chicago_Commutes_Time',num2str(i)],nf,600)
    
end


%% PIE PLOT TOTAL DAY
close all

version = 5;

load(['Results/OTP/Version',num2str(version),'/Results_Commutes_Maps'])
load(['Results/EffectiveCost/Version',num2str(version),'/Results_Effective_cost'])

nf = 1;
fig = figure( 'Position', [10 10 700 500]);

colors = [[184, 84, 80]/255; [214, 182, 86]/255; [130, 179, 102]/255; [131, 145, 146 ]/255];
modes_initial = [length(cell2mat(selected_trips.initial_drive)),...
    length(cell2mat(selected_trips.initial_transit)),...
    length(cell2mat(selected_trips.initial_flight_car)),...
    length(cell2mat(selected_trips.initial_flight_transit))];
names = {addComma(modes_initial(1)),addComma(modes_initial(2)),...
    addComma(modes_initial(3)),addComma(modes_initial(4))};
explode = [1 1 1 1];

h = func_pie(modes_initial,explode,names);

count = 0;
for i = 1:length(h)
    if  rem(i,2)
        count = count+1;
        h(i).EdgeColor = 'none';
        h(i).FaceColor = colors(count,:);
    else
        h(i).FontName = 'Times';
        h(i).FontSize = 22;
    end
end
%title({'Legs comparison for a day (Initial cost)',' ',' '},'FontSize',18,'Fontname','times')

labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
lgd = legend(labels,'Location','northwestoutside','Orientation','vertical');
lgd.FontSize = 14;
% saveas(fig,'Pictures\Density\pie_initial_cost.png')
mkdir('Pictures\Density',['Version',num2str(version)])
save2pdf(['Pictures\Density\Version',num2str(version),'/pie_initial_cost'],nf,600)

nf = 2;
fig = figure( 'Position', [10 10 700 500]);
modes_short = [length(cell2mat(selected_trips.short_drive)),...
    length(cell2mat(selected_trips.short_transit)),...
    length(cell2mat(selected_trips.short_flight_car)),...
    length(cell2mat(selected_trips.short_flight_transit))];
names = {addComma(modes_short(1)),addComma(modes_short(2)),...
    addComma(modes_short(3)),addComma(modes_short(4))};
explode = [1 1 1 1];

h = func_pie(modes_short,explode,names);
%title({'Legs comparison for a day (Short term cost)',' ',' '},'FontSize',18,'Fontname','times')
count = 0;
for i = 1:length(h)
    if  rem(i,2)
        count = count+1;
        h(i).EdgeColor = 'none';
        h(i).FaceColor = colors(count,:);
    else
        h(i).FontName = 'Times';
        h(i).FontSize = 22;
    end
end
labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
lgd = legend(labels,'Location','northwestoutside','Orientation','vertical');
lgd.FontSize = 14;

% saveas(fig,'Pictures\Density\pie_short_cost.png')
save2pdf(['Pictures\Density\Version',num2str(version),'/pie_short_cost'],nf,600)

nf = 3;
fig = figure( 'Position', [10 10 700 500]);
modes_long = [length(cell2mat(selected_trips.long_drive)),...
    length(cell2mat(selected_trips.long_transit)),...
    length(cell2mat(selected_trips.long_flight_car)),...
    length(cell2mat(selected_trips.long_flight_transit))];
names = {addComma(modes_long(1)),addComma(modes_long(2)),...
    addComma(modes_long(3)),addComma(modes_long(4))};
explode = [1 1 1 1];
h = func_pie(modes_long,explode,names);
%title({'Legs comparison for a day (Long term cost)',' ',' '},'FontSize',18,'Fontname','times')
count = 0;
for i = 1:length(h)
    if  rem(i,2)
        count = count+1;
        h(i).EdgeColor = 'none';
        h(i).FaceColor = colors(count,:);
    else
        h(i).FontName = 'Times';
        h(i).FontSize = 22;
    end
end
labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
lgd = legend(labels,'Location','northwestoutside','Orientation','vertical');
lgd.FontSize = 14;
% saveas(fig,'Pictures\Density\pie_long_cost.png')
save2pdf(['Pictures\Density\Version',num2str(version),'/pie_long_cost'],nf,600)



%%  DENSITY
close all; clc;
area = 177; % NM^2

density_initial = [];
density_short = [];
density_long = [];

versions = [2,3,4,5,6];
for i = 1:length(versions)
    load(['Results/EffectiveCost/','Version',num2str(versions(i)),'/Results_Effective_cost'])
    load(['Results/Density/','Version',num2str(versions(i)),'/Results_Datasets'])
    for j = 1:24
        amount_initial = length(selected_trips.initial_flight_car{j})+length(selected_trips.initial_flight_transit{j});
        amount_short   = length(selected_trips.short_flight_car{j})+length(selected_trips.short_flight_transit{j});
        amount_long    = length(selected_trips.long_flight_car{j})+length(selected_trips.long_flight_transit{j});
        
        density_initial(i,j) = amount_initial/area;
        density_short(i,j)   = amount_short/area;
        density_long(i,j)    = amount_long/area;
    end
    clearvars selected_trips
end

hours = 2:2:24;
i = 0;
nf = 1;
for hour = hours
    i = i +1;
    if hour>12
        hour = hour-12;
        label_hours{i} = [num2str(floor(hour)),':00 PM'];
    else
        label_hours{i} = [num2str(floor(hour)),':00 AM'];
    end
    
end

version = 3;

figure()
hold on
plot(1:24,density_initial(1,:),'-*','LineWidth',1.5,'Color',[108, 142, 191]/255); % Blue
plot(1:24,density_initial(4,:),'-*','LineWidth',1.5,'Color',[130, 179, 102]/255); % Green
plot(1:24,density_initial(3,:),'-*','LineWidth',1.5,'Color',[184, 84, 80]/255); % Red
title({'Density along one day without', 'ride-sharing (Initial term)'},'Fontname','times','Fontsize',18)
ylabel('Density, Aircraft/nmi^2','Fontname','times','Fontsize',16)
xlabel('Hour','Fontname','times','Fontsize',16)
legend('5 min in UAMstop','10 min in UAMstop','20 min in UAMstop','Location','northeast')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
mkdir('Pictures\Commutes',['Version',num2str(version)])
save2pdf(['Pictures\Commutes\Version',num2str(version),'/Density_initial'],1,600)



figure()
hold on
plot(1:24,density_short(1,:),'-*','LineWidth',1.5,'Color',[108, 142, 191]/255); % Blue
plot(1:24,density_short(4,:),'-*','LineWidth',1.5,'Color',[130, 179, 102]/255); % Green
plot(1:24,density_short(3,:),'-*','LineWidth',1.5,'Color',[184, 84, 80]/255); % Red
title({'Density along one day without', 'ride-sharing (Short term)'},'Fontname','times','Fontsize',18)
ylabel('Density, Aircraft/nmi^2','Fontname','times','Fontsize',16)
xlabel('Hour','Fontname','times','Fontsize',16)
legend('5 min in UAMstop','10 min in UAMstop','20 min in UAMstop','Location','northeast')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
mkdir('Pictures\Commutes',['Version',num2str(version)])
save2pdf(['Pictures\Commutes\Version',num2str(version),'/Density_short'],1,600)


figure()
hold on
plot(1:24,density_long(1,:),'-*','LineWidth',1.5,'Color',[108, 142, 191]/255); % Blue
plot(1:24,density_long(4,:),'-*','LineWidth',1.5,'Color',[130, 179, 102]/255); % Green
plot(1:24,density_long(3,:),'-*','LineWidth',1.5,'Color',[184, 84, 80]/255);   % Red
title({'Density along one day without','ride-sharing (Long term)'},'Fontname','times','Fontsize',18)
ylabel('Density, Aircraft/nmi^2','Fontname','times','Fontsize',16)
xlabel('Hour','Fontname','times','Fontsize',16)
legend('5 min in UAMstop','10 min in UAMstop','20 min in UAMstop','Location','northeast')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Commutes\Version',num2str(version),'/Density_long'],2,600)

figure()
hold on
plot(1:24,density_short(1,:),'-*','LineWidth',1.5,'Color',[108, 142, 191]/255);  % Blue
plot(1:24,density_short(4,:),'-*','LineWidth',1.5,'Color',[130, 179, 102]/255);  % Green
plot(1:24,density_short(3,:),'-*','LineWidth',1.5,'Color',[184, 84, 80]/255);    % Red
plot(1:24,density_short(5,:),'--*','LineWidth',1.5,'Color',[130, 179, 102]/255); % Green
plot(1:24,density_short(2,:),'--*','LineWidth',1.5,'Color',[184, 84, 80]/255);   % Red
title({'Density along one day with', 'ride-sharing (Short term)'},'Fontname','times','Fontsize',18)
ylabel('Density, Aircraft/nmi^2','Fontname','times','Fontsize',16)
xlabel('Hour','Fontname','times','Fontsize',16)
legend('5 min in UAMstop','10 min in UAMstop','20 min in UAMstop','10 min in UAMstop (w/ ride-sharing)','20 min in UAMstop (w/ ride-sharing)','Location','northeast')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
mkdir('Pictures\Commutes',['Version',num2str(version)])
save2pdf(['Pictures\Commutes\Version',num2str(version),'/Density_short_ride_sharing'],3,600)


figure()
hold on
plot(1:24,density_long(1,:),'-*','LineWidth',1.5,'Color',[108, 142, 191]/255);  % Blue
plot(1:24,density_long(4,:),'-*','LineWidth',1.5,'Color',[130, 179, 102]/255);  % Green
plot(1:24,density_long(3,:),'-*','LineWidth',1.5,'Color',[184, 84, 80]/255);    % Red
plot(1:24,density_long(5,:),'--*','LineWidth',1.5,'Color',[130, 179, 102]/255); % Green
plot(1:24,density_long(2,:),'--*','LineWidth',1.5,'Color',[184, 84, 80]/255);   % Red
title({'Density along one day with','ride-sharing (Long term)'},'Fontname','times','Fontsize',18)
ylabel('Density, Aircraft/nmi^2','Fontname','times','Fontsize',16)
xlabel('Hour','Fontname','times','Fontsize',16)
legend('5 min in UAMstop','10 min in UAMstop','20 min in UAMstop','10 min in UAMstop (w/ ride-sharing)','20 min in UAMstop (w/ ride-sharing)','Location','northeast')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Commutes\Version',num2str(version),'/Density_long_ride_sharing'],4,600)

%%  STATISTICS
version = 5;

load(['Results/OTP/Version',num2str(version),'/Results_Commutes_Maps'])
load(['Results/EffectiveCost/Version',num2str(version),'/Results_Effective_cost'])


[statistics_initial] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'initial');
[statistics_short] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'short');
[statistics_long] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'long');

%%  REPRESENTATION
close all;


hours = 2:2:24;
i = 0;
nf = 1;
for hour = hours
    i = i +1;
    if hour>12
        hour = hour-12;
        label_hours{i} = [num2str(floor(hour)),':00 PM'];
    else
        label_hours{i} = [num2str(floor(hour)),':00 AM'];
    end
    
end


%   DURATION
fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.duration_flight_transit{i})),statistics_long.duration_flight_transit{i},'.','MarkerEdgeColor',[130, 179, 102]/255);
% end
p = plot(1:24,statistics_long.median_duration_flight_transit,'-*','Linewidth',1.5,'Color',[27, 94, 32 ]/255);
q = plot(1:24,statistics_long.median_duration_transit_transit,'--*','Linewidth',1,'Color',[27, 94, 32 ]/255);
r = plot(1:24,statistics_long.median_duration_car_transit,'--*','Linewidth',1,'Color',[26, 35, 126]/255);

% values_transit = statistics_long.median_duration_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
title('Duration of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Time, min ','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
legend([p,q,r],'Median Fly+Transit','Median Transit','Median Car','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
mkdir('Pictures\Statistics',['Version',num2str(version)])
save2pdf(['Pictures/Statistics/Version',num2str(version),'/Average_duration_long_transit'],1,600)



fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.duration_flight_car{i})),statistics_long.duration_flight_car{i},'.','MarkerEdgeColor',[108, 142, 191]/255);
% end
p = plot(1:24,statistics_long.median_duration_flight_car,'-*','Linewidth',1.5,'Color',[26, 35, 126]/255);
q = plot(1:24,statistics_long.median_duration_car_car,'--*','Linewidth',1,'Color',[26, 35, 126]/255);
r = plot(1:24,statistics_long.median_duration_transit_car,'--*','Linewidth',1,'Color',[27, 94, 32 ]/255);


% values_car = statistics_long.median_duration_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Top','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)


title('Duration of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Time, min ','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend([h,p,q,r],'Fly+Car','Median Fly+Car','Median Car','Median Transit','Location','best')
legend([p,q,r],'Median Fly+Car','Median Car','Median Transit','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures/Statistics/Version',num2str(version),'/Average_duration_long_car'],2,600)

% fig = figure();
% hold on
%
% % plot(1:24,statistics_short.average_duration_transit,'-*','Linewidth',1.5,'Color',[130, 179, 102]/255)
% % values_transit = statistics_short.average_duration_transit(:);
% % values_transit = values_transit(values_transit~=0);
% % yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% % text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
%
% plot(1:24,statistics_short.median_duration_car,'-*','Linewidth',1.5,'Color',[108, 142, 191]/255)
% values_car = statistics_short.median_duration_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)
%
%
% title('Average duration of commutes per hour (Short term)','Fontname','times','Fontsize',18)
% ylabel('Time, min ','Fontname','times','Fontsize',16)
% xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','median Car','Location','best')
% xticks(hours)
% xticklabels(label_hours)
% xtickangle(45)
% ylim([0,50])
% set(gca, 'FontSize',12,'FontName','times')
% box on
% grid on
% save2pdf('Pictures\Statistics\Average_duration_short',2,600)


%   DISTANCE
fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.distance_transit{i})),statistics_long.distance_transit{i}*0.621371,'.','MarkerEdgeColor',[130, 179, 102]/255);
% end
p = plot(1:24,statistics_long.median_distance_transit*0.621371,'-*','Linewidth',1.5,'Color',[27, 94, 32 ]/255);
% values_transit = statistics_long.median_distance_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
title('Distance of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Distance, miles','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Transit','Median Transit','Location','best')
legend('Median Fly+Transit','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,35])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_distance_long_transit'],3,600)

fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.distance_car{i})),statistics_long.distance_car{i}*0.621371,'.','MarkerEdgeColor',[108, 142, 191]/255);
% end
p = plot(1:24,statistics_long.median_distance_car*0.621371,'-*','Linewidth',1.5,'Color',[26, 35, 126]/255);
% values_car = statistics_long.median_distance_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)
title('Distance of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Distance, miles','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','Median Car','Location','best')
legend('Median Fly+Car','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,35])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_distance_long_car'],4,600)


% fig = figure();
% hold on

% plot(1:24,statistics_short.average_distance_transit,'-*','Linewidth',1.5,'Color',[130, 179, 102]/255)
% values_transit = statistics_short.average_distance_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
%
% plot(1:24,statistics_short.median_distance_car,'-*','Linewidth',1.5,'Color',[108, 142, 191]/255)
% values_car = statistics_short.median_distance_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)
%
%
% title('Average distance of commutes per hour (Short term)','Fontname','times','Fontsize',18)
% ylabel('Distance, km','Fontname','times','Fontsize',16)
% xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','Median Car','Location','best')
% xticks(hours)
% xticklabels(label_hours)
% xtickangle(45)
% ylim([0,20])
% set(gca, 'FontSize',12,'FontName','times')
% box on
% grid on
% save2pdf('Pictures\Statistics\Average_distance_short',4,600)


%   COST
fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.cost_transit{i})),statistics_long.cost_transit{i},'.','MarkerEdgeColor',[130, 179, 102]/255);
% end
plot(1:24,statistics_long.median_cost_transit,'-*','Linewidth',1.5,'Color',[27, 94, 32 ]/255)
% values_transit = statistics_long.median_cost_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
title('Effective cost of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Effective cost, $','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Transit','Median Transit','Location','best')
legend('Median Fly+Transit','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,60])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_cost_long_transit'],5,600)


figure()
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.cost_car{i})),statistics_long.cost_car{i},'.','MarkerEdgeColor',[108, 142, 191]/255);
% end
p = plot(1:24,statistics_long.median_cost_car,'-*','Linewidth',1.5,'Color',[26, 35, 126]/255);
% values_car = statistics_long.median_cost_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Top','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)


title('Effective cost of commutes per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Effective cost, $','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','Median Car','Location','best')
legend('Median Fly+Car','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,60])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_cost_long_car'],6,600)


%VALUE OF TIME
fig = figure();
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.vtime_transit{i})),statistics_long.vtime_transit{i},'.','MarkerEdgeColor',[130, 179, 102]/255);
% end
plot(1:24,statistics_long.median_vtime_transit,'-*','Linewidth',1.5,'Color',[27, 94, 32 ]/255)
% values_transit = statistics_long.median_cost_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)
title('Value of time of commuters per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Value of time, $','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Transit','Median Transit','Location','best')
legend('Median Fly+Transit','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,60])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_time_long_transit'],7,600)


figure()
hold on
% for i = 1:24
%     h = scatter(i*ones(1,length(statistics_long.vtime_car{i})),statistics_long.vtime_car{i},'.','MarkerEdgeColor',[108, 142, 191]/255);
% end
p = plot(1:24,statistics_long.median_vtime_car,'-*','Linewidth',1.5,'Color',[26, 35, 126]/255);
% values_car = statistics_long.median_cost_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Top','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)


title('Value of time of commuters per hour (Long term)','Fontname','times','Fontsize',18)
ylabel('Value of time, $','Fontname','times','Fontsize',16)
xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','Median Car','Location','best')
legend('Median Fly+Car','Location','best')
xticks(hours)
xticklabels(label_hours)
xtickangle(45)
% ylim([0,60])
set(gca, 'FontSize',12,'FontName','times')
box on
grid on
save2pdf(['Pictures\Statistics\Version',num2str(version),'/Average_time_long_car'],8,600)

% fig = figure();
% hold on

% plot(1:24,statistics_short.average_cost_transit,'-*','Linewidth',1.5,'Color',[130, 179, 102]/255)
% values_transit = statistics_short.average_cost_transit(:);
% values_transit = values_transit(values_transit~=0);
% yline(mean(values_transit),'--','Color',[27, 94, 32 ]/255,'Linewidth',1.5);
% text(22,mean(values_transit),num2str(ceil(mean(values_transit))),'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[27, 94, 32 ]/255)

% plot(1:24,statistics_short.median_cost_car,'-*','Linewidth',1.5,'Color',[108, 142, 191]/255)
% values_car = statistics_short.median_cost_car(:);
% values_car = values_car(values_car~=0);
% yline(mean(values_car),'--','Color',[26, 35, 126]/255,'Linewidth',1.5);
% text(22,mean(values_car),{num2str(ceil(mean(values_car)))},'VerticalAlignment','Bottom','Fontname','times','Fontsize',12,'Color',[26, 35, 126]/255)
%
%
% title('Average cost of commutes per hour (Short term)','Fontname','times','Fontsize',18)
% ylabel('Cost, $','Fontname','times','Fontsize',16)
% xlabel('Hour of the day','Fontname','times','Fontsize',16)
% legend('Fly+Car','median Car','Location','best')
% xticks(hours)
% xticklabels(label_hours)
% xtickangle(45)
% ylim([0,55])
% set(gca, 'FontSize',12,'FontName','times')
% box on
% grid on
% save2pdf('Pictures\Statistics\Average_cost_short',6,600)


%%   ORIGIN
% load Data/Community/Data_Community_Area
api_key=importdata('api_key.txt');
api_key = char(api_key);

colors = [27,79,114;
    40, 116, 166;
    52, 152, 219;
    133, 193, 233;
    214, 234, 248]/255;

colors = flipud(colors);

nf = 1;
hour = 8;

% AREAS
for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    areas = statistics_long.main_origin_area_transit{hour,1};
    colormap(colors(1:length(areas),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(areas)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(areas):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    for i = 1:length(community_area)
        if any(i == areas)
            color = length(areas)+1-find(i==areas);
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],color)
            text(community_area(i).areas_lon_centroid,community_area(i).areas_lat_centroid,{num2str(statistics_long.main_origin_area_transit{hour,2}(find(i==areas)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
        else
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],length(areas)+1,'Facealpha',0)
        end
        
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Origins for Fly+Transit (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_origin_Fly+transit_long_',num2str(hour)],1,600)
    
end

for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    areas = statistics_long.main_origin_area_car{hour,1};
    colormap(colors(1:length(areas),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(areas)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(areas):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    for i = 1:length(community_area)
        if any(i == areas)
            color = length(areas)+1-find(i==areas);
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],color)
            text(community_area(i).areas_lon_centroid,community_area(i).areas_lat_centroid,{num2str(statistics_long.main_origin_area_car{hour,2}(find(i==areas)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
        else
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],length(areas)+1,'Facealpha',0)
        end
        
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Origins for Fly+Car (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_origin_Fly+car_long_',num2str(hour)],1,600)
    
end

%% TRACTS
for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    tracts = statistics_long.main_origin_tract_transit{hour,1};
    colormap(colors(1:length(tracts),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(tracts)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(tracts):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    
    for i = 1:length(community_area)
        for j = 1:length(community_area(i).tracts_lon_vector)
            if any(community_area(i).tracts_id(j) == tracts)
                color = length(tracts)+1-find(community_area(i).tracts_id(j) == tracts);
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],color)
                %             text(community_area(i).tracts_lon_centroid(j),community_area(i).tracts_lat_centroid(j),{num2str(statistics_long.main_origin_tract_transit{hour,2}(find(community_area(i).tracts_id(j) == tracts)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
            else
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],length(tracts)+1,'Facealpha',0)
            end
        end
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main origins for Fly+Transit (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_origin_Fly+transit_long_',num2str(hour),'_tracts'],1,600)
    
end

for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    tracts = statistics_long.main_origin_tract_car{hour,1};
    colormap(colors(1:length(tracts),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(tracts)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(tracts):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    for i = 1:length(community_area)
        for j = 1:length(community_area(i).tracts_lon_vector)
            if any(community_area(i).tracts_id(j) == tracts)
                color = length(tracts)+1-find(community_area(i).tracts_id(j) == tracts);
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],color)
                %             text(community_area(i).tracts_lon_centroid(j),community_area(i).tracts_lat_centroid(j),{num2str(statistics_long.main_origin_tract_transit{hour,2}(find(community_area(i).tracts_id(j) == tracts)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
            else
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],length(tracts)+1,'Facealpha',0)
            end
        end
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main origins for Fly+Car (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_origin_Fly+car_long_',num2str(hour),'_tracts'],1,600)
    
end

%%   DESTINATION
close all
% load Data/Community/Data_Community_Area
api_key=importdata('api_key.txt');
api_key = char(api_key);

colors = [27,79,114;
    40, 116, 166;
    52, 152, 219;
    133, 193, 233;
    214, 234, 248]/255;

colors = flipud(colors);

nf = 1;
hour = 8;

% AREAS
for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    areas = statistics_long.main_destination_area_transit{hour,1};
    colormap(colors(1:length(areas),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(areas)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(areas):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    
    for i = 1:length(community_area)
        if any(i == areas)
            color = length(areas)+1-find(i==areas);
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],color)
            text(community_area(i).areas_lon_centroid,community_area(i).areas_lat_centroid,{num2str(statistics_long.main_destination_area_transit{hour,2}(find(i==areas)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
        else
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],length(areas)+1,'Facealpha',0)
        end
        
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Destinations for Fly+Transit (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_destination_Fly+transit_long_',num2str(hour)],1,600)
    
end

for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    areas = statistics_long.main_destination_area_car{hour,1};
    colormap(colors(1:length(areas),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(areas)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(areas):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    for i = 1:length(community_area)
        if any(i == areas)
            color = length(areas)+1-find(i==areas);
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],color)
            text(community_area(i).areas_lon_centroid,community_area(i).areas_lat_centroid,{num2str(statistics_long.main_destination_area_car{hour,2}(find(i==areas)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
        else
            patch([community_area(i).areas_lon_vector{1}],[community_area(i).areas_lat_vector{1}],length(areas)+1,'Facealpha',0)
        end
        
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Destinations for Fly+Car (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_destination_Fly+car_long_',num2str(hour)],1,600)
    
end

%% TRACTS
for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    tracts = statistics_long.main_destination_tract_transit{hour,1};
    colormap(colors(1:length(tracts),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(tracts)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(tracts):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    
    for i = 1:length(community_area)
        for j = 1:length(community_area(i).tracts_lon_vector)
            if any(community_area(i).tracts_id(j) == tracts)
                color = length(tracts)+1-find(community_area(i).tracts_id(j) == tracts);
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],color)
                %             text(community_area(i).tracts_lon_centroid(j),community_area(i).tracts_lat_centroid(j),{num2str(statistics_long.main_destination_tract_transit{hour,2}(find(community_area(i).tracts_id(j) == tracts)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
            else
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],length(tracts)+1,'Facealpha',0)
            end
        end
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Destinations for Fly+Transit (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_destination_Fly+transit_long_',num2str(hour),'_tracts'],1,600)
    
end

for hour = [8,10]
    close all
    figure('Position', [200 200 650 750])
    hold on
    tracts = statistics_long.main_destination_tract_car{hour,1};
    colormap(colors(1:length(tracts),:))
    h = colorbar;
    set(get(h,'title'),'string','Ranking','Fontname','times','Fontsize',10);
    h.Ticks = 1.5:length(tracts)+0.5 ; %Create 8 ticks from zero to 1
    h.TickLabels = num2cell(length(tracts):-1:1) ;    %Replace the labels of these 8 ticks with the numbers 1 to 8
    
    for i = 1:length(community_area)
        for j = 1:length(community_area(i).tracts_lon_vector)
            if any(community_area(i).tracts_id(j) == tracts)
                color = length(tracts)+1-find(community_area(i).tracts_id(j) == tracts);
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],color)
                %             text(community_area(i).tracts_lon_centroid(j),community_area(i).tracts_lat_centroid(j),{num2str(statistics_long.main_destination_tract_transit{hour,2}(find(community_area(i).tracts_id(j) == tracts)))},'VerticalAlignment','middle','Fontsize',10,'HorizontalAlignment','center','Color',[211, 47, 47]/255)
            else
                patch([community_area(i).tracts_lon_vector{j}],[community_area(i).tracts_lat_vector{j}],length(tracts)+1,'Facealpha',0)
            end
        end
    end
    h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
    lon = h.XData;
    lat = h.YData;
    box on
    [lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
    title(['Main Destinations for Fly+Car (',num2str(hour),':00AM)'],'fontname','times','Fontsize',18)
    xlabel('Longitude','fontname','times','Fontsize',16)
    ylabel('Latitude','fontname','times','Fontsize',16)
    xticks(lon)
    xticklabels(lon_labels)
    yticks(lat)
    yticklabels(lat_labels)
    set(gca,'XColor', 'k','YColor','k','fontname','times','Fontsize',14)
    save2pdf(['Pictures\Statistics\Main_destination_Fly+car_long_',num2str(hour),'_tracts'],1,600)
    
end