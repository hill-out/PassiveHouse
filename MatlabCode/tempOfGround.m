function [Tg] = tempOfGround(hour)
% calculates the approximate temperature fo the ground
%
% hour - the current hour since jan 1st
%
% Tg - temperature of the ground

% assuming minimum temperature 10 days before hour = 0
% assuming follows a sinusoidal function from 7 to 12

phi = ((hour+10*24)./8760)*2*pi;

Tg = -cos(phi)*2.5+9.5;

end