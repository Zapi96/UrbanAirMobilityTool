clc; clear all;


x = num2cell([1:365]'.*ones(365,700));
y = num2cell(repmat([1:700],365,1));

z = cellfun(@(x,y)x*y,x,y,'un',false);