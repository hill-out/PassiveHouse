function [cT] = cTempInitialise(meshCrit, topCellRat, Ttop, Tbot)
% a function that initialises the temperature of the thermal mass
%
% meshCrit - meshing criteria function
% topCellRat - ratio of the size of the top cell to the total size
% Ttop - top temperature
% Tbot - bottom temperature
%
% cT - current temperature

cT = cell(numel(topCellRat),1);

for i = 1:numel(topCellRat)
    wallMesh = findSpacing(meshCrit, topCellRat(i)); %max size of modified x
    
    nLayer = ceil(1/wallMesh);
    cellPos = meshCrit(linspace(0,1,nLayer)');
    
    cT{i} = cellPos.*(Tbot(i)-Ttop(i))+Ttop(i);
end

end