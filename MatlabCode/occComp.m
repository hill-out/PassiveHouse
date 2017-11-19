load('weatherSTRUCTtry.mat')

t = [wSTRUCTtry.MONTH,wSTRUCTtry.DAY,wSTRUCTtry.HOUR];
solarA = sunSphCoords(t);
solarAcart = vecsph2cart(solarA);

wi = surfaceDefiner('w');
wi = wi{1}(4,:);
wo = wi;
wo(10,1) = 0;

a = zeros(8760,1);
b = zeros(8760,1);

for i=1:8760
    a(i) = occlusion(solarAcart(i),wi,0);
    b(i) = occlusion(solarAcart(i),wo,0);
end