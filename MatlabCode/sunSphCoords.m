function [sphCoords] = sunSphCoords(t)
% An improvement on roughSunSphCoords but works the same
% 
% t - time [nx3] [M, D, H]
% 
% sphCoords - matrix of sun angle in norm spherical coords [Az, El, 1]

%% first calculate the declination of the sun
% source: https://en.wikipedia.org/wiki/Position_of_the_Sun#Declination_of_the_Sun_as_seen_from_Earth

d2r = 2*pi/360;

% date to number
hold1 = size(t);
nDates = hold1(1);

dateNum = zeros(nDates,length('yyyy-dd-mm HH:MM:SS'));

for i = 1:nDates
    dateNum(i,:) = sprintf('2008-%02d-%02d %02d:00:00',t(i,1),t(i,2),t(i,3));
end

% convert date to number
yearStart = datenum('2008-01-01');
N = (datenum(char(dateNum)) - yearStart); %days since start of year

declination = -asin(0.39779*cos((2*pi/365.24)*(N+10)+0.0334*sin((2*pi/365.24)*(N-2))));

%% second calculate the solarTime (hour angle)
% source: https://www.physicsforums.com/threads/finding-hour-angle.371695/

locLong = -3.189; %degrees

B = (N-1)*360/365.24;
E = 229.2*(0.000075+0.001868*cos(B)-0.032077*sin(B)-0.014615*cos(2.*B)...
    -0.04089*sin(2.*B));

solarTime = ((t(:,3)-12)*15+4*(locLong)+E)*2*pi/360; %in radians

%% third solar Zenith angle
% source: https://en.wikipedia.org/wiki/Solar_zenith_angle

locLat = 56.074*d2r;
zenith = acos(sin(declination).*sin(locLat)+cos(locLat).*cos(declination).*cos(solarTime));
zenith = mod((zenith+(pi)),2*pi)-(pi);

%% fourth solar Azimuth angle
% source: https://en.wikipedia.org/wiki/Solar_azimuth_angle

azimuth = asin((-sin(solarTime).*cos(declination))./(sin(zenith)));
azimuth = mod((azimuth+(pi/2)),pi)-(pi/2);

%% final setup output
% elevation = pi/2 - zenith
sphCoords = [azimuth, pi/2-zenith, ones(nDates,1)];
end