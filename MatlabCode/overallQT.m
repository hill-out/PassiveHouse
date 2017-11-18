function [] = overallQT(t1, t2, buffer)
% a function to calculate the overall heat loss
%
% t1 - time to calculate from [1x3]
% t2 - time to calculate to [1x3]
% buffer - time to run before in hours


%% parameter definition
topCellSize = 0.005; %m
dt = 5; %s
g = 0.8;
stepHour = floor(3600/dt); %time steps per hour
Ti = zeros(stepHour+1,1);
Ti(1) = 22;
qTotal = zeros(stepHour,1);
qHeat = 0;
A = [0,0,0]; % area of window opennings
hCeiling = 2.5;
bypass = 0;
Tbuffi = zeros(buffer,stepHour+1);


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


% make noisy data

%% run for the buffer time (if needed)
if buffer > 0
    
    bufferQ = zeros(buffer,10); %initalise
    
    for i = tStart-buffer:tStart-1
        hour = mod(i,8760)+1; %get hour
        % get hourly data
        globalIrr = wSTRUCTtry.global(hour);
        diffIrr = wSTRUCTtry.diffuse(hour);
        To = wSTRUCTtry.Temp(hour);
        windSpeed = wSTRUCTtry.WSpeed(hour);
        [Pr, Nu, k] = assignPRandNU(To);
        newStructure = windowfromstructure(structure,window);
        
        t = [wSTRUCTtry.MONTH(hour),wSTRUCTtry.DAY(hour),wSTRUCTtry.HOUR(hour)];
        Tg = tempOfGround(hour);
        
        solarA = sunSphCoords(t);
        solarAcart = vecsph2cart(solarA);
        
        [~, dirGain, diffGain] = overallSolarGain(globalIrr, diffIrr, t, window, g);
        
        if mod(hour,24) < 8
            Ts = 17;
        else
            Ts = 22;
        end
        
        %run for all steps in hour
        for j = 1:stepHour
            
            % run solar and thermal mass stuff
            [qSolarAir, qThermalAir, ~, T] = thermalAndSolar(globalIrr, diffIrr, t, dt, cTemp, Ti(j), g, Tg, window, thermalMass, solarAcart, meshCrit, dirGain, diffGain);
            cTemp = T;
            % run other heat losses
            qHeatTransfer = sum(rateHeatLossHT(To,windSpeed,Ti(j),Pr,Nu,k,newStructure,window,foundation),2);
            qTightness = rateHeatLossAC(Ti(j),To,foundation);
            qOccupancy = q_occupancy(hour);
            if bypass
                qMVHR = rateHeatLossMVHRbypass(To,Ti(j),240);
            else
                qMVHR = rateHeatLossMVHR(To,Ti(j),240,0.9);
            end
            [A, qHeat] = controller(Ts, Ti(j), qHeat);
            
            if any(A~=0)
                [qStack, vStack] = stackVent(Ti(j),To,windSpeed,A);
                qStack = qStack(1);
            else
                qStack = 0;
                vStack = 0;
            end
            % total losses
            qTotalLoss = qHeatTransfer+qTightness+qMVHR+qStack;
            qTotalGain = qOccupancy+qSolarAir+qThermalAir+qHeat;
            qTotal(j) = qTotalLoss+qTotalGain;
            %new temperautre inside
            Ti(j+1) = Ti(j) + qTotal(j).*dt/(20000*1000);
            
            if Ti(j+1) > 23
                bypass = 1;
            elseif Ti(j+1) < 22
                bypass = 0;
            end
            
        end
        
        Tbuffo(i-tStart+buffer+1) = To;
        Tbuffi(i-tStart+buffer+1,:) = Ti;
        qBuffMean(i-tStart+buffer+1) = mean(qTotal);
        qBuffPeak(i-tStart+buffer+1) = max(qTotal);
        
        newT = Ti(end);
        Ti = zeros(stepHour+1,1);
        Ti(1) = newT;
    end
    
else
    bufferQ = zeros(1,10);
end

end