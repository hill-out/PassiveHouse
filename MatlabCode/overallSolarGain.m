function [gain, dirGain, diffGain] = overallSolarGain(globalIrr, diffIrr, t, windows, g)
% computes the overall solar gain from the windows
% 
% globalIrr - the global irradiation [mx1]
% diffIrr - the diffuse irradiation [mx1]
% t - time [M, D, H] [mx3]
% windows - windowData [x,y,z,L,H,nx,ny,nz] leave empty for surfaceDefiner
% g - gain factor [default = 0.8]
%
% gain - the overall solar gain

if nargin < 5
    g = 0.8;
end

if nargin < 4 || isempty(windows)
    % calls surfaceDefiner to get the windowData
    windows = surfaceDefiner('w');
    windows = windows{1};
end

% calculate individual gains
dirGain = directSolarGain(globalIrr-diffIrr, t, windows, g);
diffGain = diffuseSolarGain(diffIrr, windows, g);

% calaulte overall gain
gain = dirGain + diffGain;

end