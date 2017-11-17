function [q_MVHR] = rateHeatLossMVHR(T_o,T_i,extract_rate,eff_HR)

Cp_rho = 0.333;
rho = 1.2;
Cp=1;
P_el = 43;

T_exhaust = T_i + (P_el./(extract_rate.*Cp_rho)) - eff_HR.*(T_i - T_o);

q_MVHR = (extract_rate.*rho).*Cp.*(T_o - T_exhaust)./(3.6);

end
