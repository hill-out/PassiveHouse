function [rot] = rotz(a)

rot = [cos(a*pi/180), -sin(a*pi/180), 0;
       sin(a*pi/180), cos(a*pi/180), 0;
       0, 0, 1];

end