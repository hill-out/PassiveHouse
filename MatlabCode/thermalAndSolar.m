function [qSolarAir, qThermalAir, qFoundation, T] = thermalAndSolar(globalIrr, diffIrr, t, dt, cTemp, Ti, g, Tg, windows, thermalMass, solarAcart, meshCrit, dirGain, diffGain)
% calculates the solar energy going to the air and to the thermal mass and
% the energy transfer from the thermal mass to the air
% 
% dirIrr - total direct irradiation
% diffIrr - total diffuse irradiation
% t
% dt - time step
% cTemp - current temp of the thermal masses {nTM}[nLayersx1]
% g - window g-value
% Ti - current indoor temperature
% Tg - ground temperature
% 
% qSolarAir - energy from sun to air
% qThermalAir - energy from thermal mass to air
% qFoundation - energy loss from the foundation
% T - new T of thermal masss


if nargin < 4 || isempty(cTemp)
    cTemp = cell(nTM,1);
end

if nargin < 5 || isempty(Ti)
    Ti = 22;
end

if nargin < 6 || isempty(g)
    g = 0.8;
end

if nargin < 7 || isempty(Tg)
    Tg = 7;
end

%% get the surfaces
if nargin < 8 || isempty(windows) 
    surfaces = surfaceDefiner('w'); %get windows and thermal mass
    windows = surfaces{1}; %get the window data
end

if nargin < 9 || isempty(thermalMass)
    surfaces = surfaceDefiner('t');
    thermalMass = surfaces{1}; %get the thermal mass data
end

if nargin < 10 || isempty(solarAcart)
    solarA = sunSphCoords(t);
    solarAcart = vecsph2cart(solarA);
end

nTM = size(thermalMass,1); %number of thermal masses

if nargin < 11 || isempty(meshCrit)
    meshLimX = [0:0.01:1]';
    meshLimY = [[4*[0:0.01:0.5].^3,(1+4*([0.01:0.01:0.5]-0.5).^(3))]*0.7+[0:0.01:1]*0.3]';
    meshCrit = @(x)(smartMesh(x,meshLimX,meshLimY));
end


T = cell(nTM,1);
qThermalAir = zeros(nTM,1);
qFoundation = zeros(nTM,1);
qSolarAir = zeros(nTM+1,1);

for i = 0:1:nTM
    cW = windows(:,9)==i;
    wi = windows(cW,:); %find the windows for the current i
    if i == 0
        occOuti = 1;
        occIni = 1;
    else
        [occOuti, occIni] = occlusion(solarAcart, wi, thermalMass(i,13));
    end
    
    if nargin < 12 || isempty(dirGain) 
        [~, dirGaini, diffGaini] = overallSolarGain(globalIrr, diffIrr, t, wi, g);
    else
        dirGaini = dirGain(cW);
        diffGaini = diffGain(cW);
    end
    
    oDirGaini = occOuti.*dirGaini';
    oDiffGaini = diffGaini'; %ignore outside factors for diffuse
    
    if i == 0
        refl = 1; %reflectivity
    else
        refl = thermalMass(i,12);
        
        tmDirGaini = (1-refl).*occIni.*oDirGaini; % direct energy hitting thermal mass
        tmDiffGaini = (1-refl).*occIni.*oDiffGaini; % diffuse energy hitting thermal mass
        
        tmDirIrr = sum(tmDirGaini); % total direct irradiation from all windows
        tmDiffIrr = sum(tmDiffGaini); % total diffuse irradiation from all windows
        
        [a, b, c] = thermalGain(tmDirIrr, tmDiffIrr, cTemp{i}, Ti, Tg, thermalMass(i,:), meshCrit, dt);
        
        T{i} = a;
        qThermalAir(i) = b;
        qFoundation(i) = c;
    end
    
    dirAir = sum((1-(1-refl).*occIni).*oDirGaini);
    diffAir = sum((1-(1-refl).*occIni).*oDiffGaini);
    
    qSolarAir(i+1) = dirAir + diffAir;
end

qSolarAir = sum(qSolarAir);
qThermalAir = sum(qThermalAir);
qFoundation = sum(qFoundation);

end