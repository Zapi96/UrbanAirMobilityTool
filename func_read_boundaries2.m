function [boundaries] = func_read_boundaries2(boundaries)
%[boundaries] = read_boundaries(boundaries)
%   This function converts the data about the boundaries into a readable
%   format
%   INPUT:
%      *boundaries:    % Table with information of the coordinates of the
%                        boundaries
%
%   OUTPUT:
%      *boundaries:    % Table with information of the coordinates of the
%                        boundaries in the proper format

% The first step consits of dividing the cell of the geometry using the
% spaces
splitcells = regexp(boundaries.geometry,'\d+(\.)?(\d+)?','match');

for i = 1:size(splitcells,1)
    temp(i,:) = {cell2mat(cellfun(@str2num,splitcells{i},'un',0))};
end
boundaries.position_vector = temp;
end

