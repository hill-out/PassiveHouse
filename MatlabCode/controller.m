function [A, qHeat, bypass] = controller(Tst, Tsb, Ti)
% uses information gathered from indicators to get the required values of
% stuff
%
% Ts - Temperature setpoint
% Ti - Temperautre indoors
% Vs - Ventilation setpint
% Vi - Ventilation indoors
%
% A - Area of stack
% qHeat - energy provided for heating

dTt = (Ti - Tst);
dTb = (Tsb - Ti);

houseArea = 82.76*2;
qHeatm2 = (dTb - 0.4)*10;
qMaxm2 = 10;

bP = (dTt - 0.4);
if bP > 1
    bP = 1;
elseif bP < 0
    bP = 0;
end

%cold values
qHeat = 0;
bypass = 0;
A = [0, 0, 0];

if dTb > 0
    % heating on fully
    qHeat = qMaxm2*houseArea;
% elseif dTb > 0
%     % heating partially on
%     qHeat = qHeatm2*houseArea;
end

if dTt > 3.6
    % stack fully open
    A(3) = 2;
elseif dTt > 1.6
    % stack partially open
    A(3) = dTt - 1.6;
elseif dTt > 1
    % bypass fully open
    bypass = 1;
elseif dTt > 0
    % bypass partially open
    bypass = bP;
end

end