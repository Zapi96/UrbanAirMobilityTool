
%  COMPARISON DEPENDING ON TERM

feasible_trips_representation(flight,rows,size_point,loc1_short,cond)
str = ['Fly+car vs drive (',num2str(length(loc1_short)),' trips)'];
title({str,'Short term cost'})
saveas(7,'Fig7')
save2pdf(['Fly+transit vs drive (',num2str(length(loc1_short)),' trips) Short cost'],7,600)

feasible_trips_representation(flight,rows,size_point,loc1_long,cond)
str = ['Fly+car vs drive (',num2str(length(loc1_long)),' trips)'];
title({str,'Long term cost'})
saveas(8,'Fig8')
save2pdf(['Fly+car vs transit (',num2str(length(loc1_long)),' trips) Long cost'],8,600)

%  COMPARISON FROM (INITIAL)

cond = commutes.trip.area_from == 1;
feasible_trips_representation(flight,rows,size_point,loc1_short,commutes)
str = ['Fly+car vs drive (',num2str(length(loc1_initial)),' trips)'];
title({str,'Initial cost'})
saveas(9,'Fig9')

save2pdf(['Fly+transit vs drive (',num2str(length(loc1_initial)),' trips) Initial cost (Area1)'],9,600)

cond = commutes.trip.area_from == 1 || commutes.trip.area_from == 2 || commutes.trip.area_from == 77;
feasible_trips_representation(flight,rows,size_point,loc1_short,commutes)
str = ['Fly+car vs drive (',num2str(length(loc1_initial)),' trips)'];
title({str,'Iitial cost'})
saveas(10,'Fig10')

save2pdf(['Fly+transit vs drive (',num2str(length(loc1_initial)),' trips) Initial cost (Area2)'],10,600)

%  COMPARISON TO (INITIAL)

cond = commutes.trip.area_to == 76;
feasible_trips_representation(flight,rows,size_point,loc1_short,commutes)
str = ['Fly+car vs drive (',num2str(length(loc1_short)),' trips)'];
title({str,'Short term cost'})
saveas(11,'Fig11')

save2pdf(['Fly+transit vs drive (',num2str(length(loc1_initial)),' trips) Initial cost (Area3)'],11,600)

cond = commutes.trip.area_to == 8 || commutes.trip.area_to == 32 ;
feasible_trips_representation(flight,rows,size_point,loc1_short,commutes)
str = ['Fly+car vs drive (',num2str(length(loc1_short)),' trips)'];
title({str,'Short term cost'})
saveas(12,'Fig12')

save2pdf(['Fly+transit vs drive (',num2str(length(loc1_initial)),' trips) Initial cost (Area4)'],12,600)
