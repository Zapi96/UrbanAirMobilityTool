function [mesh] = func_cells_connectivity(mesh)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Ncellx = size(mesh.X,2)-1;
Ncelly = size(mesh.Y,1)-1;

cells_u = Ncelly*2:Ncelly:Ncellx*Ncelly-Ncelly;
cells_l = 2:Ncelly-1;
cells_r = (Ncellx-1)*Ncelly+2:Ncellx*Ncelly-1;
cells_d = Ncelly+1:Ncelly:(Ncellx-2)*Ncelly+1;


cells_total = 1:Ncellx*Ncelly;

cells_total([cells_u cells_l cells_d cells_r]) = [];
%
for i = 1:length(cells_l)
    c1 = cells_l(i)-1;
    c2 = cells_l(i)+1;
    c3 = cells_l(i)+Ncelly;
    c4 = c1+Ncelly;
    c5 = c2+Ncelly;
    mesh.cell_neighbours{cells_l(i),1} = [c1 c2 c3 c4 c5];
end

for i = 1:length(cells_d)
    c1 = cells_d(i)+1;
    c2 = cells_d(i)-Ncelly;
    c3 = cells_d(i)+Ncelly;
    c4 = c1-Ncelly;
    c5 = c1+Ncelly;
    mesh.cell_neighbours{cells_d(i),1} = [c1 c2 c3 c4 c5];
end

for i = 1:length(cells_r)
    c1 = cells_r(i)-1;
    c2 = cells_r(i)+1;
    c3 = cells_r(i)-Ncelly;
    c4 = c1-Ncelly;
    c5 = c2-Ncelly;
    mesh.cell_neighbours{cells_r(i),1} = [c1 c2 c3 c4 c5];
end

for i = 1:length(cells_u)
    c1 = cells_u(i)-1;
    c2 = cells_u(i)-Ncelly;
    c3 = cells_u(i)+Ncelly;
    c4 = c1-Ncelly;
    c5 = c1+Ncelly;
    mesh.cell_neighbours{cells_u(i),1} = [c1 c2 c3 c4 c5];
end

for i = 1:length(cells_total)
    c1 = cells_total(i)-1;
    c2 = cells_total(i)+1;
    c3 = cells_total(i)-Ncelly;
    c4 = cells_total(i)+Ncelly;
    c5 = c1-Ncelly;
    c6 = c1+Ncelly;
    c7 = c2-Ncelly;
    c8 = c2+Ncelly;
    mesh.cell_neighbours{cells_total(i),1} = [c1 c2 c3 c4 c5 c6 c7 c8];
end

c1 = 1+1;
c2 = 1+Ncelly;
c3 = c1+Ncelly;
mesh.cell_neighbours{1,1} = [c1 c2 c3 ];

c1 = Ncelly-1;
c2 = Ncelly+Ncelly;
c3 = c1+Ncelly;
mesh.cell_neighbours{Ncelly,1} = [c1 c2 c3 ];

c1 = Ncelly*Ncellx-Ncelly+1+1;
c2 = Ncelly*Ncellx-Ncelly+1-Ncelly;
c3 = c1-Ncelly;
mesh.cell_neighbours{Ncelly*Ncellx-Ncelly+1,1} = [c1 c2 c3 ];

c1 = Ncelly*Ncellx-1;
c2 = Ncelly*Ncellx-Ncelly;
c3 = c1-Ncelly;
mesh.cell_neighbours{Ncelly*Ncellx,1} = [c1 c2 c3 ];


end

