function [q_ht_total] = overallHeatLoss(wMAT)

[Pr, nu] = assignPRandNU(wMAT);
[structure] = surfaceDefiner('s');
[windows] = surfaceDefiner('w');
[foundation] = surfaceDefiner('f');
[q_ht] = rateHeatLoss(wMAT,22,Pr,nu,structure,windows,foundation);

q_ht_total = sum(q_ht,2);

end
