function [all] = overallQT(t1, t2, buffer)
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

load('weatherSTRUCTdsy.mat')

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
tStep = 0:0.5:8761;

noisyTo = addNoise(wSTRUCTdsy.Temp,2,10,0);
noisyWindSpeed = addNoise(wSTRUCTdsy.WSpeed,2,10,1);

%% get solar stuff
allt = [wSTRUCTdsy.MONTH,wSTRUCTdsy.DAY,wSTRUCTdsy.HOUR];

allSolarA = sunSphCoords(allt);
allSolarA = [allSolarA;allSolarA(1,:)];
allSolarAcart = vecsph2cart(allSolarA);

[~, dirGain, diffGain] = overallSolarGain(wSTRUCTdsy.global, wSTRUCTdsy.diffuse, allt, window, g);

dirGain(allSolarA(:,2)<0)=0;
diffSolarA(allSolarA(:,2)<0)=0;

dirGain = [dirGain;dirGain(1,:)];
diffGain = [diffGain;diffGain(1,:)];

%% run for the buffer time (if needed)
if buffer > 0
    
    bufferQ = zeros(buffer,10); %initalise
    
    for i = tStart-buffer:tStart-1
        hour = mod(i,8760)+1; %get hour
        
        newStructure = windowfromstructure(structure,window);
        
        t = [wSTRUCTdsy.MONTH(hour),wSTRUCTdsy.DAY(hour),wSTRUCTdsy.HOUR(hour)];
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
            
            dirGainj = interp1(1:8761,dirGain,hour+j/stepHour);
            diffGainj = interp1(1:8761,diffGain,hour+j/stepHour);
            solarAcart(1) = interp1(1:8761,allSolarAcart(:,1),hour+j/stepHour);
            solarAcart(2) = interp1(1:8761,allSolarAcart(:,2),hour+j/stepHour);
            solarAcart(3) = interp1(1:8761,allSolarAcart(:,3),hour+j/stepHour);
            
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
            qTotalloss = qHeatTransfer+qTightness+qMVHR+qStack;
            qTotalGain = qOccupancy+qSolarAir+qThermalAir+qHeat(j+1);
            try
                qTotal(j) = qTotalloss+qTotalGain;
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
tHour = linspace(0,1,stepHour+1);
all.t = repmat([0:tEnd-tStart]',1,stepHour) + repmat(tHour(1:end-1),tEnd-tStart+1,1);

all.To = zeros(tEnd-tStart+1,stepHour);

all.qTotal = zeros(tEnd-tStart+1,stepHour);
all.qHeatTransfer = zeros(tEnd-tStart+1,stepHour);
all.qWalls = zeros(tEnd-tStart+1,stepHour);
all.qWindows = zeros(tEnd-tStart+1,stepHour);
all.qFoundation = zeros(tEnd-tStart+1,stepHour);
all.qTightness = zeros(tEnd-tStart+1,stepHour);
all.qMVHR = zeros(tEnd-tStart+1,stepHour);
all.qStack = zeros(tEnd-tStart+1,stepHour);
all.qOccupancy = zeros(tEnd-tStart+1,stepHour);
all.qSolarAir = zeros(tEnd-tStart+1,stepHour);
all.qThermalAir = zeros(tEnd-tStart+1,stepHour);

all.vTotal = zeros(tEnd-tStart+1,stepHour);
all.vStack = zeros(tEnd-tStart+1,stepHour);
all.vAC = zeros(tEnd-tStart+1,stepHour);
all.vMVHR = zeros(tEnd-tStart+1,stepHour);

all.bypass = zeros(tEnd-tStart+1,stepHour);
all.A = zeros(tEnd-tStart+1,stepHour);

for i = tStart:tEnd
    
    To = zeros(1,stepHour);
    
    qTotal = zeros(1,stepHour);
    qHeatTransfer = zeros(1,stepHour);
    qWalls = zeros(1,stepHour);
    qWindows = zeros(1,stepHour);
    qFoundation =zeros(1,stepHour);
    qTightness = zeros(1,stepHour);
    qMVHR = zeros(1,stepHour);
    qStack = zeros(1,stepHour);
    qOccupancy = zeros(1,stepHour);
    qSolarAir = zeros(1,stepHour);
    qThermalAir = zeros(1,stepHour);
    qHeat = zeros(1,stepHour);
    
    vTotal = zeros(1,stepHour);
    vStack = zeros(1,stepHour);
    vAC = zeros(1,stepHour);
    vMVHR = zeros(1,stepHour);

    A = zeros(3,stepHour);
    bypass = zeros(1,stepHour);
    
    hour = mod(i,8760); %get hour
    hour(hour==0)=8760;
    
    newStructure = windowfromstructure(structure,window);
    
    t = [wSTRUCTdsy.MONTH(hour),wSTRUCTdsy.DAY(hour),wSTRUCTdsy.HOUR(hour)];
    Tg = tempOfGround(hour);
    
    if mod(hour,24)<8 || mod(hour,24)>23
        Tst = 21.2;
        Tsb = 17;
    else
        Tst = 21.2;
        Tsb = 20.8;
    end
    
    
    %run for all steps in hour
    for j = 1:stepHour
        
        dirGainj = interp1(1:8761,dirGain,hour+j/stepHour);
        diffGainj = interp1(1:8761,diffGain,hour+j/stepHour);
        solarAcart(1) = interp1(1:8761,allSolarAcart(:,1),hour+j/stepHour);
        solarAcart(2) = interp1(1:8761,allSolarAcart(:,2),hour+j/stepHour);
        solarAcart(3) = interp1(1:8761,allSolarAcart(:,3),hour+j/stepHour);
        
        To(j) = interp1(tStep, noisyTo, (hour+j/stepHour));
        windSpeed = interp1(tStep, noisyWindSpeed, (hour+j/stepHour));
        
        [Pr, Nu, k] = assignPRandNU(To(j));
        
        % run solar and thermal mass stuff
        [qSolar, qThermalAir(j), qFoundation(j), T] = thermalAndSolar([], [], [], dt, cTemp, Ti(j), g, Tg, window, thermalMass, solarAcart, meshCrit, dirGainj, diffGainj);
        cTemp = T;
        
        [T, qSolarAir(j)] = qThermalStructure(Ti(j), Tw(j), qSolar);
        Tw(j+1) = T;
        
        % run other heat losses
        [~, qWalls(j), qWindows(j)] = rateHeatLossHT(To(j),windSpeed,Ti(j),Pr,Nu,k,newStructure,window,foundation);
        qHeatTransfer(j) = qWalls(j) + qWindows(j);
        [qTightness(j), vAC(j)] = rateHeatLossAC(Ti(j),To(j),foundation);
        qOccupancy(j) = q_occupancy(hour);

        [A(:,j), qHeat(j+1), bypass(j)] = controller(Tst, Tsb, Ti(j));
        
        if any(A(:,j)~=0)
            [qStack(j), vStack(j)] = stackVent(Ti(j),To(j),windSpeed,A(:,j));
            
        else
            qStack(j) = 0;
            vStack(j) = 0;
        end
        
        vTotal(j) = vStack(j) + vAC(j);
        vReq(j) = 240;
        vMVHR(j) = vReq(j) - vTotal(j);
        
        if vMVHR(j) < 0
            vMVHR(j) = 0;
        elseif vMVHR(j) > vReq(j)
            vMVHR(j) = vReq(j);
        end        
        
        if vMVHR(j) == 0
            qMVHR(j) = 0;
        else
            if bypass(j) == 1
                qMVHR(j) = rateHeatLossMVHRbypass(To(j),Ti(j),vMVHR(j));
            elseif bypass(j) == 0
                qMVHR(j) = rateHeatLossMVHR(To(j),Ti(j),vMVHR(j),0.9);
            else
                qMVHR1 = rateHeatLossMVHRbypass(To(j),Ti(j),vMVHR(j));
                qMVHR2 = rateHeatLossMVHR(To(j),Ti(j),vMVHR(j),0.9);
                qMVHR(j) = qMVHR1*bypass(j)+qMVHR2*(1-bypass(j));
            end
        end
        
        
        % total losses
        qTotalloss(j) = qHeatTransfer(j)+qTightness(j)+qMVHR(j)+qStack(j);
        qTotalGain(j) = qOccupancy(j)+qSolarAir(j)+qThermalAir(j)+qHeat(j+1);
        try
            qTotal(j) = qTotalloss(j)+qTotalGain(j);
        catch
            a=1;
        end
        %new temperautre inside
        Ti(j+1) = Ti(j) + qTotal(j).*dt/(600*1000);
        
    end
    
    all.To(i-tStart+1,:) = To;
    all.Ti(i-tStart+1,:) = Ti(2:end);
    all.Tw(i-tStart+1,:) = Tw(2:end);

    all.qTotal(i-tStart+1,:) = qTotal;
    all.qHeatTransfer(i-tStart+1,:) = qHeatTransfer;
    all.qWalls(i-tStart+1,:) = qWalls;
    all.qWindows(i-tStart+1,:) = qWindows;
    all.qFoundation(i-tStart+1,:) = -qFoundation;
    all.qTightness(i-tStart+1,:) = qTightness;
    all.qMVHR(i-tStart+1,:) = qMVHR;
    all.qStack(i-tStart+1,:) = qStack;
    all.qOccupancy(i-tStart+1,:) = qOccupancy;
    all.qSolarAir(i-tStart+1,:) = qSolarAir;
    all.qThermalAir(i-tStart+1,:) = qThermalAir;
    all.qHeat(i-tStart+1,:) = qHeat(2:end);
    
    all.vTotal(i-tStart+1,:) = vTotal;
    all.vStack(i-tStart+1,:) = vStack;
    all.vAC(i-tStart+1,:) = vAC;
    all.vMVHR(i-tStart+1,:) = vMVHR;
    
    all.bypass(i-tStart+1,:) = bypass;
    all.A(i-tStart+1,:) = A(3,:);

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