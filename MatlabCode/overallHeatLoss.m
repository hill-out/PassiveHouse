function [q_ht_total] = overallHeatLoss(wSTRUCT)

[Pr, nu] = assignPRandNU(wSTRUCT);
[structure] = surfaceDefiner('s');
[windows] = surfaceDefiner('w');
[foundation] = surfaceDefiner('f');
[q_ht] = rateHeatLoss(wSTRUCT,22,Pr,nu,structure,windows,foundation);

q_ht_total = sum(q_ht,2);

end
