function [q_ht] = rateHeatLoss(wMAT,T_i,Pr,nu,structure,windows) 

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

structure = cell2mat(structure);
windows = cell2mat(windows);

u = wMAT(:,9);
T_o = wMAT(:,7);

%for each wall segment
% Structure [x,y,z,L,H,A,nx,ny,nz,k_insul,L_insul]

for i = 1:1:4
    
    L = structure(i,4);
    A = structure(i,6);
    k_insul = structure(i,10);
    L_insul = structure(i,11);
    
% Reynolds number for given velocity over a 'flat' surface. 
Re = (u.*L)./nu;

% Find the outdoor coefecient of heat transfer for a flat plate in
% turbulent flow, given Re, Pr @ T_o 
h_o = (0.037.*(Re.^(4/5)).*(Pr.^(4/5)).*k_insul)./L;

% Define indoor coeffecient of convective heat transfer
h_i = 2;

% Find U value for given wall segment, at time t. 
U = 1./((1./h_o)+(L_insul./k_insul)+(1./h_i));

% Rate of heat loss through walls, negetive for flows out of the home.  
q_ht_structure{:,i} = U.*A.*(T_o-T_i);

end

q_ht_structure = cell2mat(q_ht_structure);

%% Find heat flow rate through foundation, using given U value of 0.1

U_foundation = 0.1;
q_ht_foundation = U_foundation.*structure(5,6).*(T_o-T_i);

%% Find heat flow through windows for 
for i = 1:1:size(windows,1)
    
    A = windows(i,4)*windows(i,5);
    U_installed = 0.85;
    
    q_ht_windows{:,i} = U_installed.*A.*(T_o-T_i);
end

q_ht_windows = cell2mat(q_ht_windows);

%% Heat loss due to air changes (with an airtightness of 0.6ac/h @50Pa
%pressure difference. 
%Assume a yearly average pressure difference on 19Pa. 
Cp_air = 1;
P_50Pa = 50;
P_ave = 19;

%u^2 propertional to P
%u proportional to m_dot

H_cieling = 2.5;

m_dot_50Pa = structure(5,6)*(2*H_cieling)*0.6; 
m_dot_19Pa = m_dot_50Pa*(sqrt(P_50Pa/P_ave));

q_ht_ac = m_dot_19Pa.*Cp_air*(T_o - T_i);

%% Combine structure, foundation, windows and ac heat loss matrices:

q_ht = [q_ht_structure q_ht_foundation q_ht_windows q_ht_ac];
end