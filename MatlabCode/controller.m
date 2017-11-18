function [A, qHeat] = controller(Ts, Ti, qH)
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

houseArea = 82.76*2;
qHeatm2 = (Ts - Ti)*2;
A = [0, 0, -(23 - Ti)*0.1];

dT = (Ts - Ti);

if dT > 1
    if qHeatm2 > 5
        qHeatm2 = 5;
    end
    qHeat = qHeatm2*houseArea;
elseif dT < 0
    qHeat = 0;
elseif qH>0
    qHeat = qHeatm2*houseArea;
else
    qHeat = 0;
end

if Ti < 23
    if A(3) > 1
        A(3) = 1;
    end
elseif dT > 0
    A(3) = 0;
end

if A(3)<0
    A(3) = 0;
end

end