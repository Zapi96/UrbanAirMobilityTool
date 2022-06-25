function [] = func_chicago_heights(buildings)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

for i = 1:20
    patch(buildings.x{i},buildings.y{i},buildings.height(i))
    hold on
end
end

