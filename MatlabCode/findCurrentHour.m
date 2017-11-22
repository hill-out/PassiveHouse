function [h] = findCurrentHour(t)
% finds the current hour of the year [0 = midnight jan 1st]
%
% t - time [M, D, H]
%
% h

load time.mat


[~,h] = intersect(time,t,'rows');

if numel(h) ~= size(t,1)
    error('time not real')
end

end
