[Pr, nu] = assignPRandNU(wMAT);
[structure] = surfaceDefiner('s');
[q_ht] = rateHeatLoss(wMAT,22,Pr,nu,structure)