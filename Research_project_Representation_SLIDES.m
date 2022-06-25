close all; clc; clear all

%%  DATA

load Data/Community/Data_Community_Area

nf = 1;

%%  CHICAGO BOUNDARY DATA
close all

fileID = fopen('api_token_chicago.txt');
api_key = fscanf(fileID,'%c') ;
fclose(fileID);

url = ['http://data.cityofchicago.org/resource/qqq8-j68g.json?%24%24app_token=',api_key];

str = urlread(url);
value = jsondecode(str);

chicago.longitude = value.the_geom.coordinates{2,1}{1,1}(:,1);
chicago.latitude = value.the_geom.coordinates{2,1}{1,1}(:,2);

api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])

plot(chicago.longitude,chicago.latitude,'k');
hold on
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
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Areas/Chicago',nf,600)


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

%%   AREA
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
set(get(h,'title'),'string',{'Average Hourly','Income [$/h]'},'Fontname','helvetica','Fontsize',10);
func_boundaries_population_areas(community_area,[],[],1:77,'Tracts','ecef',[],1,[])

h = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h.XData;
lat = h.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
title("Tracts Population's Income per hour",'fontname','helvetica','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Chicago/Income',1,600)




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
[lat,lon,h] = ecef2geodetic(wgs84,community_area(number).centroid_x_population,community_area(number).centroid_y_population,4235.732);
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

%% LINES 
% load Data/Community/Data_Community_Area
api_key=importdata('api_key.txt');
api_key = char(api_key);

close all
nf = 1;
figure('Position', [200 200 750 750])
area = 32;

ax1 = subplot(1,1,1);
h1 = plot(community_area.areas_lon_vector{:},community_area(area).areas_lat_vector{:},'k','DisplayName','Community Area Border');
xlim(get(gca, 'XLim'))
ylim(get(gca, 'YLim'))

colors = {'Red','Blue','Green','Brown','Purple','Yellow','Pink','Orange'};
red     = [1 0 0];
blue    = [0 0 1];
green   = [0 204/255 0];
brown   = [153/255 76/255 0];
purple  = [127/255 0 1];
purple2 = [102/255 0 204/255];
yellow  = [1 1 0];
pink    = [1 0 1];
orange  = [1 0.5 0];
color = [red;blue;green;brown;purple;yellow;pink;orange];

for i=1:length(colors)
    x = line.(colors{i}).longitude_line;
    y = line.(colors{i}).latitude_line;

    plot(x,y,'color',color(i,:),'linewidth',2)
    plot(line.(colors{i}).longitude,line.(colors{i}).latitude,'*','color',color(i,:),'markersize',10)
   
end


box on
% h3 = plot(community_area(number).centroid_lon_population,community_area(number).centroid_lat_population,'xr','MarkerSize',10,'Linewidth',2,'DisplayName','Centroid');
% x = h3.XData;
% y = h3.YData;
set(gca,'XColor', 'k','YColor','k','xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[])
% legend([h1,h4(end)],'Community Area','UAMstop')
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
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
title('UAMstops','Fontname','times','FontSize',18)
save2pdf('Pictures/Centroids/UAMstops_all_lines_area32',nf,600)

%% LINES ALL
% load Data/Community/Data_Community_Area
close all
load Data/Community/Data_Community_Area

api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])
func_boundaries_plot(community_area,[],1,[],[],'ecef','streets');

colors = {'Red','Blue','Green','Brown','Purple','Yellow','Pink','Orange'};
red     = [1 0 0];
blue    = [0 0 1];
green   = [0 204/255 0];
brown   = [153/255 76/255 0];
purple  = [127/255 0 1];
purple2 = [102/255 0 204/255];
yellow  = [1 1 0];
pink    = [1 0 1];
orange  = [1 0.5 0];
color = [red;blue;green;brown;purple;yellow;pink;orange];

for i=1:length(colors)
    x = line.(colors{i}).longitude_line;
    y = line.(colors{i}).latitude_line;

    plot(x,y,'color',color(i,:),'linewidth',2)
    plot(line.(colors{i}).longitude,line.(colors{i}).latitude,'*','color',color(i,:),'markersize',5)
   
end


box on
% h3 = plot(community_area(number).centroid_lon_population,community_area(number).centroid_lat_population,'xr','MarkerSize',10,'Linewidth',2,'DisplayName','Centroid');
% x = h3.XData;
% y = h3.YData;
set(gca,'XColor', 'k','YColor','k','xticklabel',[],'yticklabel',[],'xtick',[],'ytick',[])
% legend([h1,h4(end)],'Community Area','UAMstop')
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
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
title('UAMstops','Fontname','times','FontSize',18)
save2pdf('Pictures/Centroids/UAMstops_all_lines',nf,600)

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
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
title('UAMstops','Fontname','times','FontSize',18)
save2pdf('Pictures/Centroids/UAMstops_all2',nf,600)


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
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace2',nf,600)

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
title("Restricted airspace",'fontname','helvetica','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_buildings2',nf,600)


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
title("Restricted airspace (with corridors)",'fontname','helvetica','Fontsize',18)
xlabel('Longitude, º','fontname','helvetica','Fontsize',16)
ylabel('Latitude, º','fontname','helvetica','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_corridors2',nf,600)

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
title("Restricted airspace (with corridors)",'fontname','helvetica','Fontsize',18)
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)])
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Chicago/Airspace_buildings_corridors2',nf,600)


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
title("Flight paths",'fontname','helvetica','Fontsize',18)
xlabel('Longitude, º','fontname','helvetica','Fontsize',16)
ylabel('Latitude, º','fontname','helvetica','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend([h1(end),h2(end)],'Location','Southwest')
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('Pictures/Commutes/Flight_paths2',nf,600)

%% AIRSPACE BOUNDARIES
clear all; clc;close all

load Data\Airspace\Data_Airspace

fileID = fopen('api_token_chicago.txt');
api_key = fscanf(fileID,'%c') ;
fclose(fileID);

url = ['http://data.cityofchicago.org/resource/qqq8-j68g.json?%24%24app_token=',api_key];

str = urlread(url);
value = jsondecode(str);

chicago.longitude = value.the_geom.coordinates{2,1}{1,1}(:,1);
chicago.latitude = value.the_geom.coordinates{2,1}{1,1}(:,2);

api_key=importdata('api_key.txt');
api_key = char(api_key);

nf = 1;
figure('Position', [200 200 650 750])


plot(chicago.longitude,chicago.latitude,'k');
hold on
xlim(get(gca, 'XLim'))
ylim(get(gca, 'YLim'))


idx_airspace = find(airspace.upper>1500 & airspace.lower<=1500 & (strcmp(airspace.class,'B') | strcmp(airspace.class,'C')  ));
selected_airspace = airspace(idx_airspace,:);



for i = 1:size(selected_airspace,1)
    pgon = polyshape(selected_airspace.longitude{i},selected_airspace.latitude{i});
    h(i) = plot(pgon,'DisplayName',['Airspace Class ',selected_airspace.class{i}]);
    hold on
end



h2 = plot_google_map('ShowLabels',0,'Resize',2,'autoaxis',1,'scale',2,'maptype','roadmap','apikey',api_key);
lon = h2.XData;
lat = h2.YData;
box on
[lat,lat_labels,lon,lon_labels] = func_plot_labels(lat,lon);
xlabel('Longitude, º','fontname','times','Fontsize',16)
ylabel('Latitude, º','fontname','times','Fontsize',16)
xticks(lon)
xticklabels(lon_labels)
yticks(lat)
yticklabels(lat_labels)
legend(h)
set(gca,'XColor', 'k','YColor','k','fontname','helvetica','Fontsize',14)
save2pdf('D:\Google Drive\Aeroespacial\2º Master\Research project\Presentations\Symposium\Plots/Chicago_Airspace',nf,600)

%%  MAP REPRESENTATION TOTAL
clc; clear all; close all
load Data/Commutes/Data_Commutes
load Data/Commutes/Data_Commutes_flight
load Data/Community/Data_Community_Area 
load Results/EffectiveCost/Version2/Results_Effective_Cost
% close all
%   FUNCTION CONFIGURATION
%   With cond we can choose the desired trips that we wanna show. If cond =
%   [] then all of them will be shown
cond = find(commutes.trip.area_from == 66);
cond = find(commutes_flight.destination_UAMstops_id==30171);
cond      = [];
lines     = [];
centroids = [];
UAMstops  = 1;
label     = 'long_flight_car';
hour      = 7;
step      = 5;
time      = 0.00000000001;
type      = 'Google Maps';
map       = [];
size_point = 2;
filename  = 'AnimatedTotal.gif';

%   FEASIBLE TRIPS REPRESENTATION
feasible_trips_representation_total_animated(filename,community_area,commutes_flight,lines,centroids,UAMstops,cond,selected_trips,label,hour,step,time,type,map,size_point)
% feasible_trips_representation_total(community_area,flight,lines,centroids,UAMstops,cond,indx,label,hour,type,map,size_point)
% saveas(1,'Pictures\Density\trips_long_presentation.png')


% name = 'TRIPS AT 7 AM FOR LONG TERM COST (USING CAR)';
% feasible_trips_representation_total(name,flight,cond,indx,'short_flight_car',7);

% saveas(1,'Pictures\Density\trips3.png')


%%  DENSITY
filename = 'D:\Google Drive\Aeroespacial\2º Master\Research project\Presentations\Presentation.xls';
sheet = 'Sheet5';

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


short_fivemin = density_short(1,:)';
short_tenmin = density_short(4,:)';
short_tenmin_rs = density_short(5,:)';
short_twentymin = density_short(3,:)';
short_twentymin_rs = density_short(2,:)';

short = [short_fivemin,short_tenmin,short_twentymin,short_tenmin_rs,short_twentymin_rs];

long_fivemin = density_long(1,:)';
long_tenmin = density_long(4,:)';
long_tenmin_rs = density_long(5,:)';
long_twentymin = density_long(3,:)';
long_twentymin_rs = density_long(2,:)';

long = [long_fivemin,long_tenmin,long_twentymin,long_tenmin_rs,long_twentymin_rs];

range = [2,25];

letter = ['A','B','C','D','E','F','G','H','I','J'];

data = [short,long];

for i = 1:length(letter)
    
    xlswrite(filename,data(:,i),sheet,[letter(i),num2str(range(1)),':',letter(i),num2str(range(2))])
    
end




%%  STATISTICS
version = 5;

load(['Results/OTP/Version',num2str(version),'/Results_Commutes_Maps'])
load(['Results/EffectiveCost/Version',num2str(version),'/Results_Effective_cost'])


[statistics_initial] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'initial');
[statistics_short] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'short');
[statistics_long] = func_statistics_trips(selected_trips, commutes_maps,effective_cost,'long');

%%  REPRESENTATION
%   DURATION
close all;
filename = 'D:\Google Drive\Aeroespacial\2º Master\Research project\Presentations\Presentation.xls';
sheet  = 'Duration';

hours = 2:2:24;
range = [2,25];

letter = ['A','B','C','D','E','F'];
fields = {'median_duration_flight_transit','median_duration_transit_transit','median_duration_car_transit',...
    'median_duration_flight_car','median_duration_car_car','median_duration_transit_car'};
data = [];
for i = 1:length(fields)
    xlswrite(filename,statistics_long.(fields{i}),sheet,[letter(i),num2str(range(1)),':',letter(i),num2str(range(2))])
end



%   DISTANCE
sheet  = 'Distance';

hours = 2:2:24;
range = [2,25;29,52];

letter = ['B','C','D','E','F'];
fields = {'median_distance_transit','median_distance_car'};
data = [];
for i = 1:length(fields)
    xlswrite(filename,statistics_long.(fields{i})*0.621371,sheet,[letter(1),num2str(range(i,1)),':',letter(1),num2str(range(i,2))])
end


%   COST

sheet  = 'Cost';

hours = 2:2:24;
range = [2,25;29,52];

letter = ['B','C','D','E','F'];
fields = {'median_cost_transit','median_cost_car'};
for i = 1:length(fields)
    xlswrite(filename,statistics_long.(fields{i}),sheet,[letter(1),num2str(range(i,1)),':',letter(1),num2str(range(i,2))])
end

%VALUE OF TIME

sheet  = 'Value of time';

range = [2,25;29,52];

letter = ['B','C','D','E','F'];
fields = {'median_vtime_transit','median_vtime_car'};
data = [];
for i = 1:length(fields)
    xlswrite(filename,statistics_long.(fields{i}),sheet,[letter(1),num2str(range(i,1)),':',letter(1),num2str(range(i,2))])
end


