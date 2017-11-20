function [T, qAir] = qThermalStructure(Ti, Tw, qSolar)

h = 2; %convective heat transfer indoors
A = 286.42; %internal walls area
m = 7500;
Cp = 1000;

qAir = 2*286.42*(Tw-Ti);
T = Tw + (qSolar-qAir)/(m*Cp);


end