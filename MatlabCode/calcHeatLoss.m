clear,clc;
% Main script to calculate total heat losses over time in kWh. 
load('weatherSTRUCT.mat')

[Pr, nu] = assignPRandNU(wSTRUCT.Temp);
[swf] = surfaceDefiner('swf');
[q_ht] = rateHeatLoss(wSTRUCT.Temp,wSTRUCT.WSpeed,22,Pr,nu,swf{1},swf{2},swf{3});

q_ht_total = sum(q_ht,2); % Units: kWh
q_ht_total_day = sum(reshape(q_ht_total,24,365));

q_solar = getDailySolarGains;

subplot(2,1,1)
hold on
plot(q_ht_total_day)
plot(q_solar)
xlabel('Time (Days)')
ylabel('Rate of Heat Transfer (kW)')
hold off

q_total = q_ht_total_day + q_solar;

subplot(2,1,2)
plot(q_total)



total_heat_loss = sum(q_total(q_total<0))/160