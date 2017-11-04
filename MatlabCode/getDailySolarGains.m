function [c] = getDailySolarGains()

load('weatherSTRUCTtry.mat');
a = overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8);
b = reshape(a(:,3),24,365);
c = sum(b)*20/6;

end