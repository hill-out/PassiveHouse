function [sphCoords] = roughSunSphCoords(t)
% Roughly calculates the spherical coords of the sun
% 
% t - time [1x3] [M, D, H]
%
% sphCoords - vector of sun angle in spherical coords

Az = 2*pi*t(3)/24-pi; %azimuth

yearD = (t(1)-3.5)*30+t(2); %day of the year
yearAngle = (24)*sin(yearD/365*2*pi)+34; %approx. angle ##please imporve##
El = 2*pi*(yearAngle+sin((t(3)-6)/24*2*pi)*34-34)/360; %elevation

sphCoords = [Az, El, 1];

end