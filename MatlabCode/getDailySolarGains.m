function [c,a] = getDailySolarGains()

load('weatherSTRUCTtry.mat');
a = overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8);
b = reshape(sum(a,2),24,365);
c = sum(b);

end