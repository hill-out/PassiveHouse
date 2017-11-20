clear; clc;
%The script will load the weather data data and calculate the solar and
%wind power generated

%Progress:
%   Wind power calculation      - Complete
%   Solar power calculation     - Complete
%   Produce stacked bar chart   - Incomplete


%To do next:
%- Produce a stack bar chart using the month with the lowest power
%   generated for solar, wind power will match that month



%Load weather data
load('weatherSTRUCTtry.mat');

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


%%%%%%%%% Calculate Wind Power %%%%%%%%%%
%Turbine specs
%Reference:
%http://renewabledevices.com/rd-swift-turbines/technical/
%https://www.ecopowershop.com/swift-1-5kw-quiet-wind-turbine-system
%http://www.raeng.org.uk/publications/other/23-wind-turbine

d = 2.08; % Turbine Diameter
eff = 0.3; % 30 percent overall efficiency at converting wind to electricity
cutIn = 3.4; % m/s - Wind Cut in speed
maxOutput = 1500; %W - maximum rated power output
n = 1; % Number of turbine

%Calculate Sweeping area
A = pi*(d/2)^2;

%Calculate wind power
%Assuming wind speed is constant for one full hour
%Thus the power output will be in kWh
windSpeedData = wSTRUCTtry.WSpeed;
s = size(windSpeedData);
windPower = zeros(s(1),1);

for i = 1:s(1)
    if windSpeedData(i) < cutIn
        windSpeedData(i) = 0;
    else
        windSpeedData(i) = windSpeedData(i);
        windPower(i) = (1/2 .* airDensity .* A .* (windSpeedData(i)).^3 .* eff); %in Watts
        
        if windPower(i) > maxOutput
            windPower(i) = maxOutput;
        end
    end
end

%Calculate hourly, daily, and total WIND power generated
WPhourly = reshape(windPower,24,365);
WPdaily = sum(WPhourly);
WPtotal = sum(WPdaily);

%Monthly WIND power generated
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

WPmonth = WPmonth'; %Transpose array

% bar(WPmonth);title('Monthly Wind Power Generated');...
%     xlabel('Months');ylabel('Power (kWh/month)');


%Calculate hourly, daily, and total SOLAR power generated
solarPower = overallPVOut(wSTRUCTtry.global,wSTRUCTtry.diffuse, [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR],[]);
SPhourly = reshape(solarPower,24,365);
SPdaily = sum(SPhourly);
SPtotal = sum(SPdaily);

%Monthly WIND power generated
SPmonth(1) = sum(SPdaily(:,1:Jan));
SPmonth(2) = sum(SPdaily(:,Jan+1:Feb));
SPmonth(3) = sum(SPdaily(:,Feb+1:Mar));
SPmonth(4) = sum(SPdaily(:,Mar+1:Apr));
SPmonth(5) = sum(SPdaily(:,Apr+1:May));
SPmonth(6) = sum(SPdaily(:,May+1:Jun));
SPmonth(7) = sum(SPdaily(:,Jun+1:Jul));
SPmonth(8) = sum(SPdaily(:,Jul+1:Aug));
SPmonth(9) = sum(SPdaily(:,Aug+1:Sep));
SPmonth(10) = sum(SPdaily(:,Sep+1:Oct));
SPmonth(11) = sum(SPdaily(:,Oct+1:Nov));
SPmonth(12) = sum(SPdaily(:,Nov+1:Dec));

SPmonth = SPmonth'; %Transpose array




%Stacked Power generated chart for every month
TPowerStack = [SPmonth,WPmonth];
TotalAnnual = sum(sum(TPowerStack));
% bar(TPowerStack, 'stacked'); title('Stacked Monthly Power Generated'); legend({'Solar Power','Wind Power'})



%Rough calculations for Dec
meanSPdailyDec = mean(SPhourly(:,Nov+1:Dec),2);
meanWPdailyDec = mean(WPhourly(:,Nov+1:Dec),2);
meanTPdailyDec = sum([meanSPdailyDec , meanWPdailyDec],2);
% figure; bar(meanTPdailyDec); title('Mean Total Hourly Power Generated in Dec')
