function [] = thermalGain(dirGain, diffGain, thermalMass, split)
% Calculates the temperature of the thermal mass based on soalr gain
% 
% dirGain - the direct solar gain
% diffGain - the diffuse solar gain
% thermalMass - the info on the thermalMass
% split

if nargin < 3 || isempty(thermalMass)
    thermalMass = surfaceDefiner('t');
    thermalMass = thermalMass{1};
end

if nargin < 4 || is
end