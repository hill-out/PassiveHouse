load('weatherSTRUCTdsy.mat')
t=[wSTRUCTdsy.MONTH,wSTRUCTdsy.DAY,wSTRUCTdsy.HOUR];

dailyTotalT = sum(reshape(wSTRUCTdsy.Temp,[],365));
weeklyTotalT = sum(reshape(dailyTotalT(1:364),[],52));

tCold = find(weeklyTotalT == min(weeklyTotalT));
tHot = find(weeklyTotalT == max(weeklyTotalT));

%coldWeek = overallQT(t(tCold*24*7+1,:),t((tCold)*24*7+24,:),28*24);
hotWeek = overallQT(t(tHot*24*7+1,:),t((tHot)*24*7+24,:),28*24);

save('coldWeek.mat','coldWeek')
save('hotWeek.mat','hotWeek')