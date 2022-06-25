close all; clear all; clc;

load Data/Data_Commutes_Maps3
load Results/Results_Density_Distribution
load Data/Data_Community_Area
load Data/Stations
% load Results/OTP_Version_1/Version_1/result_drive3
% load Results/OTP_Version_1/Version_1/result_flight_car2
% load Results/OTP_Version_1/Version_1/result_flight_transit
% load Results/OTP_Version_1/Version_1/result_transit

%%  FLIGHT INFORMATION
dest_idx = 1:size(commutes.trip,1);
flight = flight_information(commutes,community_area,dest_idx);

%%  REPRESENTATION FOR ONE HOUR AND DIFFERENT TERMS
terms = categorical({'Initial', 'Short', 'Long'});
terms = reordercats(terms,{'Initial', 'Short', 'Long'});

hour_day_selected = 7;
figure('Renderer', 'painters', 'Position', [10 10 900 600])
% subplot(1,2,1)
h1 = plot(terms,effective_cost.car_drive(hour_day_selected,:),'-o');
set(h1(1), 'MarkerFaceColor',get(h1(1),'Color') );
% set(h1(2), 'MarkerFaceColor',get(h1(1),'Color'),'Color',get(h1(1),'Color') );

hold on
h2 = plot(terms,effective_cost.transit_drive(hour_day_selected,:),'-o');
set(h2(1), 'MarkerFaceColor',[0.6350, 0.0780, 0.1840] ,'Color',[0.6350, 0.0780, 0.1840] );
% set(h2(2), 'MarkerFaceColor',get(h2(1),'Color'),'Color',get(h2(1),'Color') );

legend('Fly+Drive<Drive','Fly+Transit<Drive','location','northwest')
% legend('Fly+Drive<Drive','Fly+Drive<Drive (GM)','Fly+Transit<Drive','Fly+Transit<Drive (GM)','location','northwest')
for i = hour_day_selected
    for k = 1:numel(effective_cost.car_drive(i,:))
        if i == 1
            text(k, effective_cost.car_drive(i,k), num2str(effective_cost.car_drive(i,k)), ...
                'HorizontalAlignment', 'right', ...
                'verticalalignment', 'bottom','Color',get(h1(1),'Color'))
        else
            text(k, effective_cost.car_drive(i,k), num2str(effective_cost.car_drive(i,k)), ...
                'HorizontalAlignment', 'left', ...
                'verticalalignment', 'top','Color',get(h1(1),'Color'))
        end
        
    end
    for k = 1:numel(effective_cost.transit_drive(i,:))
        if i == 1
            text(k, effective_cost.transit_drive(i,k), num2str(effective_cost.transit_drive(i,k)), ...
                'HorizontalAlignment', 'left', ...
                'verticalalignment', 'top','Color',get(h2(1),'Color'))
        else
            text(k, effective_cost.transit_drive(i,k), num2str(effective_cost.transit_drive(i,k)), ...
                'HorizontalAlignment', 'right', ...
                'verticalalignment', 'bottom','Color',get(h2(1),'Color'))
        end
    end
end
title('Effective cost (Fly vs drive)')
ylabel('Number of trips')
xlabel('Term')
% ylim([-1000 10.5^4])
% saveas(5,'Fig5')
% save2pdf('Effective cost (Fly vs drive)',5,600)

figure('Renderer', 'painters', 'Position', [10 10 900 600])
% subplot(1,2,2)
h1 = plot(terms,effective_cost.car_transit(hour_day_selected,:),'-o');
set(h1(1), 'MarkerFaceColor',get(h1(1),'Color') );
% set(h1(2), 'MarkerFaceColor',get(h1(1),'Color'),'Color',get(h1(1),'Color') );

hold on
h2 = plot(terms,effective_cost.transit_transit(hour_day_selected,:),'-o');
set(h2(1), 'MarkerFaceColor',[0.6350, 0.0780, 0.1840] ,'Color',[0.6350, 0.0780, 0.1840] );
% set(h2(2), 'MarkerFaceColor',get(h2(1),'Color'),'Color',get(h2(1),'Color') );

legend('Fly+Drive<Transit','Fly+Transit<Transit','location','northwest')
% legend('Fly+Drive<Transit','Fly+Drive<Transit (GM)','Fly+Transit<Transit','Fly+Transit<Transit (GM)','location','northwest')
for i = hour_day_selected
    for k = 1:numel(effective_cost.car_transit(i,:))
        if i == 1
            text(k, effective_cost.car_transit(i,k), num2str(effective_cost.car_transit(i,k)), ...
                'HorizontalAlignment', 'right', ...
                'verticalalignment', 'bottom','Color',get(h1(1),'Color'))
        else
            text(k, effective_cost.car_transit(i,k), num2str(effective_cost.car_transit(i,k)), ...
                'HorizontalAlignment', 'left', ...
                'verticalalignment', 'top','Color',get(h1(1),'Color'))
        end
    end
    for k = 1:numel(effective_cost.transit_transit(i,:))
        if i==1
            text(k, effective_cost.transit_transit(i,k), num2str(effective_cost.transit_transit(i,k)), ...
                'HorizontalAlignment', 'left', ...
                'verticalalignment', 'top','Color',get(h2(1),'Color'))
        else
            text(k, effective_cost.transit_transit(i,k), num2str(effective_cost.transit_transit(i,k)), ...
                'HorizontalAlignment', 'right', ...
                'verticalalignment', 'bottom','Color',get(h2(1),'Color'))
        end
    end
end
title('Effective cost (Fly vs transit)')
ylabel('Number of trips')
xlabel('Term')
% ylim([-0.5*10^4 3.5*10^4])
% saveas(6,'Fig6')
% save2pdf('Effective cost (Fly vs transit)',6,600)
set(0,'defaultLegendAutoUpdate','on');

%%  REPRESENTATION FOR DIFFERENT HOURS OF THE DAY
close all

figure()
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.car_drive(:,1))
hold on
plot(hour_cat,effective_cost.transit_drive(:,1))
plot(hour_cat,effective_cost.car_transit(:,1))
plot(hour_cat,effective_cost.transit_transit(:,1))
title('Trips distribution (Initial cost)')
ylabel('Number of trips [-]')
xlabel('Time of the day [h]')
legend('Fly+Car vs Drive','Fly+Transit vs Drive','Fly+Car vs Transit','Fly+Transit vs Transit')

figure()
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.car_drive(:,2))
hold on
plot(hour_cat,effective_cost.transit_drive(:,2))
plot(hour_cat,effective_cost.car_transit(:,2))
plot(hour_cat,effective_cost.transit_transit(:,2))
title('Trips distribution (Short term cost)')
ylabel('Number of trips [-]')
xlabel('Time of the day [h]')
legend('Fly+Car vs Drive','Fly+Transit vs Drive','Fly+Car vs Transit','Fly+Transit vs Transit')

figure()
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.car_drive(:,3))
hold on
plot(hour_cat,effective_cost.transit_drive(:,3))
plot(hour_cat,effective_cost.car_transit(:,3))
plot(hour_cat,effective_cost.transit_transit(:,3))
title('Trips distribution (Long term cost)')
ylabel('Number of trips [-]')
xlabel('Time of the day [h]')
legend('Fly+Car vs Drive','Fly+Transit vs Drive','Fly+Car vs Transit','Fly+Transit vs Transit')

%%  REPRESENTATION FOR DIFFERENT HOURS OF THE DAY (TOTAL)
close all

fig = figure();
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.total_flight_car(:,1))
hold on
plot(hour_cat,effective_cost.total_flight_transit(:,1))
plot(hour_cat,effective_cost.total_drive(:,1))
plot(hour_cat,effective_cost.total_transit(:,1))
title('TRIPS DISTRIBUTION (INITIAL COST)','FontSize',20)
ylabel('Number of trips [-]','FontSize',16)
xlabel('Time of the day [h]','FontSize',16)
set(gcf, 'Position', get(0, 'Screensize'));% For full screen
legend('Fly+Car','Fly+Transit','Drive','Transit')
saveas(fig,'Pictures\Density\trips_distribution_initial_cost.png')

fig = figure();
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.total_flight_car(:,2))
hold on
plot(hour_cat,effective_cost.total_flight_transit(:,2))
plot(hour_cat,effective_cost.total_drive(:,2))
plot(hour_cat,effective_cost.total_transit(:,2))
title('TRIPS DISTRIBUTION (SHORT TERM COST)','FontSize',20)
ylabel('Number of trips [-]','FontSize',16)
xlabel('Time of the day [h]','FontSize',16)
set(gcf, 'Position', get(0, 'Screensize'));% For full screen
legend('Fly+Car','Fly+Transit','Drive','Transit')
saveas(fig,'Pictures\Density\trips_distribution_short_cost.png')

fig = figure();
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
plot(hour_cat,effective_cost.total_flight_car(:,3))
hold on
plot(hour_cat,effective_cost.total_flight_transit(:,3))
plot(hour_cat,effective_cost.total_drive(:,3))
plot(hour_cat,effective_cost.total_transit(:,3))
title('TRIPS DISTRIBUTION (LONG TERM COST)','FontSize',20)
ylabel('Number of trips [-]','FontSize',16)
xlabel('Time of the day [h]','FontSize',16)
set(gcf, 'Position', get(0, 'Screensize'));% For full screen
legend('Fly+Car','Fly+Transit','Drive','Transit')
saveas(fig,'Pictures\Density\trips_distribution_long_cost.png')

xlswrite('Presentation',effective_cost.total_flight_car,'Sheet4','A2:C25')
xlswrite('Presentation',effective_cost.total_flight_transit,'Sheet4','D2:F25')
xlswrite('Presentation',effective_cost.total_drive,'Sheet4','G2:I25')
xlswrite('Presentation',effective_cost.total_transit,'Sheet4','J2:L25')


%% PIE PLOT TOTAL DAY

fig = figure();
modes_initial = [sum(effective_cost.total_drive(:,1)),...
                sum(effective_cost.total_transit(:,1)),...
                sum(effective_cost.total_flight_car(:,1)),...
                sum(effective_cost.total_flight_transit(:,1))];
names = {addComma(modes_initial(1)),addComma(modes_initial(2)),...
    addComma(modes_initial(3)),addComma(modes_initial(4))};
pie(modes_initial,names)
title({'LEGS COMPARISON FOR A DAY (INITIAL COST)',' '},'FontSize',14)
% ylabel('Number of trips [-]')
% xlabel('Time of the day [h]')
labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
legend(labels,'Location','southoutside','Orientation','horizontal')
saveas(fig,'Pictures\Density\pie_initial_cost.png')

fig = figure();
modes_short = [sum(effective_cost.total_drive(:,2)),...
               sum(effective_cost.total_transit(:,2)),...
               sum(effective_cost.total_flight_car(:,2)),...
               sum(effective_cost.total_flight_transit(:,2))];
names = {addComma(modes_short(1)),addComma(modes_short(2)),...
    addComma(modes_short(3)),addComma(modes_short(4))};
pie(modes_short,names)
title({'LEGS COMPARISON FOR A DAY (SHORT TERM COST)',' '},'FontSize',14)
% ylabel('Number of trips [-]')
% xlabel('Time of the day [h]')
labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
legend(labels,'Location','southoutside','Orientation','horizontal')
saveas(fig,'Pictures\Density\pie_short_cost.png')

fig = figure();
modes_long = [sum(effective_cost.total_drive(:,3)),...
              sum(effective_cost.total_transit(:,3)),...
              sum(effective_cost.total_flight_car(:,3)),...
              sum(effective_cost.total_flight_transit(:,3))];
names = {addComma(modes_long(1)),addComma(modes_long(2)),...
    addComma(modes_long(3)),addComma(modes_long(4))};
pie(modes_long,names)
title({'LEGS COMPARISON FOR A DAY (LONG TERM COST)',' '},'FontSize',14)
% ylabel('Number of trips [-]')
% xlabel('Time of the day [h]')
labels = {'Drive','Transit','Fly+Car','Fly+Transit'};
legend(labels,'Location','southoutside','Orientation','horizontal')
saveas(fig,'Pictures\Density\pie_long_cost.png')


%%  MAP REPRESENTATION TOTAL
% close all
%   FUNCTION CONFIGURATION
%   With cond we can choose the desired trips that we wanna show. If cond =
%   [] then all of them will be shown
cond = find(commutes.trip.area_from == 1);
% cond = find(flight.destination_UAMstops_id==30037);
% cond      = [];
lines     = [];
centroids = [];
UAMstops  = 1;
label     = 'long_flight_car';
hour      = 7;
step      = 5;
time      = 0.00000000001;
type      = 'geo';
map       = 'topographic';
size_point = 2;
filename  = 'animated2.gif';

%   FEASIBLE TRIPS REPRESENTATION
feasible_trips_representation_total_animated(filename,community_area,flight,lines,centroids,UAMstops,cond,indx,label,hour,step,time,type,map,size_point)
% feasible_trips_representation_total(community_area,flight,lines,centroids,UAMstops,cond,indx,label,hour,type,map,size_point)
% saveas(1,'Pictures\Density\trips_long_presentation.png')


% name = 'TRIPS AT 7 AM FOR LONG TERM COST (USING CAR)';
% feasible_trips_representation_total(name,flight,cond,indx,'short_flight_car',7);

% saveas(1,'Pictures\Density\trips3.png')

%%  ONE SELECTED TRIP

label = 'short_flight_car';
hour  = 7;

index = indx(hour).(char(label));
trip  = index(1);

time_fly_drive = [80-commutes.trip.flight_car_trip(:,8),...
        commutes.trip.flight_car_trip(:,1:7)];
    
time_fly_transit = [80-commutes.trip.flight_transit_trip(:,8),...
        commutes.trip.flight_transit_trip(:,1:7)];
    
time_drive = [80-commutes.trip.drive(:,1), commutes.trip.drive(:,1)];

time_transit = [80-commutes.trip.transit(:,1), commutes.trip.transit(:,1)];


x = categorical({'VTOL (CAR)','VTOL (TRANSIT)','TRANSIT','CAR'});
for i =  index(1)
    figure('Position', [100 100 1000 400])
    vector = [time_fly_drive(i,:),zeros(1,length(time_fly_drive(i,:))-1),0,0; ...
        time_fly_transit(i,1),zeros(1,length(time_fly_drive(i,:))-1),time_fly_transit(i,2:end),0,0;
        [time_transit(i,1),zeros(1,2*(length(time_fly_drive(i,:)))-2), time_transit(i,2),0 ];
        [time_drive(i,1), zeros(1,2*(length(time_fly_drive(i,:)))-2), 0,time_drive(i,2)]];
    h = barh(x,vector,'stacked','BarWidth',0.5);
    h(1).FaceColor      = 'none'; % color
    h(1).EdgeColor      = 'none';
    h(1).BaseLine.Color = 'none';
    h(end-3).FaceColor  = h(5).FaceColor;
    h(end-2).FaceColor  = h(2).FaceColor;
    h(7).FaceColor  = h(5).FaceColor;
    h(8).FaceColor  = h(2).FaceColor;
    h(end-1).FaceColor  = [0, 0.4470, 0.7410]; % color
    h(end).FaceColor    = [0.6350, 0.0780, 0.1840]	; % color

    title('TIME COMPARISON','FontSize',22,'Interpreter','Latex')
    xlim([min([min(time_fly(i,:)) min(time_transit(i,:)) min(time_drive(i,:))] )-5 90])
    xticks([20 50 80])
    xticklabels({'8:00','8:30','9:00'})
    legend( [h(2) h(3) h(4) h(5) h(6) h(end-1) h(end)],...
        'Time to the station','Waiting time','Warmup time','Boarding/deboarding time','Flying time',...
        'Transit time','Driving time','Location','southwest','Interpreter','Latex')
    set(gca, 'FontSize',14,'FontName','FixedWidthTex','TickLabelInterpreter','latex')
%     save2pdf(['Chicago_Commutes_Time',num2str(i)],nf,600)
    xlswrite('Presentation',vector,'Sheet3','B2:R5')

end

