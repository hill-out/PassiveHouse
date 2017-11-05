function [outTemp] = thermalGain(dirGain, diffGain, cTemp, T_i, thermalMass, meshCrit, dt)
% Calculates the temperature of the thermal mass based on soalr gain using
% a 1D heat transfer finite difference method
% 
% dirGain - the direct solar gain, Watts
% diffGain - the diffuse solar gain, Watts
% cTemp - current temperature in each cell, degC (top to bottom) [nxnT]
% T_i - indoor temp, degC
% thermalMass - the info on the thermalMass
% meshCrit - meshing criteria (increasing functon from 0 to 1)

if nargin < 4 || isempty(T_i)
    T_i = 22;
end

if nargin < 5 || isempty(thermalMass)
    thermalMass = surfaceDefiner('t');
    thermalMass = thermalMass{1};
end

if nargin < 6 || isempty(meshCrit)
    meshCrit = @(x)(x); %linear default
end

if nargin < 7 || isempty(dt)
    dt = 1; %s
end

n = size(cTemp,1); % number of cells
meshSize = linspace(0,1,n+1);
meshSpace = meshCrit(meshSize); % z positions of the mesh layers

%% calculate the energy leaving the base and top
nT = size(thermalMass,1); %number of thermal masses
dQ = zeros(n+1,nT); %initalise heat transfer across each layer
for i = 1:nT
    dQ(end,i) = 0; %energy leaving base
    
    totalIrr = (dirGain + diffGain)*0.7; % spread irradiance * (1-reflect)
    h_i = 2; %indoor convective heat transfer coefficient
    totalLoss = (cTemp(1,i)-T_i)*h_i*thermalMass(i,7);
    dQ(1,i) = totalIrr - totalLoss;
end

%% calculate the energy leaving the other layers
l = (meshSpace(2:end)-meshSpace(1:end-1))/2+meshSpace(1:end-1); %position of centres of cells
dl = (l(2:end)-l(1:end-1));
for i = 1:nT
    k = thermalMass(i,11);
    dQ(2:end-1,i) = -(k./(dl.*thermalMass(i,6)))'.*(cTemp(2:end,i)-cTemp(1:end-1,i));
end

%% calculate the change in temperature with time

dQ_cell = dQ(1:end-1,:)-dQ(2:end,:);
mCp = (thermalMass(:,12).*thermalMass(:,13).*thermalMass(:,6)*l)';

dT_t = (dQ_cell.*dt)./mCp;


%% outTemp
outTemp = cTemp + dT_t;

end