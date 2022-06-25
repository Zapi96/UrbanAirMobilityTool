function [] = func_feasible_trips_representation_total_animated(filename,community_area,flight,lines,centroids,UAMstops,cond,indx,label,hour,step,time,type,map,size_point)
%function [] = feasible_trips_representation(flight,rows,size_point,loc,commutes)
%   This function represents the trips on a Map when the trips are
%   compared just to all the legs. It is showing yhe absolut result.
%   INPUT:
%      *flight:     % Table with information about the flights
%      *size_point: % Size of the points represented in the plot
%      *indx:       % Among the randomly selected trips specified by row,
%                   % loc establishes the position of the chosen ones
%      *commutes:   % The table commutes is used to select especific areas
%      *label       % This label specifies the type of trip that we want to
%                     represent
%      *hour        % With hour we can select the time of the day

%   LOADING DATA
%   The first step consists of loading the data about the boundaries and
%   the metro lines

%   BOUNDARIES
%   We can now plot the areas of the city without the stations of the L
[p,labels] = func_boundaries_plot(community_area,lines,size_point,centroids,UAMstops,type,map);

hold on
%   Now the index for the selected type are chosen:
indexs = indx(hour).(char(label));
if ~isempty(cond)
    indexs = intersect(indexs,cond);
end
curve1 =animatedline('Color',[0, 0.4470, 0.7410],'LineStyle','-.','LineWidth',1.5);
curve2 =animatedline('Color','k','LineStyle','-.','LineWidth',1.5);
curve3 =animatedline('Color',[0.8500, 0.3250, 0.0980],'LineStyle','-.','LineWidth',1.5);
indexs = indexs(randperm(length(indexs)));

%% Initialize video
myVideo = VideoWriter('myVideoFile'); %open video file
myVideo.FrameRate = 1;  %can adjust this, 5 - 10 works well for me
open(myVideo)


if strcmpi(type,'ecef')
    %   We must check that the vector loc is not empty
    if ~isempty(indexs)
        for i = 1:length(indexs)
            
            %   Each values of loc represents one commute, so we must generate a
            %   for with the length of loc
            %   The next step consists of representing the origin and
            %   destination of the trips
            plot(flight.origin_x(indexs(i)),flight.origin_y(indexs(i)),'cx','MarkerSize',8,'LineWidth',2,'DisplayName','Origin');
            for j = 1:step
                x = linspace(flight.origin_x(indexs(i)),flight.origin_UAMstops_x(indexs(i)),step)';
                y = linspace(flight.origin_y(indexs(i)),flight.origin_UAMstops_y(indexs(i)),step)';
                addpoints(curve1,x(j),y(j));
                %         drawnow
                pause(time)
            end
            for j = 1:step
                x = linspace(flight.origin_UAMstops_x(indexs(i)),flight.destination_UAMstops_x(indexs(i)),step)';
                y = linspace(flight.origin_UAMstops_y(indexs(i)),flight.destination_UAMstops_y(indexs(i)),step)';
                addpoints(curve2,x(j),y(j));
                %         drawnow
                pause(time)
            end
            for j = 1:step
                x = linspace(flight.destination_UAMstops_x(indexs(i)),flight.destination_x(indexs(i)),step)';
                y = linspace(flight.destination_UAMstops_y(indexs(i)),flight.destination_y(indexs(i)),step)';
                addpoints(curve3,x(j),y(j));
                %         drawnow
                pause(time)
            end
            plot(flight.destination_x(indexs(i)),flight.destination_y(indexs(i)),'gx','MarkerSize',8,'LineWidth',2,'DisplayName','Destination');
            pause(time*10)
            
            curve1 =animatedline('Color','c','LineStyle','-.','LineWidth',2);
            curve2 =animatedline('Color','k','LineStyle','-.','LineWidth',2);
            curve3 =animatedline('Color','g','LineStyle','-.','LineWidth',2);
            
        end
        %
    end
else
    if ~isempty(indexs)
        for i = 1:25
            %   Each values of loc represents one commute, so we must generate a
            %   for with the length of loc
            %   The next step consists of representing the origin and
            %   destination of the trips
            geoplot(flight.origin_lat(indexs(i)),flight.origin_lon(indexs(i)),'x','MarkerSize',9,'LineWidth',1.5,'DisplayName','Origin','color',[0, 0.4470, 0.7410]);
            for j = 1:step/2
                x = linspace(flight.origin_lat(indexs(i)),flight.origin_UAMstops_lat(indexs(i)),step/2)';
                y = linspace(flight.origin_lon(indexs(i)),flight.origin_UAMstops_lon(indexs(i)),step/2)';
                addpoints(curve1,x(j),y(j));
                %         drawnow
                pause(time)% Capture the plot as an image
                frame = getframe;
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
%                 Write to the GIF File
                if i == 1
                    imwrite(imind,cm,filename,'gif','DelayTime',1, 'Loopcount',inf);
                else
                    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time);
                end
               
            end
            for j = 1:step
                x = linspace(flight.origin_UAMstops_lat(indexs(i)),flight.destination_UAMstops_lat(indexs(i)),step)';
                y = linspace(flight.origin_UAMstops_lon(indexs(i)),flight.destination_UAMstops_lon(indexs(i)),step)';
                addpoints(curve2,x(j),y(j));
                %         drawnow
                pause(time)
                % Capture the plot as an image
                frame = getframe;
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
                % Write to the GIF File
%                 if i == 1
%                     imwrite(imind,cm,filename,'gif','DelayTime',1, 'Loopcount',inf);
%                 else
                    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time);
%                 end
            end
            for j = 1:step/2
                x = linspace(flight.destination_UAMstops_lat(indexs(i)),flight.destination_lat(indexs(i)),step/2)';
                y = linspace(flight.destination_UAMstops_lon(indexs(i)),flight.destination_lon(indexs(i)),step/2)';
                addpoints(curve3,x(j),y(j));
                %         drawnow
                pause(time)
                % Capture the plot as an image
                frame = getframe;
                im = frame2im(frame);
                [imind,cm] = rgb2ind(im,256);
                % Write to the GIF File
%                 if i == 1
%                     imwrite(imind,cm,filename,'gif','DelayTime',1, 'Loopcount',inf);
%                 else
                    imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time);
%                 end
            end
            geoplot(flight.destination_lat(indexs(i)),flight.destination_lon(indexs(i)),'x','MarkerSize',9,'LineWidth',1.5,'DisplayName','Destination','color',[0.8500, 0.3250, 0.0980]);
            pause(time)
            
            curve1 =animatedline('Color',[0, 0.4470, 0.7410],'LineStyle','-.','LineWidth',1.5);
            curve2 =animatedline('Color','k','LineStyle','-.','LineWidth',1.5);
            curve3 =animatedline('Color',[0.8500, 0.3250, 0.0980],'LineStyle','-.','LineWidth',1.5);
            
            % Capture the plot as an image
            frame = getframe;
            im = frame2im(frame);
            [imind,cm] = rgb2ind(im,256);
            % Write to the GIF File
%             if i == 1
%                 imwrite(imind,cm,filename,'gif','DelayTime',1, 'Loopcount',inf);
%             else
                imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',time);
%             end
            frame = getframe(gcf); %get frame
            writeVideo(myVideo, frame);
        end
    end
end

end




