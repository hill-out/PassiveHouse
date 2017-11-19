function [outTemp, QLossAir, QLossFoundation] = thermalGain(dirGain, diffGain, cTemp, T_i, T_g, thermalMass, meshCrit, dt)
% Calculates the temperature of the thermal mass based on soalr gain using
% a 1D heat transfer finite difference method
% 
% dirGain - the direct solar gain, Watts
% diffGain - the diffuse solar gain, Watts
% cTemp - current temperature in each cell, degC (top to bottom) [nLayerx1]
% T_i - indoor temp, degC
% thermalMass - the info on the thermalMass
% meshCrit - meshing criteria (increasing functon from 0 to 1)

if nargin < 4 || isempty(T_i)
    T_i = 22;
end

if nargin < 5 || isempty(T_g)
    T_g = 7;
end

if nargin < 6 || isempty(thermalMass)
    thermalMass = surfaceDefiner('t');
    thermalMass = thermalMass{1};
end

if nargin < 7 || isempty(meshCrit)
    meshCrit = @(x)(x); %linear default
end

if nargin < 8 || isempty(dt)
    dt = 1; %s
end

n = size(cTemp,1); % number of cells
meshSize = linspace(0,1,n+1)';
meshSpace = meshCrit(meshSize); % z positions of the mesh layers

%% calculate the energy leaving the top and base
dQ = zeros(n+1,1); %initalise heat transfer across each layer

totalIrr = (dirGain + diffGain); % spread irradiance * (1-reflect)
h_i = 2; %indoor convective heat transfer coefficient
totalLoss = (cTemp(1,1)-T_i)*h_i*thermalMass(1,4);
dQ(1,1) = totalIrr - totalLoss;

if thermalMass(1,13) == 0 %foundation losses
    U = 0.1;
    dT = cTemp(end)-T_g;
    
    dQ(end,1) = dT*U*thermalMass(1,4);
    
    QLossAir = totalLoss;
    QLossFoundation = dQ(end,1);
else %losses to ground floor
    h_c = 0.5; %if ceiling (change to 2 otherwise)
    dT = cTemp(end)-T_i;
    
    dQ(end,1) = dT*h_c*thermalMass(1,4);
    
    QLossAir = totalLoss + dQ(end,1);
    QLossFoundation = 0;
end



%% calculate the energy leaving the other layers
cSize = (meshSpace(2:end)-meshSpace(1:end-1)); %list of cell sizes
l = cSize./2+meshSpace(1:end-1); %position of centers of cells
dl = (l(2:end)-l(1:end-1));

k = thermalMass(1,9);
dQ(2:end-1,1) = -(k./(dl.*thermalMass(1,5))).*(cTemp(2:end,1)-cTemp(1:end-1,1));


%% calculate the change in temperature with time

dQ_cell = dQ(1:end-1,:)-dQ(2:end,:);
mCp = (thermalMass(:,10).*thermalMass(:,11).*thermalMass(:,5).*thermalMass(:,4)*cSize);

dT_t = (dQ_cell.*dt)./mCp;


%% out
outTemp = cTemp + dT_t;
end