%inPoints = getPolygonGrid(xv,yv,ppa) returns points that are within a
%concave or convex polygon using the inpolygon function.

%xv and yv are columns representing the vertices of the polygon, as used in
%the Matlab function inpolygon

%ppa refers to the points per unit area you would like inside the polygon.
%Here unit area refers to a 1.0 X 1.0 square in the axes.

%Example:
% L = linspace(0,2.*pi,6); xv = cos(L)';yv = sin(L)'; %from the inpolygon documentation
% inPoints = getPolygonGrid(xv, yv, 10^5)
% plot(inPoints(:, 1),inPoints(:,2), '.k');

function [inPoints] = func_polygrid( xv, yv, ppa)

N = sqrt(ppa);
%Find the bounding rectangle
% 	lower_x = min(xv);
% 	higher_x = max(xv);
%     dif_x = distance(higher_x-lower_x);
%
% 	lower_y = min(yv);
% 	higher_y = max(yv);
%     dif_y = abs(higher_y-lower_y);

north = max(yv);
south = min(yv);
east  = max(xv);
west  = min(xv);


latitude  = [north,north,south,south];
longitude = [east,west,east,west];

wgs84 = wgs84Ellipsoid('meter');

distancelon1 = distance(latitude(1),longitude(1),latitude(2),longitude(2),wgs84);
distancelon2 = distance(latitude(3),longitude(3),latitude(4),longitude(4),wgs84);
distancelat3 = distance(latitude(1),longitude(1),latitude(3),longitude(3),wgs84);
distancelat4 = distance(latitude(2),longitude(2),latitude(4),longitude(4),wgs84);

dif_x = max([distancelon1,distancelon2]);
dif_y = max([distancelat3,distancelat4]);

%Create a grid of points within the bounding rectangle
% 	inc_x = 1/N;
% 	inc_y = 1/N;
inc_x = ceil(dif_x/ppa);
inc_y = ceil(dif_y/ppa);

% 	interval_x = lower_x:inc_x:higher_x;
% 	interval_y = lower_y:inc_y:higher_y;
interval_x = linspace(west,east,inc_x*2+1);
interval_y = linspace(south,north,inc_y*2+1);
[bigGridX, bigGridY] = meshgrid(interval_x, interval_y);

%Filter grid to get only points in polygon
in = inpolygon(bigGridX(:), bigGridY(:), xv, yv);
%Return the co-ordinates of the points that are in the polygon
inPoints = [bigGridX(in), bigGridY(in)];

end

