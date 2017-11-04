% Main script to calculate total heat losses over time in kWh. 

[Pr, nu] = assignPRandNU(wMAT);
[structure] = surfaceDefiner('s');
[windows] = surfaceDefiner('w');
[q_ht] = rateHeatLoss(wMAT,22,Pr,nu,structure,windows);

q_ht_total = sum(q_ht,2)./1000; % Units: kWh
q_ht_total_day = sum(reshape(q_ht_total,24,365));

plot(q_ht_total_day)
xlabel('Time (Days)')
ylabel('Rate of Heat Transfer (kW)')


total_heat_loss = sum(q_ht_total)/160