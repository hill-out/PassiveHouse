function [out, in] = occlusion(sunA, window, barrier, furnature)
% occlusion is a function that calculates how much sun is blocked inside
% and outside
% 
% sunA - sun angle [cart]
% window - vector of the current window [mx9]
% barrier - outside barriers [1 = have, 0 = not have] - south facing
% furnature - inside barriers (1 = no barrier)
% refl - reflectance of the surface
% 
% occFactor - occlusion factor [1x2] [in, out]

%% calculate stuff blocking the sun from the outside

[az,el,~] = cart2sph(sunA(:,1),sunA(:,2),sunA(:,3)); %calc elevation

% Barrier calculation

barSpace = 0.300; %m
barWidth = 0.020; %m
barDepth = 0.200; %m

x = barDepth.*tan(ones(size(barrier))*el);

blockage = barrier.*(x+barWidth)./barSpace;
out = max([zeros(size(blockage)),min([ones(size(blockage)),blockage]')']')';

out(~barrier) = 1;

%% calculate stuff blocking indoor light from thermal mass

% Wall calculation
wallDepth = 0.3; %m

[azW, elW, ~] = cart2sph(window(:,6),window(:,7),window(:,8));
dL = abs(wallDepth.*tan(az-azW));
dH = abs(wallDepth.*tan(el-elW));

newL = max([zeros(size(window(:,4))),(window(:,4)-dL)]')';
newH = max([zeros(size(window(:,5))),(window(:,5)-dH)]')';
newA = newL.*newH;

A = window(:,4).*window(:,5);
wallOcc = newA./A;

in = max([zeros(size(wallOcc)), min([ones(size(wallOcc)),(wallOcc.*furnature)]')']')';

end