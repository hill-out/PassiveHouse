
[Pr, nu] = assignPRandNU(wMAT);
[structure] = surfaceDefiner('s');
[windows] = surfaceDefiner('w');
[q_ht] = rateHeatLoss(wMAT,22,Pr,nu,structure,windows);

q_ht_total = sum(q_ht,2);

plot(q_ht_total)