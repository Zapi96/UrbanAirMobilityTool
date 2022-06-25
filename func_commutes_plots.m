function [] =func_commutes_plots(commutes,community)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
% clc; clear all; close all;

%%  DATA

% load Data\Data
% load Data\Data_commutes

total_community = sum(commutes.quantity);

[B,I] = sort(total_community,'descend');

order_total_community = B;
order_community_name  = community.Name(I);


% quantity = 0;
% for i = 1:length(order_total_community)
%    quantity = quantity+order_total_community(i);
%    
%    if quantity<0.4*commutes.total_jobs/length(order_total_community)
%        break;
%    end
% end

position = find(order_total_community>0.4*commutes.total_jobs/length(order_total_community));

figure(1)
bar(reordercats(categorical(order_community_name),order_community_name),order_total_community)
xlabel('Community Area')
ylabel('Number of commutes')
hold on
yline(0.4*commutes.total_jobs/length(order_total_community), 'r');
yline(0.5*commutes.total_jobs/length(order_total_community), 'g');
yline(0.6*commutes.total_jobs/length(order_total_community), 'b');
legend('Commutes','60%','50%','40%')


figure(2)
bar(reordercats(categorical(order_community_name(position)),order_community_name(position)),order_total_community(position))
xlabel('Community Area')
ylabel('Number of commutes')
hold on
yline(0.4*commutes.total_jobs/length(order_total_community), 'r');
yline(0.5*commutes.total_jobs/length(order_total_community), 'g');
yline(0.6*commutes.total_jobs/length(order_total_community), 'b');
legend('Commutes','60%','50%','40%')





end

