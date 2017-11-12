function [dO, idO] = outOcclusionFactor(sunAngle, windows)
% calculates how much of blockage of the sun there will be
%
% sunAngle - spherical coordinates
% windows - matrix of windows
%
% dO - direct occulsion
% idO - indirect occulsion

if nargin < 2 || isempty(windows)
    windows = surfaceDefiner('w');
    windows = windows{1};
end

blockage = [0, 0.05;
            90, 0.05;
            100, 0.06;
            110, 0.08;
            120, 0.1;
            130, 0.14;
            140, 0.18;
            150, 0.2;
            160, 0.23;
            170, 0.24;
            240, 0.24;
            250, 0.2;
            260, 0.14;
            270, 0.08;
            280, 0.05;
            360, 0.05];

blockage(blockage(:,1)>180) = blockage(blockage(:,1)>180)-360;
blockage(:,1) = blockage(:,1)*pi/180;
idO = 0.05;




end