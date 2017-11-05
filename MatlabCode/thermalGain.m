function [] = thermalGain(dirGain, diffGain, thermalMass, cTemp)
% Calculates the temperature of the thermal mass based on soalr gain using
% a 1D heat transfer finite difference method
% 
% dirGain - the direct solar gain
% diffGain - the diffuse solar gain
% thermalMass - the info on the thermalMass
% cTemp - current temperature in each cell

if isempty(thermalMass)
    thermalMass = surfaceDefiner('t');
    thermalMass = thermalMass{1};
end




end