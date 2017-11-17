function [] = overallQT(t1, t2, buffer)
% a function to calculate the overall heat loss
%
% t1 - time to calculate from [1x3]
% t2 - time to calculate to [1x3]
% buffer - time to run before in hours


%% parameter definition
topCellSize = 0.005; %m
dt = 5; %s
Ti = 22;
g = 0.8;
stepHour = floor(3600/dt); %time steps per hour
A = [0,0,0]; % area of window opennings
hCeiling = 2.5;
bypass = 0;

load('weatherSTRUCTtry.mat')

load('occupancyMAT.mat') %get occupancy data
[q_occupancy] = occupancyGain(occupancyMAT(:,3),occupancyMAT(:,2));

%% get surface info
surfaces = surfaceDefiner('wsft');
window = surfaces{1};
structure = surfaces{2};
foundation = surfaces{3};
thermalMass = surfaces{4};

volHouse = foundation(1,6)*(2*hCeiling);

%% initialise current temperature
tStart = findCurrentHour(t1); %hour of the first iteration

Tgroundi = tempOfGround(tStart-buffer);

Tbot = zeros(size(thermalMass,1));
Tbot(thermalMass(:,13)==0) = 22-(22-Tgroundi)*0.25;
Tbot(thermalMass(:,13)==1) = 22;

Ttop = ones(size(thermalMass,1)).*22;

meshLimX = [0:0.01:1]';
meshLimY = [[4*[0:0.01:0.5].^3,(1+4*([0.01:0.01:0.5]-0.5).^(3))]*0.7+[0:0.01:1]*0.3]';
meshCrit = @(x)(smartMesh(x,meshLimX,meshLimY));


topCellRat = topCellSize./thermalMass(:,5);

cTemp = cTempInitialise(meshCrit, topCellRat, Ttop, Tbot);

%% run for the buffer time (if needed)
if buffer > 0
    
    bufferQ = zeros(buffer,10); %initalise
    
    for i = tStart-buffer:tStart-1
        hour = mod(i,8760); %get hour
        % get hourly data
        globalIrr = wSTRUCTtry.global(hour);
        diffIrr = wSTRUCTtry.diffuse(hour);
        To = wSTRUCTtry.Temp(hour);
        windSpeed = wSTRUCTtry.WSpeed(hour);
        [Pr, Nu, k] = assignPRandNU(To);
        newStructure = windowfromstructure(structure,window);
        
        t = [wSTRUCTtry.MONTH(hour),wSTRUCTtry.DAY(hour),wSTRUCTtry.HOUR(hour)];
        Tg = tempOfGround(hour);
        
        %add noise to data
        ToN = awgn((To+273).*ones(stepHour,1),1)
        
        %run for all steps in hour
        for j = 1:stepHour
            % run solar and thermal mass stuff
            [qSolarAir, qThermalAir, ~, T] = thermalAndSolar(globalIrr, diffIrr, t, dt, cTemp, Ti, g, Tg);
            cTemp = T;
            % run other heat losses
            qHeatTransfer = sum(rateHeatLossHT(To,windSpeed,Ti,Pr,Nu,k,newStructure,window,foundation),2);
            qTightness = rateHeatLossAC(Ti,To,foundation);
            qOccupancy = q_occupancy(hour);
            
            if bypass
                qMVHR = rateHeatLossMVHRbypass(To,Ti,240);
            else
                qMVHR = rateHeatLossMVHR(To,Ti,240,0.9);
            end
            
            if any(A~=0)
                [qStack, vStack] = stackVent(24,To,windSpeed,A);
            else
                qStack = 0;
                vStack = 0;
            end
            % total losses
            qTotalLoss = qHeatTransfer+qTightness+qMVHR+qStack;
            qTotalGain = qOccupancy+qSolarAir+qThermalAir;
            
            qTotal = qTotalLoss+qTotalGain;
            %new temperautre inside
            Ti = Ti + qTotal.*dt/(1.2.*volHouse*1000);
            
            
        end
        
        
        
    end
    
else
    bufferQ = zeros(1,10);
end

end