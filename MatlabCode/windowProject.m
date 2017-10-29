function [pA] = windowProject(W, sun, A)
% Calculates the projects area of a window (or any flat surface)
%
% normW - the normal to the window (cart)
% sun - angle of the sun (cart)
% A - area of the window [default = 1m2]
% [to add ~ factors for thickness of wall/frame]
% [to add ~ blocking factor (trees/hills)]
%
% pA - projected area
%
% sources: https://en.wikipedia.org/wiki/Projected_area (flat rectangle)

% check for correct number of inputs
if nargin < 3
    A = 1;
    if nargin < 2
        error('not enough function inputs')
    end
end

% normalise to length of 1
normW = W/norm(W);
normSun = sun/norm(sun);

% angle calcs
cosAngleNS = dot(normW,normSun); %cos of angle of window normal (N) to sun (S)
cosAngleGS = dot([0,0,1],normSun); %cos of angle of ground normal (G) to sun (S)

% for 1m2 normal to the sun
projAsun = A*cosAngleNS; %@90deg = 1m2, @0deg = 0m2
pA = abs(projAsun/cosAngleGS); %@low angle = big area, @ high angle = 1 area

end