function [q_MVHR_bypass] = rateHeatLossMVHRbypass(T_o,T_i,extract_rate)

Cp = 1;
rho = 1.2;

q_MVHR_bypass = (extract_rate*rho).*Cp.*(T_o - T_i)./(3.6);

end

