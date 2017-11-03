function [q_ht] = rateHeatLoss(u,T_i,T_o,Pr,nu,L,A,k_insul,L_insul) 

%Find the rate of thermal heat loss through building envilope due to heat
%transfer. 

% T_i = 'Inside Temperature (Assumed constant @ 22 celcius) (celcius)'
% T_o = 'Outside Temperature from CIBSE Data (celcius)'
% Pr = 'Prandtl number @ T_o'
% L = 'Length of structural segment (m)'
% nu = 'Kinematic viscocity of fluid @ T_o'
% A = 'Area of structural segment (not including windows) (m^2)'
% u = 'Wind velocity (m/s)' 
% k_insul = 'Insulating material thermal conductivity'
% L_insul = 'Thickness of insulating material'
% h_o = 'coeffecient of convection heat transfer'

% Reynolds number for given velocity over a 'flat' surface. 
Re = (u*L)/nu;

% Find the outdoor coefecient of heat transfer for a flat plate in
% turbulent flow, given Re, Pr @ T_o 
h_o = (0.037*(Re^(4/5))*(Pr^(4/5))*k_insul)/L;

% Define indoor coeffecient of convective heat transfer
h_i = 2;

% Find U value for given wall segment, at time t. 
U = 1/((1/h_o)+(L_insul/k_insul)+(1/h_i));

% Rate of heat loss through walls, negetive for flows out of the home.  
q_ht = U.*A.*(T_o - T_i);

end
