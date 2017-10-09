function [] = windowProject(normW, sun, A)
% calculates the projects area of a window

if nargin < 3
    A = 1;
    if nargin < 2
        error('not enough function inputs')
    end
end

normW = norm(normW);
sun = norm(sun);

angleNS = acos(dot(normW,sun));
angleGS = acos(dot([0,0,1],sun));




end