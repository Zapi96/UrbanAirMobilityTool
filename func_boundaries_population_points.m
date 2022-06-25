function [outputArg1,outputArg2] = func_boundaries_population_points(community_area,number_vector,type,centroids)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
sz = 20;

switch type
    case 'Blocks'
        minimum = min(community_area(number_vector(1)).blocks_population);
        maximum = max(community_area(number_vector(1)).blocks_population);
        for i = 1:length(number_vector)
            if min(community_area(number_vector(i)).blocks_population)<minimum
                minimum = min(community_area(number_vector(i)).blocks_population);
            end
            if max(community_area(number_vector(i)).blocks_population)<maximum
                maximum = min(community_area(number_vector(i)).blocks_population);
            end
        end
        figure()
        for i = 1:length(number_vector)
            scatter(community_area(number_vector(i)).blocks_x_centroid,community_area(number_vector(i)).blocks_y_centroid,sz,community_area(number_vector(i)).blocks_population,'filled')
            caxis([minimum maximum]);
            colorbar
            hold on
            if strcmp(centroids, 'Centroids')
                plot(community_area(number_vector(i)).C_x,community_area(number_vector(i)).C_y,'kx','MarkerSize',15,'LineWidth',3)
            end
        
        end
        
        colormap('jet')
        hold  off
    case 'Tracts'
        minimum = min(community_area(number_vector(1)).tracts_population);
        maximum = max(community_area(number_vector(1)).tracts_population);
        for i = 1:length(number_vector)
            if min(community_area(number_vector(i)).tracts_population)<minimum
                minimum = min(community_area(number_vector(i)).tracts_population);
            end
            if max(community_area(number_vector(i)).tracts_population)<maximum
                maximum = min(community_area(number_vector(i)).tracts_population);
            end
        end
        figure()
        for i = 1:length(number_vector)
            scatter(community_area(number_vector(i)).tracts_x_centroid,community_area(number_vector(i)).tracts_y_centroid,sz,community_area(number_vector(i)).tracts_population,'filled')
            caxis([minimum maximum]);
            colorbar
            hold on
            if strcmp(centroids, 'Centroids')
                plot(community_area(number_vector(i)).C_x,community_area(number_vector(i)).C_y,'kx','MarkerSize',15,'LineWidth',3)
            end
        end
        
        colormap('jet')
        hold  off
end

