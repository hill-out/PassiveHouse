function [q, V] = stackVent(T_i,T_o,U)
%T_i = 24;
%T_o = wSTRUCT.Temp;
%U = wSTRUCT.WSpeed;
U = zeros(size(T_o,1),1);

%Inlet (z1 and z2) and oulet (z3) heights:
z = [1.25, 4.125, 6.5]; 
A = [2, 2, 1.8];

Cp = [0.25, 0.25, -0.1]; 
Cd = [0.61, 0.61, 0.61];
S = [1, 1, -1];

rho = 1.2; %Reference Density
g = 9.81; %Gravity

delta_rho = ((T_i - T_o)./(T_o + 273)).*rho;

delta_Po = ((delta_rho.*g.*(z(3)+z(2)))-(0.5.*rho.*(U.^2).*(Cp(3)+Cp(1))))/2;

delta_P = zeros(8760,3);
for i = 1:1:3
    delta_P(:,i) = delta_Po - (delta_rho.*g.*z(i)) + (0.5.*rho.*(U.^2).*Cp(i));
end

V = Cd(3).*A(3).*S(3).*(sqrt((2.*abs(delta_P(:,3)))./rho)); 

V(V > 0) = 0;

q = ((abs(V*(60^2)).*rho).*(1).*(T_o-T_i))/3.6;

