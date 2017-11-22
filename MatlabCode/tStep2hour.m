function [h] = tStep2hour(data)
% takes tStep data to hourly

%hourly
h.Ti = mean(data.Ti')';
h.TiMax = max(data.Ti')';
h.TiMin = min(data.Ti')';

h.To = mean(data.To')';
h.ToMax = max(data.To')';
h.ToMin = min(data.To')';

h.qTotal = mean(data.qTotal')';
h.qTotalMax = max(data.qTotal')';
h.qTotalMin = min(data.qTotal')';

h.qHeatTransfer = mean(data.qHeatTransfer')';
h.qHeatTransferMax = max(data.qHeatTransfer')';
h.qHeatTransferMin = min(data.qHeatTransfer')';

h.qWalls = mean(data.qWalls')';
h.qWallsMax = max(data.qWalls')';
h.qWallsMin = min(data.qWalls')';

h.qWindows = mean(data.qWindows')';
h.qWindowsMax = max(data.qWindows')';
h.qWindowsMin = min(data.qWindows')';

h.qFoundation = mean(data.qFoundation')';
h.qFoundationMax = max(data.qFoundation')';
h.qFoundationMin = min(data.qFoundation')';

h.qTightness = mean(data.qTightness')';
h.qTightnessMax = max(data.qTightness')';
h.qTightnessMin = min(data.qTightness')';

h.qMVHR = mean(data.qMVHR')';
h.qMVHRMax = max(data.qMVHR')';
h.qMVHRMin = min(data.qMVHR')';

h.qStack = mean(data.qStack')';
h.qStackMax = max(data.qStack')';
h.qStackMin = min(data.qStack')';

h.qOccupancy = mean(data.qOccupancy')';
h.qOccupancyMax = max(data.qOccupancy')';
h.qOccupancyMin = min(data.qOccupancy')';

h.qSolarAir = mean(data.qSolarAir')';
h.qSolarAirMax = max(data.qSolarAir')';
h.qSolarAirMin = min(data.qSolarAir')';

h.qThermalAir = mean(data.qThermalAir')';
h.qThermalAirMax = max(data.qThermalAir')';
h.qThermalAirMin = min(data.qThermalAir')';

h.vTotal = mean(data.vTotal')';
h.vTotalMax = max(data.vTotal')';
h.vTotalMin = min(data.vTotal')';

h.vStack = mean(data.vStack')';
h.vStackMax = max(data.vStack')';
h.vStackMin = min(data.vStack')';

h.vAC = mean(data.vAC')';
h.vACMax = max(data.vAC')';
h.vACMin = min(data.vAC')';

h.vMVHR = mean(data.vMVHR')';
h.vMVHRMax = max(data.vMVHR')';
h.vMVHRMin = min(data.vMVHR')';

h.bypass = mean(data.bypass')';
h.bypassMax = max(data.bypass')';
h.bypassMin = min(data.bypass')';

h.A = mean(data.A')';
h.AMax = max(data.A')';
h.AMin = min(data.A')';

h.Tw = mean(data.Tw')';
h.TwMax = max(data.Tw')';
h.TwMin = min(data.Tw')';

h.qHeat = mean(data.qHeat')';
h.qHeatMax = max(data.qHeat')';
h.qHeatMin = min(data.qHeat')';

end