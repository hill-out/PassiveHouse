function [out] = surfaceDefiner(a)
% defines the position, size, direction, etc. of all surfaces and outputs
% the surface matrix in a cell for each requested surface
%
% surfaceDefiner('w') gets windows
% surfaceDefiner('s') gets structure
% surgaceDefiner('ws') gets windows and sturcture (in the order of 'wg')
%
% w - windows [incomplete]
% s - structure (walls, roof, etc.) [incomplete]
% t - thermal mass [incomplete]
%
out = {[]};
for i = 1:numel(a)
    if a(i) == 'w'
        % Windows [x,y,z,L,H,nx,ny,nz]
        windows = [0, 0, 0, 3, 2, 0, 1, 0;
                   0, 0, 0, 4, 2, 0, 1, 0;
                   0, 0, 0, 3, 2, 1, 0, 0;
                   0, 0, 0, 3, 2, 0, -1, 0;
                   0, 0, 0, 2, 2, 0, 1, 1]; %currently ignoring [x,y,z]
        
        out{i} = windows;
    elseif a(i) == 's'
        % Structure [x,y,z,L,H,A,nx,ny,nz,k_insul,L_insul]
        cellulose = [0.037];
        EPS300 = [0.033];
        
        structure = [0, 0, 0, 18, 5.7, 102.6, 0, 1, 0, cellulose, 0.3;          %Exterior Wall South
                     0, 0, 0, 7, 5.7, 39.9, 1, 0, 0, cellulose, 0.3;            %Exterior Wall West
                     0, 0, 0, 18, 5.7, 102.6, 0, -1, 0, cellulose, 0.3;         %Exterior Wall North
                     0, 0, 0, 7, 5.7, 39.9, -1, 0, 0, cellulose, 0.3            %Exterior Wall East
                     0, 0, 0, 5, 17, 79.5, 0, 0, 1, EPS300, 0.3];               %EPS300 Foundation
   
        
        out{i} = structure;
    elseif a(i) == 't'
        % Thermal Mass [x,y,z,L,W,D,nx,ny,nz,cond,Cp,density,kr]
        castConcrete = [1.130, 1000, 2000, 0.3]; % http://www.iesve.com/downloads/help/ve2012/Thermal/ApacheTables.pdf
        
        thermalMass = [0, 0, 0, 5, 17, 0.3, 0, 0, 1, castConcrete;
                       0, 0, 2.7, 5, 17, 0.3, 0, 0, 1, castConcrete];
        
        out{i} = thermalMass;
    else
        out{i} = [];
    end
end
end
