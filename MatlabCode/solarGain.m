function [] = solarGain(irr, t, windows)
% calculates the solar gains
%
% irr - solar irradiance 
% t - time [mx3] [M, D, H]
% windows - windowData [x,y,z,L,H,nx,ny,nz] leave empty for surfaceDefiner

if nargin < 2 || isempty(windows)
    % calls surfaceDefiner to get the windowData
    windows = surfaceDefiner('w');
end

sunNorm = roughSunSphCoords(t);
windowProject(windows(6:8),sunNorm,prod(windows(4:5)));

end