function [sphCoords] = roughSunSphCoords(M,D,H)
% Roughly calculates the spherical coords of the sun

Az = 2*pi*H/24-pi;

yearD = (M-3.5)*30+D;
yearAngle = (24)*sin(yearD/365*2*pi)+34;
El = 2*pi*(yearAngle+sin((H-6)/24*2*pi)*34-34)/360;

sphCoords = [Az, El, 1];

end