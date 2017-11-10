function [q_ac] = rateHeatLossAC(T_i,T_o,foundation)

% Heat loss due to air changes (with an airtightness of 0.6ac/h @50Pa
%pressure difference. 
%Assume a yearly average pressure difference on 19Pa. 
Cp_air = 1;
P_50Pa = 50;
P_ave = 19; %http://www.sciencedirect.com/science/article/pii/S1876610215019207

%u^2 propertional to P
%u proportional to m_dot

H_cieling = 2.5;

m_dot_50Pa = (foundation(1,6)*(2*H_cieling))*1.2*0.6; % kg per hour 

m_dot_ave = m_dot_50Pa/20; %CIBSE

q_ac = (m_dot_ave.*Cp_air*(T_o - T_i))./(3.6); %W

end