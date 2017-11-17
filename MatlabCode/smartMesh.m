function [y] = smartMesh(x, xb, yb)
% smart mesh makes the mesh smaller closer to the start
% all inputs are columns
% used in thermalGain

a = [xb,yb];
a = sort(a,1);

b = repmat(x,1,size(a,1))>repmat(a(:,1)',size(x,1),1);

c = sum(b,2);
c(c==0)=1;

d = ((x-xb(c))./(xb(c+1)-xb(c)));

y = d.*(yb(c+1)-yb(c))+yb(c);
end