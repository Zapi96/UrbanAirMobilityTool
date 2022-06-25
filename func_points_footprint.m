function [x,y] = func_points_footprint(stX,stY,mesh_size)
%function [x,y] = points_footprint(pgon,numPointsIn)
%   This function creates points within the footprint of a building
   
 
% [vx,vy] = boundary(pgon);

inPoints = func_polygrid(stX,stY, mesh_size);
if isempty(inPoints)
    x = [];
    y = [];
else
    x = inPoints(:, 1);
    y = inPoints(:,2);
end

end

