function [q_MVHR] = rateHeatLossMVHR(T_o,T_i,extract_rate,eff_HR)

Cp = 1;
rho = 1.2;
P_el = 43;

T_exhaust = T_i + (P_el./(extract_rate.*Cp.*rho)) - eff_HR.*(T_i - T_o);

q_MVHR = (extract_rate.*rho).*Cp.*(T_o - T_exhaust)./(3.6);

end
