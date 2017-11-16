function [qHour, qAir, qTM, T] = overallThermalGain(globalIrr, diffIrr, t, g, layerThickness, cTempA)
% this function includes both the solar gains and the thermal mass
% contribution to the passive heating of the house to get the heat transfer
% rate into the house for a given time.
%
% globalIrr - the global irradiation [mx1]
% diffIrr - the diffuse irradiation [mx1]
% t - time [M, D, H] [mx3]
% g - gain factor [default = 0.8]
% layerThickness - the thickness of each thermal mass element (for FNE)
% cTempA - cell of all the current temperatures of all the layers of all 
%          the thermal masses {nTM}[nLayer]
%
% qHour - hourly overall heat release [m x nTM+1]
% qAir - dtly solar to air (not TM) [m x nTM+1 x stepHour]
% qTM - dtly solar to TM [m x nTM+1 x stepHour]
% T - dtly temperature of the thermal masses {nTM}[nLayer x m x stephour]


if nargin < 4 || isempty(g) %can ignore the g input
    g = 0.8;
end

if nargin < 5 || isempty(wallLayerThickness)
    wallLayerThickness = 0.01; %m
end

%% get the surfaces
surfaces = surfaceDefiner('wt'); %get windows and thermal mass
windows = surfaces{1}; %get the window data
thermalMass = surfaces{2}; %get the thermal mass data

nTM = size(thermalMass,1); %number of thermal masses
initialT = 23;
dt = 5;

stepHour = floor(3600/dt);
qTM = zeros(nTM,size(t,1),stepHour);
qAir = zeros(nTM+1,size(t,1),stepHour);

%% run each thermal mass
for i = 0:1:nTM
    
    wi = windows(windows(:,9)==i,:); %find the windows for the current i
    [~, dirGaini, diffGaini] = overallSolarGain(globalIrr, diffIrr, t, wi, g);
    
    
    
    if i == 0
        refl = 1; %reflectivity
        obs2 = zeros(size(t,1),size(wi,1));
    else
        
        solarA = sunSphCoords(t);
        AoB = tan(solarA(:,2));
        
        obs0 = wi(:,5)*(1./(AoB)');
        obs1 = obs0>sqrt(thermalMass(i,4));
        obs2 = zeros(size(obs0))';
        obs2(obs1) = sqrt(thermalMass(i,4))./obs0(obs1);
        
        refl = thermalMass(i,12);
        
        tmDirIrr = (1-refl).*sum(obs2.*dirGaini,2);
        tmDiffIrr = (1-refl).*sum(diffGaini,2);
        
        meshLimX = [0:0.01:1]';
        meshLimY = [[4*[0:0.01:0.5].^3,(1+4*([0.01:0.01:0.5]-0.5).^(3))]*0.7+[0:0.01:1]*0.3]';
        meshCrit = @(x)(smartMesh(x,meshLimX,meshLimY));
        
        wallMesh = findSpacing(meshCrit, wallLayerThickness/thermalMass(i,5));
        
        if nargin < 6 || isempty(cTempA)
            nLayers = ceil(1/wallMesh)+1;
            cTemp = ones(nLayers,1)*initialT;
        else
            cTemp = cTempA{i};
        end
        
        T{i} = zeros(nLayers,size(t,1),stepHour);
        
        
        for j = 1:size(t,1)
            for k = 1:stepHour
                [outT, outQ] = thermalGain(tmDirIrr(j), tmDiffIrr(j), cTemp, 22, thermalMass(i,:), meshCrit, dt);
                T{i}(:,j,k) = outT;
                qTM(i,j,k) = outQ;
                cTemp = outT;
            end
        end
        
    end
     
    qAir(i+1,:,:) = repmat(sum(refl.*(1-obs2).*dirGaini,2)+sum(refl*diffGaini,2),1,floor(3600/dt));
    
end

qHour = zeros(nTM+1,size(t,1));
qHour(1,:) = mean(qAir(1,:,:),3);

for i=1:1:nTM
    qHour(i+1,:) = mean(qAir(i+1,:,:),3) + mean(qTM(i,:,:),3);
end


    function [y] = findSpacing(m, l)
        y = fzero(@(x)(m(x)-l),l);
    end

    function [y] = smartMesh(x, xb, yb)
        % smart mesh makes the mesh smaller closer to the start
        % all inputs are columns
        % used in thermalGain
        
        a = [xb,yb];
        a = sort(a,1);
        
        b = repmat(x,1,size(a,1))>repmat(a(:,1)',size(x,1),1);
        
        c = sum(b,2);
        c(c==0)=1;
        
        d = ((x-xb(c))./(xb(c+1)-xb(c)));
        
        y = d.*(yb(c+1)-yb(c))+yb(c);
    end


end