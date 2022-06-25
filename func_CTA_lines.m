function [line] = func_CTA_lines(data)
%[line] = CTA_lines(CTA)
%   This function generates the different lines using the raw data obtained
%   from the matrix CTA
%   INPUT:
%      *CTA:  % Matrix with the data provided by CTA which is classified in
%               the following columns:
%                   -Stop_id
%                   -Stop_name
%                   -Station_name
%                   -Ada
%                   -Red
%                   -Blue
%                   -Green
%                   -Brown
%                   -Purple
%                   -Purple2
%                   -Yellow
%                   -Pink
%                   -Orange
%                   -Location
%
%   OUTPUT:
%      *line:  % Matrix with the same information found in the magtrix CTA
%                but classified depending on the lines

%   The list of colors that defines the metro of Chicago are presented
%   below:
line_color = {'Red','Blue','Green','Brown','Purple','Purple2','Yellow','Pink','Orange'};

%   The stations are not divided depending on the line, but they are
%   presented all together in the same format. As a consequence
for i = 1:length(line_color)
    %   Now the different lines depending on the colors are created
    %   extracting the data from the matrix CTA
    line.(char(line_color(i))).stop_id      = data.CTA.stop_id(ismember(data.CTA.(char(line_color(i))),{'true'}));
    line.(char(line_color(i))).stop_name    = data.CTA.stop_name(ismember(data.CTA.(char(line_color(i))),{'true'}));
    line.(char(line_color(i))).station_name = data.CTA.station_name(ismember(data.CTA.(char(line_color(i))),{'true'}));
    line.(char(line_color(i))).latitude     = data.CTA.latitude(ismember(data.CTA.(char(line_color(i))),{'true'}));
    line.(char(line_color(i))).longitude    = data.CTA.longitude(ismember(data.CTA.(char(line_color(i))),{'true'}));
end
end

