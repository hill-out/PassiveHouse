function [] = thermalTest()
cT = zeros(20,2,100001);
cT(:,:,1) = ones(20,2)*23;
Qrel = zeros(100001,2);



dt = 4;
for i = 1:100000
    
    gain = gainFunc(i*dt);
    [newT, Qtop] = thermalGain(gain,0,cT(:,:,i),22,[],[],dt);
    cT(:,:,i+1) = newT;
    Qrel(i+1,:) = Qtop;
    
    if mod(i,10000)==0
        a=1;
    end
    
    if mod(i,1000) == 0
        x = [1:20]';
        y = cT(:,1,i+1);
        hold on
        plot(x,y);
        pause(0.2)
    end
    
end
subplot(2,1,1)
plot(permute(cT(1,1,[1:100:100001]),[3,2,1]))

subplot(2,1,2)
plot(Qrel([1:100:100001]))
hold on
plot(gainFunc([1:100:100001]*dt))
plot(Qrel([1:100:100001])+gainFunc([1:100:100001]*dt)*0.3)
function [y] = gainFunc(x)
    y = sin((x/43200)*pi)*2000-400;
    y(y<0) = 0;
end

end