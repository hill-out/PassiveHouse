function [] = solarGain(irr, t, windows)
% calculates the solar gains
%
% irr - solar irradiance 
% t - time [mx3] [M, D, H]
% windows - windowData [x,y,z,L,H,nx,ny,nz] leave empty for surfaceDefiner

if nargin < 3 || isempty(windows)
    % calls surfaceDefiner to get the windowData
    windows = surfaceDefiner('w');
    windows = windows{1};
end

sunNorm = roughSunSphCoords(t);
sunNorm = vecsph2cart(sunNorm);
winProjA = windowProject(windows(:,6:8),sunNorm,prod(windows(:,4:5),2));

end