function [nT] = addTempNoise(T, step)
% converts temperature data into noisy data
%
% T - temperautre [nx1]
% step - step 
%
% nT - noisy T
x = 0:1:(numel(T)+1);
xx = 0:(1/step):((numel(T)+1));

T = [T(1); T; T(end)];
TT = spline(x,T,xx);

nT = awgn(TT+273,10)-273;
nT = nT(step:end-1);
end