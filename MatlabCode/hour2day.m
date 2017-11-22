function [d] = hour2day(hour)
% takes hourly data to daily
nHour = size(hour.Ti,1);
nDay = floor(nHour/24);
if nDay < 0
    error('not enough hours')
end

%daily
d.Ti = mean(reshape(hour.Ti(1:nDay*24),[],nDay),1)';
d.TiMax = max(reshape(hour.TiMax(1:nDay*24),[],nDay),[],1)';
d.TiMin = min(reshape(hour.TiMin(1:nDay*24),[],nDay),[],1)';

d.To = mean(reshape(hour.To(1:nDay*24),[],nDay),1)';
d.ToMax = max(reshape(hour.ToMax(1:nDay*24),[],nDay),[],1)';
d.ToMin = min(reshape(hour.ToMin(1:nDay*24),[],nDay),[],1)';

d.qTotal = sum(reshape(hour.qTotal(1:nDay*24),[],nDay),1)';
d.qTotalMax = max(reshape(hour.qTotalMax(1:nDay*24),[],nDay),[],1)';
d.qTotalMin = min(reshape(hour.qTotalMin(1:nDay*24),[],nDay),[],1)';

d.qHeatTransfer = sum(reshape(hour.qHeatTransfer(1:nDay*24),[],nDay),1)';
d.qHeatTransferMax = max(reshape(hour.qHeatTransferMax(1:nDay*24),[],nDay),[],1)';
d.qHeatTransferMin = min(reshape(hour.qHeatTransferMin(1:nDay*24),[],nDay),[],1)';

d.qWalls = sum(reshape(hour.qWalls(1:nDay*24),[],nDay),1)';
d.qWallsMax = max(reshape(hour.qWallsMax(1:nDay*24),[],nDay),[],1)';
d.qWallsMin = min(reshape(hour.qWallsMin(1:nDay*24),[],nDay),[],1)';

d.qWindows = sum(reshape(hour.qWindows(1:nDay*24),[],nDay),1)';
d.qWindowsMax = max(reshape(hour.qWindowsMax(1:nDay*24),[],nDay),[],1)';
d.qWindowsMin = min(reshape(hour.qWindowsMin(1:nDay*24),[],nDay),[],1)';

d.qTightness = sum(reshape(hour.qTightness(1:nDay*24),[],nDay),1)';
d.qTightnessMax = max(reshape(hour.qTightnessMax(1:nDay*24),[],nDay),[],1)';
d.qTightnessMin = min(reshape(hour.qTightnessMin(1:nDay*24),[],nDay),[],1)';

d.qMVHR = sum(reshape(hour.qMVHR(1:nDay*24),[],nDay),1)';
d.qMVHRMax = max(reshape(hour.qMVHRMax(1:nDay*24),[],nDay),[],1)';
d.qMVHRMin = min(reshape(hour.qMVHRMin(1:nDay*24),[],nDay),[],1)';

d.qStack = sum(reshape(hour.qStack(1:nDay*24),[],nDay),1)';
d.qStackMax = max(reshape(hour.qStackMax(1:nDay*24),[],nDay),[],1)';
d.qStackMin = min(reshape(hour.qStackMin(1:nDay*24),[],nDay),[],1)';

d.qOccupancy = sum(reshape(hour.qOccupancy(1:nDay*24),[],nDay),1)';
d.qOccupancyMax = max(reshape(hour.qOccupancyMax(1:nDay*24),[],nDay),[],1)';
d.qOccupancyMin = min(reshape(hour.qOccupancyMin(1:nDay*24),[],nDay),[],1)';

d.qSolarAir = sum(reshape(hour.qSolarAir(1:nDay*24),[],nDay),1)';
d.qSolarAirMax = max(reshape(hour.qSolarAirMax(1:nDay*24),[],nDay),[],1)';
d.qSolarAirMin = min(reshape(hour.qSolarAirMin(1:nDay*24),[],nDay),[],1)';

d.qThermalAir = sum(reshape(hour.qThermalAir(1:nDay*24),[],nDay),1)';
d.qThermalAirMax = max(reshape(hour.qThermalAirMax(1:nDay*24),[],nDay),[],1)';
d.qThermalAirMin = min(reshape(hour.qThermalAirMin(1:nDay*24),[],nDay),[],1)';

d.vTotal = mean(reshape(hour.vTotal(1:nDay*24),[],nDay),1)';
d.vTotalMax = max(reshape(hour.vTotalMax(1:nDay*24),[],nDay),[],1)';
d.vTotalMin = min(reshape(hour.vTotalMin(1:nDay*24),[],nDay),[],1)';

d.vStack = mean(reshape(hour.vStack(1:nDay*24),[],nDay),1)';
d.vStackMax = max(reshape(hour.vStackMax(1:nDay*24),[],nDay),[],1)';
d.vStackMin = min(reshape(hour.vStackMin(1:nDay*24),[],nDay),[],1)';

d.vAC = mean(reshape(hour.vAC(1:nDay*24),[],nDay),1)';
d.vACMax = max(reshape(hour.vACMax(1:nDay*24),[],nDay),[],1)';
d.vACMin = min(reshape(hour.vACMin(1:nDay*24),[],nDay),[],1)';

d.vMVHR = mean(reshape(hour.vMVHR(1:nDay*24),[],nDay),1)';
d.vMVHRMax = max(reshape(hour.vMVHRMax(1:nDay*24),[],nDay),[],1)';
d.vMVHRMin = min(reshape(hour.vMVHRMin(1:nDay*24),[],nDay),[],1)';

d.bypass = mean(reshape(hour.bypass(1:nDay*24),[],nDay),1)';
d.bypassMax = max(reshape(hour.bypassMax(1:nDay*24),[],nDay),[],1)';
d.bypassMin = min(reshape(hour.bypassMin(1:nDay*24),[],nDay),[],1)';

d.A = mean(reshape(hour.A(1:nDay*24),[],nDay),1)';
d.AMax = max(reshape(hour.AMax(1:nDay*24),[],nDay),[],1)';
d.AMin = min(reshape(hour.AMin(1:nDay*24),[],nDay),[],1)';

d.Tw = mean(reshape(hour.Tw(1:nDay*24),[],nDay),1)';
d.TwMax = max(reshape(hour.TwMax(1:nDay*24),[],nDay),[],1)';
d.TwMin = min(reshape(hour.TwMin(1:nDay*24),[],nDay),[],1)';

d.qHeat = sum(reshape(hour.qHeat(1:nDay*24),[],nDay),1)';
d.qHeatMax = max(reshape(hour.qHeatMax(1:nDay*24),[],nDay),[],1)';
d.qHeatMin = min(reshape(hour.qHeatMin(1:nDay*24),[],nDay),[],1)';

end