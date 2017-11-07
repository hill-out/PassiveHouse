%Script to find Prandtl number and kinematic viscocity for air at Temp T_o
%based on linear interpolation. 

function [Pr,nu] = assignPRandNU(wMAT)

T_275k = 1.85; Pr_275k = 0.713; nu_275k = 1.343e-5; 
T_300k = 26.85; Pr_300k = 0.707; nu_300k = 1.568e-5;


T_o = wMAT(:,7); %Extract external temp

Pr = Pr_275k+(T_o-T_275k)*((Pr_300k-Pr_275k)/(T_300k-T_275k));
nu = nu_275k+(T_o-T_275k)*((nu_300k-nu_275k)/(T_300k-T_275k));

end
