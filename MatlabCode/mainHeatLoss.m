clear,clc;
% Main script to calculate total heat losses over time in kWh. 
load('weatherSTRUCT.mat')

[Pr, nu, k] = assignPRandNU(wSTRUCT.Temp);
[swf] = surfaceDefiner('swf');
[s] = windowfromstructure(swf{1},swf{2});
T_i = 22; %Define indoor air temperature
Area = 171; % floor area (m^2)
%Thermal Losses:

[q_ht] = sum(rateHeatLossHT(wSTRUCT.Temp,wSTRUCT.WSpeed,T_i,Pr,nu,k,s,swf{2},swf{3}),2);
[q_ac] = rateHeatLossAC(T_i,wSTRUCT.Temp,swf{3});
[q_MVHR] = rateHeatLossMVHR(wSTRUCT.Temp,T_i,240,0.9);
[q_MVHRbypass] = rateHeatLossMVHRbypass(wSTRUCT.Temp,T_i,240);
[q_stack, V] = stackVent(24,wSTRUCT.Temp,wSTRUCT.WSpeed);
%Thermal Gains: 
load('weatherSTRUCTtry.mat');
load('qSolar.mat');
%[q_solar] = sum(overallSolarGain(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[],0.8),2);


load('occupancyMAT.mat')
[q_occupancy] = occupancyGain(occupancyMAT(:,3),occupancyMAT(:,2));

q_total = zeros(size(wSTRUCT.Temp,1),1);
q = sum([q_ht q_ac qSolar q_occupancy],2);
for i = 1:1:size(q,1)
    if q(i) < abs(q_MVHR(i))
       q_total(i) = q(i) + q_MVHR(i);
    else
       q_total(i) = q(i) + q_MVHRbypass(i);
    end
end

q_total_day = sum(reshape(q_total,24,365));

q_heat = sum(q_total(q_total < 0))/Area;
q_cool = sum(q_total(q_total > 0))/Area;

delta_T = q_total./(975*1.2);
delta_T_day = sum(reshape(delta_T,24,365));

subplot(3,1,1)
hold on
plot(q_ht)
plot(q_ac)
plot(q_MVHR)
plot(q_MVHRbypass)
plot(qSolar)
%plot(q_stack)
plot(q_total)
legend('Heat Transfer through Envelope','Air Changes','MVHR','bypass','Solar','Total')
hold off

subplot(3,1,2)
plot(q_total_day)

subplot(3,1,3)
plot(q_stack)


        