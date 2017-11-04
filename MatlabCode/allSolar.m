function [] = allSolar(globalIrr, diffIrr, t, windows, g)
% computes the overall solar gain from the windows
% 
% globalIrr - the global irradiation [mx1]
% diffIrr - the diffuse irradiation [mx1]
% t - time [M, D, H] [mx3]
% windows - windowData [x,y,z,L,H,nx,ny,nz] leave empty for surfaceDefiner
% g - gain factor [default = 0.8]
%
% 

[gain, dirGain, diffGain] = overallSolarGain(globalIrr, diffIrr, t, windows, g)



end