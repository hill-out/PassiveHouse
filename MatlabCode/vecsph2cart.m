function [out] = vecsph2cart(sph)
% converts spherical coords to cartesian using sph2cart but with vectors

[x,y,z] = sph2cart(sph(1),sph(2),sph(3));

out = [x,y,z];

end