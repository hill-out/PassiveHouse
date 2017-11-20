function [out] = surfaceDefiner(a)
% defines the position, size, direction, etc. of all surfaces and outputs
% the surface matrix in a cell for each requested surface
%
% surfaceDefiner('w') gets windows
% surfaceDefiner('s') gets structure
% surgaceDefiner('ws') gets windows and sturcture (in the order of 'ws')
%
% w - windows [incomplete]
% s - structure (walls, roof, etc.) [incomplete]
% t - thermal mass [incomplete]
% p - solar panel
%
out = {[]};
for i = 1:numel(a)
    if a(i) == 'w'
        % Windows [x,y,z,L,H,nx,ny,nz,th,bar]
  
        windows = [0, 0, 0, 1.6, 1, 1, 0, 0, 1, 0;     %kitchen
                   0, 0, 0, 2, 1, 0, -1, 0, 1, 0;      %kitchen
                   0, 0, 0, 2, 2.06, 1, 0, 0, 2, 0;    %dining
                   0, 0, 0, 1.3, 2.06, 1, 0, 0, 2, 1;     %dining
                   0, 0, 0, 0.8, 2.92, 0, -1, 0, 2, 0; %dining
                   0, 0, 0, 1.3, 2.06, 1, 0, 0, 3, 1;     %library
                   0, 0, 0, 1.3, 2.06, 1, 0, 0, 3, 1;     %library
                   0, 0, 0, 1.3, 2.06, 1, 0, 0, 4, 1;     %study
                   0, 0, 0, 1.3, 1.5, 1, 0, 0, 5, 1;   %bedroom1
                   0, 0, 0, 1.3, 1.5, 1, 0, 0, 6, 1;   %bedroom2
                   0, 0, 0, 1.3, 1.5, 1, 0, 0, 7, 1;   %single
                   0, 0, 0, 1.3, 2, 1, 0, 0, 8, 1;     %master
                   0, 0, 0, 2, 1, 0, -1, 0, 8, 0;      %master
                   0, 0, 0, 0.8, 1, 0, 1, 0, 0, 0;       %bathroom ground
                   0, 0, 0, 0.8, 1, 0, 1, 0, 0, 0;     %bathroom first
                   0, 0, 0, 3.82, 0.6, -1, 0, 0, 0, 0; %hall first
                   0, 0, 0, 0.7, 1, 0, 1, 0, 0, 0;    %bathroom master
                   0, 0, 0, 9, 0.2, -1, 0, 0, 0, 0];   %Stack 
        
               
        windows(:,4) = windows(:,4)/2;
        out{i} = windows;
    elseif a(i) == 's'
        % Structure [x,y,z,L,H,A,nx,ny,nz,k_insul,L_insul]
        cellulose = [0.037];
        
        structure = [0, 0, 0, 18, 5.7, 70.16, 1, 0, 0, cellulose, 0.3;          %Exterior Wall South
                     0, 0, 0, 7, 5.7, 40.2, 0, -1, 0, cellulose, 0.3;            %Exterior Wall West
                     0, 0, 0, 18, 5.7, 102.7, -1, 0, 0, cellulose, 0.3;         %Exterior Wall North
                     0, 0, 0, 7, 5.7, 40.2, 0, 1, 0, cellulose, 0.3;           %Exterior Wall East
                     0, 0, 0, 5.73, 1.2, 84, cos(pi/6), 0, sin(pi/6), cellulose, 0.3          %South Facing Roof
                     0, 0, 0, 3.05, 1.2, 20.9, 0, 0, 1, cellulose, 0.3];          %North Facing Roof
   
        
        out{i} = structure;
    elseif a(i) == 'f'
        % Foundation [x,y,z,L,H,A,perimeter,nx,ny,nz,k_insul,k_ground,L_insul] 
        EPS300 = [0.033];
        
        foundation = [0, 0, 0, 5, 17, 82.76, 48, 0, 0, 1, EPS300, 1.5, 0.3];               %EPS300 Foundation
   
        out{i} = foundation;
    elseif a(i) == 't'
        %              [1,2,3,4,5,6, 7, 8, 9,   10,11,     12,13,   14]
        % Thermal Mass [x,y,z,A,W,nx,ny,nz,cond,Cp,density,kr,floor,furn]
        concrete = [1.130, 1000, 2000, 0.3]; % http://www.iesve.com/downloads/help/ve2012/Thermal/ApacheTables.pdf
        gFW = 0.2;
        fFW = 0.1;
        
        thermalMass = [0, 0, 0, 10.26, gFW, 0, 0, 1, concrete, 0, 0.5; %kitchen (1)
                       0, 0, 0, 22.5, gFW, 0, 0, 1, concrete, 0, 0.3; %dining (2)
                       0, 0, 0, 16.11, gFW, 0, 0, 1, concrete, 0, 0.3; %library (3)
                       0, 0, 0, 8.67, gFW, 0, 0, 1, concrete, 0, 0.3; %study (4)
                       0, 0, 2.7, 13.71, fFW, 0, 0, 1, concrete, 1, 0.3; %bedroom 1 (5)
                       0, 0, 2.7, 12.08, fFW, 0, 0, 1, concrete, 1, 0.3; %bedroom 2 (6)
                       0, 0, 2.7, 8.54, fFW, 0, 0, 1, concrete, 1, 0.3; %single (7)
                       0, 0, 2.7, 15.67, fFW, 0, 0, 1, concrete, 1, 0.3]; %master (8)
                       
        
        out{i} = thermalMass;
        
    elseif a(i) == 'p'
        % solarPanel [pL,pH,NUM,eff,nx,ny,nz]
        pL = 1053/1000;
        pH = 1590/1000;
        solarPanel = [pL, pH, 39, 0.197, cos(14*pi/180), 0, sin(14*pi/180)];          
        
        out{i} = solarPanel;
    else
        out{i} = [];
    end
end
end

