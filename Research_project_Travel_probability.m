clc; close all; clear all;

filename = 'Data Excel/Travel_trends';
trips_to_work_hour = xlsread(filename,'p.14-15 Trips by time of day','B5:B292');
hours              = xlsread(filename,'p.14-15 Trips by time of day','A5:A292');
hours = days(hours);
hours.Format = 'hh:mm';
hours2 = hours + days(0.5/24);

figure()
plot(hours,trips_to_work_hour)
hold on
plot(hours2,trips_to_work_hour)


%% PROBABILITY
close all
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
    probability(i) = {motion_temp/sum(motion_temp)*100};
    motion(i) = {motion_temp};
    hour_temp = 1;
    motion_temp = [];
    J(i) = 2/((m-1)*w(i)/24)-(m+1)/((m-1)*w(i)/24)*(sum((probability{i}/100).^2));
end

figure()
hour_cat = categorical(duration(hours(1:24),'Format','hh:mm'));
for i = length(probability)
    plot(hour_cat,probability{i},'-','Linewidth',2)
    hold on
end
% title('Probability of trips',,'FonSize',20)
% xlabel('Intervals','FonSize',16)
% ylabel('Probability [%]')
xticks(hour_cat(2:2:24))
set(gca,'FontSize',15)

figure()
plot(1:length(w),J)

figure()
hours_interval_plot = [3,6 12];
hours_interval_str = {'15','30', '60'};
for i = 1:length(hours_interval_plot)
    subplot(3,1,i)
    
    bar(probability{hours_interval_plot(i)})
    title(['Intervals of ',hours_interval_str{i},' minutes'])
    
end
ylabel('Probability [%]')

save('Data/Commutes probability/Data_Probability','probability','hour','motion')
% xlswrite('Presentation',[1:24]','Sheet1','A2:A25')
% xlswrite('Presentation',probability{12}','Sheet1','B2:B25')
