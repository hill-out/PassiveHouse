
load('weatherSTRUCTtry.mat')
t=[wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR];
all2 = overallQT(t(1,:),t(end,:),14*24);

save('all2.mat','all2')