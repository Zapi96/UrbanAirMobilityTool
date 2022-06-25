function [community_area] = func_income(data,community_area,selected_county)
%[communtiy_area] = income(data,community_area,selected_county)
%   This function assignes the mean income of each tract to the information
%   of that tract. This information is the saved in the matrix
%   community_area.
%   INPUT:
%      *data:           % Matrix with data about the icome
%      *selected_county:% Selected county
%      *community_area: % Main matrix with most of the information%   
%   OUTPUT:
%      *community_area: % Main matrix with most of the information and
%                         now with the information of the income

%%  DATA
%   The data about the income mast be extracted from data.income
income_amount = data.income.HouseholdIncomeByRace(data.income.IDYear == 2013);
income_tract  = data.income.geocode(data.income.IDYear == 2013);
income_tract  = char(income_tract);
income_county = str2num(income_tract(:,11:12));
income_tract  = str2num(income_tract(:,13:18));

%   The counties different to the one selected must be removed
income_amount(income_county~=selected_county) = [];
income_tract(income_county~=selected_county)  = [];

%   According to the US government working hours
working_hours = 2087;

k = 0;
for i = 1:length(data.community.number)
    %   We select the tracts that are in an area
    tracts_area = data.tract2community.tract(i==data.tract2community.area_number);
    for j = 1:length(tracts_area)
       %    First the selected area is saved
       income.area(k+j)   = i;
       %    Then the tracts are also saved
       income.tract(k+j)  = tracts_area(j);
       %    The given tract is searched in the community_area matrix
       loc = find(community_area(i).tracts_id == tracts_area(j), 1);
       %    Now we must save the income
       if ~isempty(find(income_tract == tracts_area(j), 1))
           community_area(i).tracts_income(loc,1) = income_amount(income_tract == tracts_area(j));
           community_area(i).tracts_income_hour(loc,1) = income_amount(income_tract == tracts_area(j))/working_hours;
           income.amount(k+j) = income_amount(income_tract == tracts_area(j));
       else 
           community_area(i).tracts_income(loc,1) = 0;
           community_area(i).tracts_income_hour(loc,1) = 0;
           income.amount(k+j) = 0;
       end
    end
    community_area(i).areas_income = sum(community_area(i).tracts_income)/j;
    community_area(i).areas_income_hour = community_area(i).areas_income/working_hours;
    %   The value of k is increased to start after the last value of j
    k = k+j; 
end

end

