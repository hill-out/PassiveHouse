function [out, in] = occlusion(sunA, window, f)
% occlusion is a function that calculates how much sun is blocked inside
% and outside
% 
% sunA - sun angle [cart]
% window - vector of the current window [mx9]
% f - inside barriers (0 = no barrier)
% 
% occFactor - occlusion factor [1x2] [in, out]

%% calculate stuff blocking the sun from the outside (shading)

[az,el,~] = cart2sph(sunA(:,1),sunA(:,2),sunA(:,3)); %calc elevation

% Barrier calculation
barrier = window(:,10);

barSpace = 0.300; %m
barWidth = 0.020; %m
barDepth = 0.200; %m


x = barDepth.*tan(ones(size(barrier))*el);

blockage = 1-barrier.*(x+barWidth)./barSpace;
blockage = max([zeros(size(blockage)),min([ones(size(blockage)),blockage]')']')';

blockage(~barrier) = 1;

%% window sink calculation
% relates to the thickness of the wall blocking the sun inside and outside
wallDepth = 0.46; %m

[azW, elW, ~] = cart2sph(window(:,6),window(:,7),window(:,8));
dL = abs(wallDepth/2.*tan(az-azW));
dH = abs(wallDepth/2.*tan(el-elW));

newL = max([zeros(size(window(:,4))),(window(:,4)-dL)]')';
newH = max([zeros(size(window(:,5))),(window(:,5)-dH)]')';
newA = newL.*newH;

A = window(:,4).*window(:,5);
wallOcc = newA./A;
wallOcc = max([zeros(size(wallOcc)), min([ones(size(wallOcc)),(wallOcc)]')']')';

%% room size calculation
% relates to walls stopping the sun hitting the walls

windowBH = 0.5;
hTop = (window(:,5)+windowBH)/tan(el);
hBot = (windowBH)/tan(el);

hTop(hTop>4) = 4;
hBot(hBot>4) = 4;

roomOcc = 1-(hTop-hBot)./4;
roomOcc = max([zeros(size(wallOcc)), min([ones(size(roomOcc)),(roomOcc)]')']')';

%% sum for all
out = wallOcc .* blockage;
in = wallOcc .* roomOcc .* f;
end