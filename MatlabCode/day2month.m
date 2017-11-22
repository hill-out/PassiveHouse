function [m] = day2month(day)

monthDay = [31,28,31,30,31,30,31,31,30,31,30,31];
cM = [0, cumsum(monthDay)];

for i = 1:12
    m.Ti(i) = mean(day.Ti(cM(i)+1:cM(i+1)),1)';
    m.TiMax(i) = max(day.TiMax(cM(i)+1:cM(i+1)),[],1)';
    m.TiMin(i) = min(day.TiMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.To(i) = mean(day.To(cM(i)+1:cM(i+1)),1)';
    m.ToMax(i) = max(day.ToMax(cM(i)+1:cM(i+1)),[],1)';
    m.ToMin(i) = min(day.ToMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qTotal(i) = sum(day.qTotal(cM(i)+1:cM(i+1)),1)';
    m.qTotalMax(i) = max(day.qTotalMax(cM(i)+1:cM(i+1)),[],1)';
    m.qTotalMin(i) = min(day.qTotalMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qHeatTransfer(i) = sum(day.qHeatTransfer(cM(i)+1:cM(i+1)),1)';
    m.qHeatTransferMax(i) = max(day.qHeatTransferMax(cM(i)+1:cM(i+1)),[],1)';
    m.qHeatTransferMin(i) = min(day.qHeatTransferMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qWalls(i) = sum(day.qWalls(cM(i)+1:cM(i+1)),1)';
    m.qWallsMax(i) = max(day.qWallsMax(cM(i)+1:cM(i+1)),[],1)';
    m.qWallsMin(i) = min(day.qWallsMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qWindows(i) = sum(day.qWindows(cM(i)+1:cM(i+1)),1)';
    m.qWindowsMax(i) = max(day.qWindowsMax(cM(i)+1:cM(i+1)),[],1)';
    m.qWindowsMin(i) = min(day.qWindowsMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qTightness(i) = sum(day.qTightness(cM(i)+1:cM(i+1)),1)';
    m.qTightnessMax(i) = max(day.qTightnessMax(cM(i)+1:cM(i+1)),[],1)';
    m.qTightnessMin(i) = min(day.qTightnessMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qMVHR(i) = sum(day.qMVHR(cM(i)+1:cM(i+1)),1)';
    m.qMVHRMax(i) = max(day.qMVHRMax(cM(i)+1:cM(i+1)),[],1)';
    m.qMVHRMin(i) = min(day.qMVHRMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qStack(i) = sum(day.qStack(cM(i)+1:cM(i+1)),1)';
    m.qStackMax(i) = max(day.qStackMax(cM(i)+1:cM(i+1)),[],1)';
    m.qStackMin(i) = min(day.qStackMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qOccupancy(i) = sum(day.qOccupancy(cM(i)+1:cM(i+1)),1)';
    m.qOccupancyMax(i) = max(day.qOccupancyMax(cM(i)+1:cM(i+1)),[],1)';
    m.qOccupancyMin(i) = min(day.qOccupancyMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qSolarAir(i) = sum(day.qSolarAir(cM(i)+1:cM(i+1)),1)';
    m.qSolarAirMax(i) = max(day.qSolarAirMax(cM(i)+1:cM(i+1)),[],1)';
    m.qSolarAirMin(i) = min(day.qSolarAirMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qThermalAir(i) = sum(day.qThermalAir(cM(i)+1:cM(i+1)),1)';
    m.qThermalAirMax(i) = max(day.qThermalAirMax(cM(i)+1:cM(i+1)),[],1)';
    m.qThermalAirMin(i) = min(day.qThermalAirMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.vTotal(i) = mean(day.vTotal(cM(i)+1:cM(i+1)),1)';
    m.vTotalMax(i) = max(day.vTotalMax(cM(i)+1:cM(i+1)),[],1)';
    m.vTotalMin(i) = min(day.vTotalMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.vStack(i) = mean(day.vStack(cM(i)+1:cM(i+1)),1)';
    m.vStackMax(i) = max(day.vStackMax(cM(i)+1:cM(i+1)),[],1)';
    m.vStackMin(i) = min(day.vStackMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.vAC(i) = mean(day.vAC(cM(i)+1:cM(i+1)),1)';
    m.vACMax(i) = max(day.vACMax(cM(i)+1:cM(i+1)),[],1)';
    m.vACMin(i) = min(day.vACMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.vMVHR(i) = mean(day.vMVHR(cM(i)+1:cM(i+1)),1)';
    m.vMVHRMax(i) = max(day.vMVHRMax(cM(i)+1:cM(i+1)),[],1)';
    m.vMVHRMin(i) = min(day.vMVHRMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.bypass(i) = mean(day.bypass(cM(i)+1:cM(i+1)),1)';
    m.bypassMax(i) = max(day.bypassMax(cM(i)+1:cM(i+1)),[],1)';
    m.bypassMin(i) = min(day.bypassMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.A(i) = mean(day.A(cM(i)+1:cM(i+1)),1)';
    m.AMax(i) = max(day.AMax(cM(i)+1:cM(i+1)),[],1)';
    m.AMin(i) = min(day.AMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.Tw(i) = mean(day.Tw(cM(i)+1:cM(i+1)),1)';
    m.TwMax(i) = max(day.TwMax(cM(i)+1:cM(i+1)),[],1)';
    m.TwMin(i) = min(day.TwMin(cM(i)+1:cM(i+1)),[],1)';
    
    m.qHeat(i) = sum(day.qHeat(cM(i)+1:cM(i+1)),1)';
    m.qHeatMax(i) = max(day.qHeatMax(cM(i)+1:cM(i+1)),[],1)';
    m.qHeatMin(i) = min(day.qHeatMin(cM(i)+1:cM(i+1)),[],1)';
    
    
end

end