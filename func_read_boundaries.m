function [boundaries] = func_read_boundaries(boundaries)
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
splitcells = regexp(boundaries.geometry, '\s+', 'split');

for i = 1:length(splitcells)
    % Now a temporal vector is created with the values of the cells
    % previously divided expression
    temp = char(splitcells{i,1});
    % The first row with the word MULTIPOLYGON is removed
    temp(1,:) = [];
    % The special characters like ( or , are removed in the following lines
    % and the final value of the coordinate is saved in the variable position
    % in a double format
    sz = size(temp);
    for j = 1:sz(1)
        if contains(temp(j,:), '(')
            new_vector = temp(j,:);
            new_vector = erase(new_vector,'(');
            new_vector = erase(new_vector,',');
            new_vector = erase(new_vector,' ');
            position(j) = str2double(new_vector);
        elseif contains(temp(j,:), ')')
            new_vector = temp(j,:);
            new_vector = erase(new_vector,')');
            new_vector = erase(new_vector,',');
            new_vector = erase(new_vector,' ');
            position(j) = str2double(new_vector);
        else
            new_vector = temp(j,:);
            new_vector = erase(new_vector,' ');
            new_vector = erase(new_vector,',');
            position(j) = str2double(new_vector);
        end
    end
    % The value of the position vector with the coordinates is assigned to
    % each boundary and then is deleted for the next iteration
    boundaries.position_vector{i,1} = position';
    position = [];
end

end

