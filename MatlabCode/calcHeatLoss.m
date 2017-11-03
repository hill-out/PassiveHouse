
[Pr, nu] = assignPRandNU(wMAT);
[structure] = surfaceDefiner('s');
[windows] = surfaceDefiner('w');
[q_ht] = rateHeatLoss(wMAT,22,Pr,nu,structure,windows);

