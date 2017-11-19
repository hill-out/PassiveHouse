function [q_ht] = rateHeatLossHT(T_o,u,T_i,Pr,nu,k_air,structure,windows,foundation) 

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

%----------------------------------------------------------%

% For each wall segment
% Structure [x,y,z,L,H,A,nx,ny,nz,k_insul,L_insul]

for i = 1:1:size(structure,1)
    
    L = structure(i,4);
    A = structure(i,6);
    k_insul = structure(i,10);
    L_insul = structure(i,11);
    
% Reynolds number for given velocity over a 'flat' surface. 
%Re = (u.*L)./nu;

% Find the outdoor coefecient of heat transfer for a flat plate in
% turbulent flow, given Re, Pr @ T_o 
%h_o = (0.037.*(Re.^(4/5)).*(Pr.^(4/5)).*k_air)./L;

% Define indoor coeffecient of convective heat transfer
%h_i = 2;

if all(structure(i,7:9)) == all([1,0,0]) || all([0,-1,0]) || all([0,1,0]) %South/East/West facing wall 
    R_se = 0.04; %CIBSE A3 Wall - Horizontal - Normal value
    R_si = 0.13; %CIBSE A3 Wall - Horizontal
% Find U value for given wall segment, at time t. 
    %U = 1./((R_se)+(L_insul./k_insul)+(R_si));
    U = 0.128; %Changed U-values to match walls (celluslose + 20mm EPS)
elseif all(structure(i,7:9) == [-1,0,0]) %North facing wall
    R_se = 0.06; %External Surface Resistance: CIBSE A3 Wall - Horizontal - Sheltered  
    R_si = 0.13; %Internal Surface Reistance: CIBSE A3 Wall - Horizontal
    %U = 1./((R_se)+(L_insul./k_insul)+(R_si));
    U = 0.127; %Changed U-values to match walls (celluslose + 20mm EPS)
else %Roof
    R_se = 0.02; %External Surface Resistance: CIBSE A3 Wall - Upward - Exposed  
    R_si = 0.10; %Internal Surface Reistance: CIBSE A3 Roof (Flat or Pitched) - Upward
    %U = 1./((0.06)+(L_insul./k_insul)+(0.10));
    U = 0.123; %Changed U-values to match walls (celluslose + 20mm EPS)
end
% Rate of heat loss through walls, negetive for flows out of the home.  
q_ht_structure{:,i} = U.*A.*(T_o-T_i);

end

q_ht_structure = cell2mat(q_ht_structure);

%----------------------------------------------------------%

% Find heat flow rate through foundation, using given U value of 0.1

for i = 1:1:size(foundation,1)
    
    % Foundation [x,y,z,L,H,A,perimeter,nx,ny,nz,k_insul,k_ground,L_insul] 
    A = foundation(i,6); %Area of foundation
    pf = foundation(i,7); %Perimeter length of foundation
    k_insul = foundation(i,11);
    k_ground = foundation(i,12); %Thermal conductivity of the soil (2 = Sand or Gravel)
    L_insul = foundation(i,13);
    d_w = 0.3; %Exterior wall thickness (m)
    
    R_se = 0.04; %CIBSE A3 Floor - Downward - Normal value
    R_si = 0.17; %CIBSE A3 Floor - Downward
    R_insul = L_insul/k_insul;
    R_concrete = 0.2/1.130;
    
    B = A/(0.5*pf);
    
    d_ef = d_w + k_ground*(R_si + R_insul + R_concrete + R_se);
    
    U_foundation = 2/((0.457*B)+d_ef);
        
q_ht_foundation{:,i} = U_foundation.*A.*(T_o-T_i);

end

q_ht_foundation = cell2mat(q_ht_foundation);
q_ht_foundation = q_ht_foundation*0;
%----------------------------------------------------------%

% Find heat flow through windows for 
for i = 1:1:size(windows,1)
    
    A = windows(i,4)*windows(i,5);
    U_installed = 0.85;
    
    q_ht_windows{:,i} = U_installed.*A.*(T_o-T_i);
end

q_ht_windows = cell2mat(q_ht_windows);

% Combine structure, foundation, windows and ac heat loss matrices:

q_ht = [q_ht_structure q_ht_foundation q_ht_windows];
end