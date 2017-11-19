function [pvOut] = diffusePanelOut(diffIrr, panels, eff)
% calculates the pv output from diffuse radiation
%
% diffIrr - solar irradiance [mx1]
% t - time [mx3] [M, D, H]
% panels - panelData [pL,pH,NUM,eff,nx,ny,nz] leave empty for surfaceDefiner
% eff - panel efficiency
%
% gain - solar gain for the specified time Wh

if nargin < 4
    eff = 0.197; %0.19
end

if nargin < 3 || isempty(panels)
    % calls surfaceDefiner to get the windowData
    panels = surfaceDefiner('p');
    panels = panels{1};
end

%% percent sky (assuming 180 degree sight)
% requires angle between ground and window
P = panels(:,5:7);

% find n and m
hold1 = size(panels);
nPan = hold1(1);

hold2 = size(diffIrr);
m = hold2(1);

% normalise to length of 1
lW = repmat(sqrt(sum(P.^2,2)),1,3); % magnitude of panel vectors
normP = P./lW; % normalised Windows;

% ground vector
normG = [0,0,1];
normG = repmat(normG',1,nPan);

% ground to panel angle
angleGP = acos(dot(normP',normG));

% percent sky
percSky = (pi-angleGP)./pi;

%% calculates the panel output from diffuse radiation
pvOut = eff.*repmat(percSky,length(diffIrr),1).*repmat(diffIrr,1,nPan).*repmat(prod(panels(:,1:3),2)',length(diffIrr),1);

end