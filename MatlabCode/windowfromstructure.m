%function to subtract window area from exterior wall area. 

function [structure] = windowfromstructure(structure,windows);

% Windows [x,y,z,L,H,nx,ny,nz,th]
% Structure [x,y,z,L,H,A,nx,ny,nz,k_insul,L_insul]

for i = 1:1:size(structure,1)

    for k = 1:1:size(windows,1)
        if all(structure(i,7:9) == windows(k,6:8))
            structure(i,6) = structure(i,6) - windows(k,4)*windows(k,5);
        end
    end
end
