function [data,tracts,areas,blocks] = func_read_data(filename)
%function [data,tracts,areas,blocks] = read_data(filename)
%   This function read the data from different filenames
%   INPUT:
%      *filename:    % Vector with different filenames
%
%   OUTPUT:
%      *data:    % Struct with tables of data 
%                   -Commutes: Work geocode, house geocode, number of people 
%                   -Illinois: County, Tract, Tract name, Block, Tract
%                   code, Block code
%                   -Community: Community number, Community name
%                   -Counties: County name, County number
%                   -Tract2community: Community area number, Tract number
%                   -Population_blocks: Geocode, Total population
%                   -Income: Year, Household income, Household income More,
%                    geocode
%                   -CTA: Information of the CTA lines
%      *tracts:  % Tracts with vector of boundaries
%      *areas:   % Areas with vector of boundaries
%      *blocks:  % Blocks with vector of boundaries

filename1  = filename{1};  % Commutes
filename2  = filename{2};  % Illinois
filename3  = filename{3};  % Community
filename4  = filename{4};  % Counties
filename5  = filename{5};  % Tract2community
filename6  = filename{6};  % Population_blocks
filename7  = filename{7};  % Tracts
filename8  = filename{8};  % Areas
filename9  = filename{9};  % CTA
filename10 = filename{10}; % Blocks
filename11 = filename{11}; % Income

%%  IMPORT DATA

%   It reads the filenames and convert them into tables
commutes          = readtable(filename1);
illinois          = readtable(filename2);
community         = readtable(filename3);
counties          = readtable(filename4);
tract2community   = readtable(filename5);
population_blocks = readtable(filename6);
CTA               = readtable(filename9);
income            = readtable(filename11);

%   It removes the unnecessary variables
commutes          = removevars(commutes,{'SA01','SA02','SA03','SE01','SE02','SE03',...
    'SI01','SI02','SI03','createdate'});
illinois          = removevars(illinois,{'state','cnamelong'});
counties          = removevars(counties,{'County_seat','Established','Origin','Etymology','Population','Area','Map'});
tract2community   = removevars(tract2community,{'STUSAB','SUMLEV','COUNTY','COUSUB','PLACE','GEOID2','NAME'});
population_blocks = removevars(population_blocks,{'CENSUSBLOCK'});
income            = removevars(income,{'Year','IDRace','Race','Geography'});
CTA               = removevars(CTA,{'DIRECTION_ID','STATION_DESCRIPTIVE_NAME','MAP_ID'});

%   Rename headers
commutes.Properties.VariableNames(3)       = {'people'};
community.Properties.VariableNames         = {'number','name'};
counties.Properties.VariableNames          = {'name','number'};
tract2community.Properties.VariableNames   = {'area_number','tract'};
population_blocks.Properties.VariableNames = {'geocode','total_population'};
income.Properties.VariableNames(4)         = {'geocode'};
CTA.Properties.VariableNames               = {'stop_id'
    'stop_name'
    'station_name'
    'ada'
    'Red'
    'Blue'
    'Green'
    'Brown'
    'Purple'
    'Purple2'
    'Yellow'
    'Pink'
    'Orange'
    'location'};

data.income            = income;
data.commutes          = commutes;
data.illinois          = illinois;
data.community         = community;
data.counties          = counties;
data.tract2community   = tract2community;
data.population_blocks = population_blocks;
data.CTA               = CTA;

for i = 1:size(data.CTA.location,1)
    str       = char(data.CTA.location(i));
    latitude  = extractBetween(str,'(',',');
    longitude = extractBetween(str,',',')');
    
    data.CTA.latitude(i,1)  = str2double(latitude);
    data.CTA.longitude(i,1) = str2double(longitude);
end

data.tract2community(807:end,:) = [];

%%  TRACTS
tracts = readtable(filename7);
tracts = removevars(tracts,{'NAME10','NAMELSAD10','COMMAREA','NOTES'});
tracts.Properties.VariableNames = {'geometry','state','county','tract','tract_geocode','area_number'};

[tracts] = func_read_boundaries(tracts);

%%  BLOCKS
blocks = readtable(filename10);
blocks = removevars(blocks,{'NAME10','TRACT_BLOC'});
blocks.Properties.VariableNames = {'geometry','state','county','tract','block','geocode'};

[blocks] = func_read_boundaries(blocks);

%%  AREAS
areas = readtable(filename8);
areas = removevars(areas,{'PERIMETER','AREA','COMAREA_','COMAREA_ID','COMMUNITY','AREA_NUM_1','SHAPE_AREA','SHAPE_LEN'});
areas.Properties.VariableNames = {'geometry','area_number'};


[areas] = func_read_boundaries(areas);


end

