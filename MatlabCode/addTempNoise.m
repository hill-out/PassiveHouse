function [nIrr] = addIrrNoise(Irr, step)
% converts temperature data into noisy data
%
% Irr - temperautre [nx1]
% step - step 
%
% nT - noisy T
x = 0:1:(numel(Irr)+1);
xx = 0:(1/step):((numel(Irr)+1));

Irr = [Irr(1); Irr; Irr(end)];
IrrIrr = spline(x,Irr,xx);

nIrr = awgn(IrrIrr,1);
nIrr = nIrr(1:end-step);

end