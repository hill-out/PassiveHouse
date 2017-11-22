function [dayAngle] = roughSunAngleCalc(M,D,H)

yearD = (M-3.5)*30+D;

yearAngle = (24)*sin(yearD/365*2*pi)+34;
dayAngle = yearAngle+sin((H-6)/24*2*pi)*34-34;

end
