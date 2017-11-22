function analyseData()

load('hotWeek.mat')

h = tStep2hour(hotWeek);
d = hour2day(h);

createfigure_airHeatLoss([0:167],[-h.qWalls,-h.qWindows,h.qFoundation,-h.qTightness,-h.qMVHR,-h.qStack]);

createfigure_airPassiveHeatGain([0:167],[h.qSolarAir,h.qThermalAir],[h.qOccupancy])

figure
hold on
t = [0:167];
plot(t, [-h.qWalls-h.qWindows-h.qTightness-h.qMVHR-h.qStack, h.qSolarAir + h.qThermalAir + h.qOccupancy,h.qHeat,h.qTotal]);

figure
hold on
plot([0:167],h.Ti)
setPoint = [0:7,7:23,23];
Tmax = [4*ones(size(0:7)),2*ones(size(7:23)),4*ones(size(23))];
Tmin = [20*ones(size(0:7)),22*ones(size(7:23)),20*ones(size(23))];

setPoint = repmat(setPoint,[1,8]) + 24*reshape(repmat([0:7],[26,1]),1,[]);
Tmax = repmat(Tmax,[1,8]);
Tmin = repmat(Tmin,[1,8]);

h = area(setPoint,[Tmin;Tmax]');
h(1).FaceAlpha = 0;
h(1).LineStyle = 'none';
h(2).FaceAlpha = 0.1;
h(2).LineStyle = ':';
h(2).FaceColor = [0.2,0.2,0.8];
xlim([0,7*24])
ylim([19,26])



end