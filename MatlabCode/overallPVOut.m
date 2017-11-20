function [pvOut, dirPVO, diffPVO] = overallPVOut(globalIrr, diffIrr, t, panels, eff)
% computes the overall solar gain from the windows
% 
% globalIrr - the global irradiation [mx1]
% diffIrr - the diffuse irradiation [mx1]
% t - time [M, D, H] [mx3]
% panels - panelData [pL,pH,NUM,eff,nx,ny,nz] leave empty for surfaceDefiner
% eff - panel efficiency [default = 0.19]
%
% pvOut - the overall pv output
% dirGain - the direct solar pv out
% diffGain - the diffuse solar pv out

if nargin < 5
    eff = 0.197; %0.19
end

if nargin < 4 || isempty(panels)
    % calls surfaceDefiner to get the windowData
    panels = surfaceDefiner('p');
    panels = panels{1};
end

% calculate individual gains
dirPVO = directPanelOut(globalIrr-diffIrr, t, panels, eff);
diffPVO = diffusePanelOut(diffIrr, panels, eff);

% calaulte overall gain
pvOut = dirPVO + diffPVO;

end