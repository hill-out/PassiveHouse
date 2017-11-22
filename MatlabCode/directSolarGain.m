function [gain] = directSolarGain(dirIrr, t, windows, g)
% calculates the solar gains
%
% dirIrr - solar irradiance [mx1]
% t - time [mx3] [M, D, H]
% windows - windowData [x,y,z,L,H,nx,ny,nz] leave empty for surfaceDefiner
% g - gain factor [default = 0.8]
%
% gain - solar gain for the specified time Wh

if nargin < 4
    g = 0.8;
end

if nargin < 3 || isempty(windows)
    % calls surfaceDefiner to get the windowData
    windows = surfaceDefiner('w');
    windows = windows{1};
end

% calculates the projected area of each window
sunNorm = sunSphCoords(t);
sunNorm = vecsph2cart(sunNorm);
winProjA = windowProject(windows(:,6:8),sunNorm,prod(windows(:,4:5),2));

% calculates the direct gain from each window
hold = size(windows);
nWin = hold(1);
gain = g*winProjA.*repmat(dirIrr,1,nWin);

end