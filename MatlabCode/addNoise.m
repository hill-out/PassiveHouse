function [ny] = addNoise(y, step, nP, r)
% converts temperature data into noisy data
%
% y - spme parameter [nx1]
% step - step 
% nP - noise Power
% r - remove 0's
%
% ny - noisy y


x = 0:1:(numel(y)+1);
xx = 0:(1/step):((numel(y)+1));

y = [y(1); y; y(end)];
yy = spline(x,y,xx);

ny = awgn(yy,nP);
%ny = yy;

if r
    expandy = reshape(repmat(y,1,2)',[],1);
    %ny(expandy(1:end-1)==0)=0;
    ny(expandy==0)=0;
    ny(ny < 0) = 0;
end

ny = [ny(1+floor(step/2):end),ny(1:floor(step/2))];
end