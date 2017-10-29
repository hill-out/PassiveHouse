function [out] = surfaceDefiner(a)
% defines the position, size, direction, etc. of all surfaces and outputs
% the surface matrix in a cell for each requested surface
%
% surfaceDefiner('w') gets windows


out = {[]};
for i = 1:numel(a)
    if a(i)=='w'
        % Windows [x,y,z,L,H,nx,ny,nz]
        windows = [0, 0, 0, 3, 2, 1, 0, 0;
                   0, 0, 0, 4, 2, 1, 0, 0;
                   0, 0, 0, 3, 2, 0, 1, 0;
                   0, 0, 0, 3, 2, -1, 0, 0]; %currently ignoring [x,y,z]
        out{i} = windows;
    elseif a(i)=='g'
        % Windows [x,y,z,L,H,nx,ny,nz]
        walls = [0,0,0,0,0,0,0,0];
    else
        out{i} = [];
    end
end
end

