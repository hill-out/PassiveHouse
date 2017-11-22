function [sphCoords] = roughSunSphCoords(t)
% Roughly calculates the spherical coords of the sun
% 
% t - time [nx3] [M, D, H]
% 
% sphCoords - matrix of sun angle in norm spherical coords [Az, El, 1]

Az = 2*pi*t(:,3)/24-pi; %azimuth

yearD = (t(:,1)-3.5)*30+t(:,2); %day of the year
yearAngle = (24)*sin(yearD/365*2*pi)+34; %approx. angle ##please imporve##
El = 2*pi*(yearAngle+sin((t(:,3)-6)/24*2*pi)*34-34)/360; %elevation

sphCoords = [Az, El, ones(1,numel(t)/3)'];

end