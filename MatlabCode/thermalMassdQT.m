function [outQ, outT] = thermalMassdQT(globalIrr, diffIrr, t, Ti, TM, dt, cTempA, meshCrit, layerThickness)
% this function includes both the solar gains and the thermal mass
% contribution to the passive heating of the house to get the heat transfer
% rate into the house for a given time.
%
% dirIrr - the global irradiation at t
% diffIrr - the diffuse irradiation at t
% t - time [M, D, H] [1x3]
% Ti - Temperature of the outside
% TM - thermal mass data
% dt - time step
% cTempA - cell of all the current temperatures of all the layers of all
%          the thermal masses [nLayerx1]
% layerThickness - the thickness of top thermal mass element (for FEM)
% 
% qHour - hourly overall heat release [m x nTM+1]
% qAir - dtly solar to air (not TM) [m x nTM+1 x stepHour]
% qTM - dtly solar to TM [m x nTM+1 x stepHour]
% T - dtly temperature of the thermal masses {nTM}[nLayer x m x stephour]


[outT, outQ] = thermalGain(dirIrr, diffIrr, cTemp, Ti, TM, meshCrit, dt);


    function [y] = findSpacing(m, l)
        y = fzero(@(x)(m(x)-l),l);
    end

end