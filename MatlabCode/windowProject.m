function [pA] = windowProject(W, S, A)
% Calculates the projects area of a window (or any flat surface)
%
% normW - the normal to the window (cart) [nx3]
% sun - angle of the sun (cart) [mx3]
% A - area of the window [default = 1m2] [nx1]
% [to add ~ factors for thickness of wall/frame]
% [to add ~ blocking factor (trees/hills)]
%
% pA - projected area [mxn]
%
% sources: https://en.wikipedia.org/wiki/Projected_area (flat rectangle)

% check for correct number of inputs
if nargin < 3
    A = 1;
    if nargin < 2
        error('not enough function inputs')
    end
end

% find n and m
hold1 = size(W);
n = hold1(1);

hold2 = size(S);
m = hold2(1);

% make A the length of the number of windows
if numel(A) ~= n
    if numel(A) ~= 1
        warning('number of areas doesnt match the number of windows, using A = 1')
        A = 1;
    end
    A = ones(n,1)*A(1);
elseif all(size(A) == [1,n])
    A = reshape(A,[n,1]);
end

% normalise to length of 1
lW = repmat(sqrt(sum(W.^2,2)),1,3); % magnitude of window vectors
normW = W./lW; % normalised Windows
normW = repmat(normW,1,1,m);
normW = permute(normW,[2,3,1]); %reshape for angle calc

lS = repmat(sqrt(sum(S.^2,2)),1,3); % magnitude of sun vectors
normS = S./lS; % normalised Sun
normS = repmat(normS,1,1,n);
normS = permute(normS,[2,1,3]); %reshape for angle calc

normG = [0,0,1];
normG = repmat(normG',1,m,n);


% angle calcs
cosAngleNS = permute(dot(normW,normS),[2,3,1]); %cos of angle of window normal (N) to sun (S)
cosAngleGS = permute(dot(normG,normS),[2,3,1]); %cos of angle of ground normal (G) to sun (S)

% for 1m2 normal to the sun
projAsun = cosAngleNS.*repmat(A,1,m)'; %@90deg = 1m2, @0deg = 0m2
pA = (projAsun./cosAngleGS); %@low angle = big area, @ high angle = 1 area



end