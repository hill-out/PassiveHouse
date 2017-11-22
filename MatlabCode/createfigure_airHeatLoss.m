function createfigure_airHeatLoss(X1, YMatrix1)
%CREATEFIGURE(X1, YMATRIX1)
%  X1:  vector of x data
%  YMATRIX1:  matrix of y data

%  Auto-generated by MATLAB on 21-Nov-2017 19:07:15

% Create figure
figure1 = figure('Color',...
    [0.941176474094391 0.941176474094391 0.941176474094391]);

% Create axes
axes1 = axes('Parent',figure1);
hold(axes1,'on');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Walls');
set(plot1(2),'DisplayName','Windows');
set(plot1(3),'DisplayName','Foundation');
set(plot1(4),'DisplayName','Air Tightness');
set(plot1(5),'DisplayName','MVHR');
set(plot1(6),'DisplayName','Stack Vent');

% Create xlabel
xlabel('Time [hr]');

% Create ylabel
ylabel('Heat Loss [W]');

% Uncomment the following line to preserve the X-limits of the axes
% xlim(axes1,[0 167]);
box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[0 12 24 36 48 60 72 84 96 108 120 132 144 156 167]);
% Create legend
legend(axes1,'show');


