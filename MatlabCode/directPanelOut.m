function [pvOut] = directPanelOut(dirIrr, t, panels, eff)
% calculates the solar gains
%
% dirIrr - solar irradiance [mx1]
% t - time [mx3] [M, D, H]
% panels - panelData [pL,pH,NUM,eff,nx,ny,nz] leave empty for surfaceDefiner
% eff - panel efficiency
%
% gain - solar gain for the specified time Wh

if nargin < 4
    eff = 0.19;
end

if nargin < 3 || isempty(panels)
    % calls surfaceDefiner to get the windowData
    panels = surfaceDefiner('p');
    panels = panels{1};
end

% calculates the projected area on the solar panels
sunNorm = sunSphCoords(t);
sunNorm = vecsph2cart(sunNorm);
panProjA = panelProject(panels(:,5:7),sunNorm,prod(panels(:,1:3),2));

% calculates the direct solar energy
hold = size(panels);
nPan = hold(1);
pvOut = eff.*panProjA.*repmat(dirIrr,1,nPan);

end
