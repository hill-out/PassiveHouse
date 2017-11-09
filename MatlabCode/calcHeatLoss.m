clear,clc;
% Main script to calculate total heat losses over time in kWh. 
load('weatherSTRUCT.mat')

[Pr, nu] = assignPRandNU(wSTRUCT.Temp);
[swf] = surfaceDefiner('swf');
[q_ht] = rateHeatLoss(wSTRUCT.Temp,wSTRUCT.WSpeed,22,Pr,nu,swf{1},swf{2},swf{3});

q_ht_total = sum(q_ht,2); % Units: Wh
q_ht_total_day = sum(reshape(q_ht_total,24,365));

q_solar_day = getDailySolarGains;
%load('weatherSTRUCTtry.mat');
%q_solar = overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8);

subplot(3,1,1)
hold on
plot(q_ht_total_day)
plot(q_solar_day)
xlabel('Time (hours)')
ylabel('Rate of Heat Transfer (kW)')
%hold off

q_total_day = q_ht_total_day + q_solar_day;

subplot(3,1,2)
plot(q_total_day)

T = max(reshape(wSTRUCT.Temp,24,365));
subplot(3,1,3)
plot(T)

count_negative = sum(q_total_day<0);
count_positive = sum(q_total_day>0);

total_heat_loss = sum(q_total_day(q_total_day<0))/160;