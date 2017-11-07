function [gain] = diffuseSolarGain(diffIrr, windows, g)
% calculates the solar gains
%
% diffIrr - solar irradiance [mx1]
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

%% percent sky (assuming 180 degree sight)
% requires angle between ground and window
W = windows(:,6:8);

% find n and m
hold1 = size(windows);
nWin = hold1(1);

hold2 = size(diffIrr);
m = hold2(1);

% normalise to length of 1
lW = repmat(sqrt(sum(W.^2,2)),1,3); % magnitude of window vectors
normW = W./lW; % normalised Windows;

% ground vector
normG = [0,0,1];
normG = repmat(normG',1,nWin);

% ground to window angle
angleGW = acos(dot(normW',normG));

% percent sky
percSky = (pi-angleGW)./pi;

%% calculates the direct gain from each window
gain = g*repmat(percSky,length(diffIrr),1).*repmat(diffIrr,1,nWin).*repmat(prod(windows(:,4:5),2)',length(diffIrr),1);

end