function [] = overallQT(t1, t2, buffer)
% a function to calculate the overall heat loss
%
% t1 - time to calculate from [1x3]
% t2 - time to calculate to [1x3]
% buffer - time to run before in hours


%% parameter definition
topCellSize = 0.005; %m
dt = 20; %s
g = 0.8;
stepHour = floor(3600/dt); %time steps per hour
solarAcart = zeros(1,3);

Ti = zeros(stepHour+1,1);
Ti(1) = 22;
Tw = zeros(stepHour+1,1);
Tw(1) = 22;

qHeat = zeros(stepHour+1,1);
qTotal = zeros(stepHour,1);
vMVHR = 240;

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
tEnd = findCurrentHour(t2);

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


%% make noisy data
% makes all the data we have measured and fits a noisy line to it
tStep = 0:0.5:8760;

noisyTo = addNoise(wSTRUCTtry.Temp,2,10,0);
noisyWindSpeed = addNoise(wSTRUCTtry.WSpeed,2,10,1);

%% get solar stuff
allt = [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR];

allSolarA = sunSphCoords(allt);
allSolarAcart = vecsph2cart(allSolarA);

[~, dirGain, diffGain] = overallSolarGain(wSTRUCTtry.global, wSTRUCTtry.diffuse, allt, window, g);

dirGain(allSolarA(:,2)<0)=0;
diffSolarA(allSolarA(:,2)<0)=0;

%% run for the buffer time (if needed)
if buffer > 0
    
    bufferQ = zeros(buffer,10); %initalise
    
    for i = tStart-buffer:tStart-1
        hour = mod(i,8760)+1; %get hour
        
        newStructure = windowfromstructure(structure,window);
        
        t = [wSTRUCTtry.MONTH(hour),wSTRUCTtry.DAY(hour),wSTRUCTtry.HOUR(hour)];
        Tg = tempOfGround(hour);
        
        
        
        
        if mod(hour,24)<8 || mod(hour,24)>23
            Tst = 21.4;
            Tsb = 17;
        else
            Tst = 21.4;
            Tsb = 20.6;
        end
        
        
        %run for all steps in hour
        for j = 1:stepHour
            
            dirGainj = interp1(0:8759,dirGain,hour+j/stepHour);
            diffGainj = interp1(0:8759,diffGain,hour+j/stepHour);
            solarAcart(1) = interp1(0:8759,allSolarAcart(:,1),hour+j/stepHour);
            solarAcart(2) = interp1(0:8759,allSolarAcart(:,2),hour+j/stepHour);
            solarAcart(3) = interp1(0:8759,allSolarAcart(:,3),hour+j/stepHour);
            
            To = interp1(tStep, noisyTo, (hour+j/stepHour));
            windSpeed = interp1(tStep, noisyWindSpeed, (hour+j/stepHour));
            
            [Pr, Nu, k] = assignPRandNU(To);
            
            % run solar and thermal mass stuff
            [qSolar, qThermalAir, ~, T] = thermalAndSolar([], [], [], dt, cTemp, Ti(j), g, Tg, window, thermalMass, solarAcart, meshCrit, dirGainj, diffGainj);
            cTemp = T;
            
            [T, qSolarAir] = qThermalStructure(Ti(j), Tw(j), qSolar);
            Tw(j+1) = T;
            
            % run other heat losses
            qHeatTransfer = sum(rateHeatLossHT(To,windSpeed,Ti(j),Pr,Nu,k,newStructure,window,foundation),2);
            [qTightness, vAC] = rateHeatLossAC(Ti(j),To,foundation);
            qOccupancy = q_occupancy(hour);
            
            if vMVHR == 0
                qMVHR = 0;
            else
                if bypass == 1
                    qMVHR = rateHeatLossMVHRbypass(To,Ti(j),vMVHR);
                elseif bypass == 0
                    qMVHR = rateHeatLossMVHR(To,Ti(j),vMVHR,0.9);
                else
                    qMVHR1 = rateHeatLossMVHRbypass(To,Ti(j),vMVHR);
                    qMVHR2 = rateHeatLossMVHR(To,Ti(j),vMVHR,0.9);
                    qMVHR = qMVHR1*bypass+qMVHR2*(1-bypass);
                end
            end
            
            [A, qHeat(j+1), bypass] = controller(Tst, Tsb, Ti(j));
            
            if any(A~=0)
                [qStack, vStack] = stackVent(Ti(j),To,windSpeed,A);
                
            else
                qStack = 0;
                vStack = 0;
            end
            
            % total losses
            qTotalLoss = qHeatTransfer+qTightness+qMVHR+qStack;
            qTotalGain = qOccupancy+qSolarAir+qThermalAir+qHeat(j+1);
            try
                qTotal(j) = qTotalLoss+qTotalGain;
            catch
                a=1;
            end
            %new temperautre inside
            Ti(j+1) = Ti(j) + qTotal(j).*dt/(600*1000);
            
            vTotal = vStack + vAC;
            vReq = 240;
            vMVHR = vReq - vTotal;
            
            if vMVHR < 0
                vMVHR = 0;
            elseif vMVHR > vReq
                vMVHR = vReq;
            end
        end
        
        newQ = qHeat(end);
        qHeat = zeros(stepHour+1,1);
        qHeat(1) = newQ;
        
        newTi = Ti(end);
        Ti = zeros(stepHour+1,1);
        Ti(1) = newTi;
        
        newTw = Tw(end);
        Tw = zeros(stepHour+1,1);
        Tw(1) = newTw;
    end
end

%% run for the real time

for i = tStart:tEnd
    
    hour = mod(i,8760); %get hour
    
    newStructure = windowfromstructure(structure,window);
    
    t = [wSTRUCTtry.MONTH(hour),wSTRUCTtry.DAY(hour),wSTRUCTtry.HOUR(hour)];
    Tg = tempOfGround(hour);
    
    
    
    
    if mod(hour,24)<8 || mod(hour,24)>23
        Tst = 21.4;
        Tsb = 17;
    else
        Tst = 21.4;
        Tsb = 20.6;
    end
    
    
    %run for all steps in hour
    for j = 1:stepHour
        
        dirGainj = interp1(0:8759,dirGain,hour+j/stepHour);
        diffGainj = interp1(0:8759,diffGain,hour+j/stepHour);
        solarAcart(1) = interp1(0:8759,allSolarAcart(:,1),hour+j/stepHour);
        solarAcart(2) = interp1(0:8759,allSolarAcart(:,2),hour+j/stepHour);
        solarAcart(3) = interp1(0:8759,allSolarAcart(:,3),hour+j/stepHour);
        
        To = interp1(tStep, noisyTo, (hour+j/stepHour));
        windSpeed = interp1(tStep, noisyWindSpeed, (hour+j/stepHour));
        
        [Pr, Nu, k] = assignPRandNU(To);
        
        % run solar and thermal mass stuff
        [qSolar, qThermalAir, ~, T] = thermalAndSolar([], [], [], dt, cTemp, Ti(j), g, Tg, window, thermalMass, solarAcart, meshCrit, dirGainj, diffGainj);
        cTemp = T;
        
        [T, qSolarAir] = qThermalStructure(Ti(j), Tw(j), qSolar);
        Tw(j+1) = T;
        
        % run other heat losses
        qHeatTransfer = sum(rateHeatLossHT(To,windSpeed,Ti(j),Pr,Nu,k,newStructure,window,foundation),2);
        [qTightness, vAC] = rateHeatLossAC(Ti(j),To,foundation);
        qOccupancy = q_occupancy(hour);
        
        if vMVHR == 0
            qMVHR = 0;
        else
            if bypass == 1
                qMVHR = rateHeatLossMVHRbypass(To,Ti(j),vMVHR);
            elseif bypass == 0
                qMVHR = rateHeatLossMVHR(To,Ti(j),vMVHR,0.9);
            else
                qMVHR1 = rateHeatLossMVHRbypass(To,Ti(j),vMVHR);
                qMVHR2 = rateHeatLossMVHR(To,Ti(j),vMVHR,0.9);
                qMVHR = qMVHR1*bypass+qMVHR2*(1-bypass);
            end
        end
        
        [A, qHeat(j+1), bypass] = controller(Tst, Tsb, Ti(j));
        
        if any(A~=0)
            [qStack, vStack] = stackVent(Ti(j),To,windSpeed,A);
            
        else
            qStack = 0;
            vStack = 0;
        end
        
        % total losses
        qTotalLoss = qHeatTransfer+qTightness+qMVHR+qStack;
        qTotalGain = qOccupancy+qSolarAir+qThermalAir+qHeat(j+1);
        try
            qTotal(j) = qTotalLoss+qTotalGain;
        catch
            a=1;
        end
        %new temperautre inside
        Ti(j+1) = Ti(j) + qTotal(j).*dt/(600*1000);
        
        vTotal = vStack + vAC;
        vReq = 240;
        vMVHR = vReq - vTotal;
        
        if vMVHR < 0
            vMVHR = 0;
        elseif vMVHR > vReq
            vMVHR = vReq;
        end
    end
    
    Tbuffo(i-tStart+1) = To;
    Tbuffi(i-tStart+1,:) = Ti;
    qBuffMean(i-tStart+1) = mean(qTotal);
    qBuffPeak(i-tStart+1) = max(qTotal);
    
    qHeating(i-tStart+1)=mean(qHeat);
    
    newQ = qHeat(end);
    qHeat = zeros(stepHour+1,1);
    qHeat(1) = newQ;
    
    newTi = Ti(end);
    Ti = zeros(stepHour+1,1);
    Ti(1) = newTi;
    
    newTw = Tw(end);
    Tw = zeros(stepHour+1,1);
    Tw(1) = newTw;
end


end