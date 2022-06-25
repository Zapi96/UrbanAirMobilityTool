function [track_path,distance] = dijkstra(mesh,start,goal,restricted)
%[cells] = dijkstra(mesh,start,goal)
%   This function sets the optimal path for a trip from start to goal

shortest_distance = []; % It records the cost to reach to node.
track_predecessor = []; % It keeps track of path that led to that node.
unseenNodes       = [1:size(mesh.centroid_x,1)]'; % It iterates through all centroids
track_path        = []; % It saves the optimum path

%   INITIALIZATION
%   We will set 0 for the cost of the initial node and infinity to the rest

shortest_distance        = Inf*ones(size(unseenNodes,1),1);
shortest_distance(start) = 0;

%   CALCULATION
%   We will use a loop to check all the nodes.
%   The minimum distance will be set every iteration

while ~isempty(unseenNodes)
    min_distance_node = nan;
    
    for i = 1:length(unseenNodes)
        node = unseenNodes(i);
        if isnan(min_distance_node)
            min_distance_node = node;
        elseif shortest_distance(node) < shortest_distance(min_distance_node)
            min_distance_node = node;
        end
    end
    
    %   Now from the minimum node, we find the possible paths
    path_options.neigbour_number = mesh.cell_neighbours{min_distance_node};
    path_options.distance        = mesh.distance_geo{min_distance_node};
    
     
    
    for i = 1:length(path_options.neigbour_number)
        child_node = path_options.neigbour_number(i);
        if find(child_node==restricted)
            weight = Inf;
        else
            weight     = path_options.distance(i);
        end
        if  weight + shortest_distance(min_distance_node) < shortest_distance(child_node)
            shortest_distance(child_node) = weight + shortest_distance(min_distance_node);
            track_predecessor(child_node) = min_distance_node;
        end
    end
    % Once we have visited this centroids, we have to remove them of the
    % unseenNodes list, so that we don't iterate over them again
    idx = find(unseenNodes==min_distance_node);
    unseenNodes(idx) = [];
    
    
end

%   Now we need to calculate the total cost
currentNode = goal;
while currentNode ~= start
      
    try
        track_path = [currentNode track_path];
        currentNode = track_predecessor(currentNode);
    catch
        print('Path not reachable')
        break
    end
end
track_path = [start track_path];

distance = 0;
for i = 1:length(track_path)-1
    cell = track_path(i);
    neighbour = track_path(i+1);
    idx = mesh.cell_neighbours{cell} == neighbour;
    distance = distance + mesh.distance_geo{cell}(idx);
end

end

