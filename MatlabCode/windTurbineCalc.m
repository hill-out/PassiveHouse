clear; clc;
%The script will load the wind data and calculate the daily wind power
%generated

%Load weather data
load('weatherSTRUCT.mat');

%Cumulative day of year
Jan = 31;
Feb = 59;
Mar = 90;
Apr = 120;
May = 151;
Jun = 181;
Jul = 212;
Aug = 243;
Sep = 273;
Oct = 304;
Nov = 334;
Dec = 365;

%Constants
airDensity = 1.23; %kg/m3

%Turbine specs
%Reference:
%http://renewabledevices.com/rd-swift-turbines/technical/
%https://www.ecopowershop.com/swift-1-5kw-quiet-wind-turbine-system
%http://www.raeng.org.uk/publications/other/23-wind-turbine

d = 2.08; % Turbine Diameter
eff = 0.3; % 30 percent overall efficiency at converting wind to electricity
cutIn = 3.4; % m/s - Wind Cut in speed
maxOutput = 1.5; %kW - maximum rated power output
n = 1; % Number of turbine

%Calculate Sweeping area
A = pi*(d/2)^2;

%Calculate wind power
%Assuming wind speed is constant for one full hour
%Thus the power output will be in kWh
windSpeedData = wSTRUCT.WSpeed;
s = size(windSpeedData);
windPower = zeros(s(1),1);

for i = 1:s(1)
    if windSpeedData(i) < cutIn
        windSpeedData(i) = 0;
    else
        windSpeedData(i) = windSpeedData(i);
        windPower(i) = (1/2 .* airDensity .* A .* (windSpeedData(i)).^3 .* eff)./1000;
        
        if windPower(i) > maxOutput
            windPower(i) = maxOutput;
        end
    end
end

%Calculate hourly, daily, and total power generated
WPhourly = reshape(windPower,24,365);
WPdaily = sum(WPhourly);
WPtotal = sum(WPdaily);

%Monthly power generated
WPmonth(1) = sum(WPdaily(:,1:Jan));
WPmonth(2) = sum(WPdaily(:,Jan+1:Feb));
WPmonth(3) = sum(WPdaily(:,Feb+1:Mar));
WPmonth(4) = sum(WPdaily(:,Mar+1:Apr));
WPmonth(5) = sum(WPdaily(:,Apr+1:May));
WPmonth(6) = sum(WPdaily(:,May+1:Jun));
WPmonth(7) = sum(WPdaily(:,Jun+1:Jul));
WPmonth(8) = sum(WPdaily(:,Jul+1:Aug));
WPmonth(9) = sum(WPdaily(:,Aug+1:Sep));
WPmonth(10) = sum(WPdaily(:,Sep+1:Oct));
WPmonth(11) = sum(WPdaily(:,Oct+1:Nov));
WPmonth(12) = sum(WPdaily(:,Nov+1:Dec));

bar(WPmonth);title('Monthly Wind Power Generated');...
    xlabel('Months');ylabel('Power (kWh/month)');

%To do next:
%- Produce a stack bar chart using the month with the lowest power
%   generated for solar, wind power will match that month
