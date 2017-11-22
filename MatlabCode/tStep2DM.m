function [h] = tStep2hour(data)
% takes tStep data to hourly, daily and monthly monthly
monthDay = [31,28,31,30,31,30,31,31,30,31,30,31];
cM = [0, cumsum(monthDay)];

%hourly
h.TiMean = mean(data.Ti(:,:),2);
h.TiMax = max(data.Ti(:,:),2);
h.TiMin = min(data.Ti(:,:),2);

h.ToMean = mean(data.To(:,:),2);
h.ToMax = max(data.To(:,:),2);
h.ToMin = min(data.To(:,:),2);

h.qTotal = sum(data.qTotal)*3600/size(data.t,2);




d.TiMean = mean(reshape(h.TiMean,[],365));
a = zeros(31,12);


end