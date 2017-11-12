clear,clc;
% Main script to calculate total heat losses over time in kWh. 
load('weatherSTRUCT.mat')

[Pr, nu] = assignPRandNU(wSTRUCT.Temp);
[swf] = surfaceDefiner('swf');

T_i = 22; %Define indoor air temperature

%Thermal Losses:

[q_ht] = sum(rateHeatLossHT(wSTRUCT.Temp,wSTRUCT.WSpeed,T_i,Pr,nu,swf{1},swf{2},swf{3}),2);
[q_ac] = rateHeatLossAC(T_i,wSTRUCT.Temp,swf{3});
[q_MVHR] = rateHeatLossMVHR(wSTRUCT.Temp,T_i,240,0.9);
[q_MVHRbypass] = rateHeatLossMVHRbypass(wSTRUCT.Temp,T_i,240);

%Thermal Gains: 
load('weatherSTRUCTtry.mat');
%a = overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8);
%b = reshape(sum(a,2),24,365);
%c = sum(b);
[q_solar] = sum(overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8),2);

load('occupancyMAT.mat')
[q_occupancy] = occupancyGain(occupancyMAT(:,3),occupancyMAT(:,2));

q_total = zeros(size(wSTRUCT.Temp,1),1);
q = sum([q_ht q_ac q_solar q_occupancy],2);
for i = 1:1:size(q,1)
    if q(i) < abs(q_MVHR(i))
       q_total(i) = q(i) + q_MVHR(i);
    else
       q_total(i) = q(i) + q_MVHRbypass(i);
    end
end

q_total_day = sum(reshape(q_total,24,365));

q_heat = sum(q_total(q_total < 0))/160;
q_cool = sum(q_total(q_total < 0))/160;


subplot(2,1,1)
hold on
plot(q_ht)
plot(q_ac)
plot(q_MVHR)
plot(q_MVHRbypass)
plot(q_solar)
plot(q_total)
legend('Heat Transfer through Enelope','Air Changes','MVHR','bypass','Solar','Total')
hold off

subplot(2,1,2)
plot(q_total_day)



        