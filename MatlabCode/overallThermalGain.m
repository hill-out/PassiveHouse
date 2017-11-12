function [] = overallThermalGain(globalIrr, diffIrr, t, g, layerThickness)
% this function includes both the solar gains and the thermal mass
% contribution to the passive heating of the house to get the heat transfer
% rate into the house for a given time.
% 
% globalIrr - the global irradiation [mx1]
% diffIrr - the diffuse irradiation [mx1]
% t - time [M, D, H] [mx3]
% g - gain factor [default = 0.8]
% layerThickness - the thickness of each thermal mass element (for FNE) 

if nargin < 4 || isempty(g) %can ignore the g input
    g = 0.8;
end

if nargin < 5
    wallLayerThickness = 0.005; %m
end

%% get the surfaces
surfaces = surfaceDefiner('wt'); %get windows and thermal mass
windows = surfaces{1}; %get the window data
thermalMass = surfaces{2}; %get the thermal mass data

nTM = size(thermalMass,1); %number of thermal masses

initialT = 23; %degC
dt = 5;

qTM = zeros(nTM,size(t,1),floor(3600/dt));
%% run each thermal mass
for i = 0:1:nTM
    
    wi = windows(windows(:,9)==i,:); %find the windows for the current i
    [~, dirGaini, diffGaini] = overallSolarGain(globalIrr, diffIrr, t, wi, g);
    

    
    if i == 0
        refl = 1; %reflectivity
    else
        
        solarA = sunSphCoords(t);
        AoB = tan(solarA(:,2));
        
        obs0 = wi(:,5)*(1./(AoB)');
        obs1 = obs0>sqrt(thermalMass(i,4));
        obs2 = zeros(size(obs0));
        obs2(obs1) = sqrt(thermalMass(i,4))./obs0(obs1);
        
        refl = thermalMass(i,10);
        
        tmDirIrr = (1-refl).*sum(obs2*dirGaini,2);
        tmDiffIrr = (1-refl).*sum(diffGaini,2);

        meshLimX = [0:0.01:1]';
        meshLimY = [[4*[0:0.01:0.5].^3,(1+4*([0.01:0.01:0.5]-0.5).^(3))]*0.7+[0:0.01:1]*0.3]';
        meshCrit = @(x)(smartMesh(x,meshLimX,meshLimY));
        
        wallMesh = findSpacing(meshCrit, wallLayerThickness/thermalMass(i,5));
        
        nLayers = ceil(1/wallMesh)+1;
        cTemp = ones(nLayers,1)*initialT;
        
        T{i} = zeros(nLayers,size(t,1),floor(3600/dt));
        
        
        for j = 1:size(t,1)
            for k = 1:floor(3600/dt)
                [outT, outQ] = thermalGain(tmDirIrr(j), tmDiffIrr(j), cTemp, 22, thermalMass(i,:), meshCrit, dt);
                T{i}(:,j,k) = outT;
                qTM(i,j,k) = outQ;
                cTemp = outT;
            end
        end
        
    end
    
    
    
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