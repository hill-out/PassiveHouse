cT = zeros(20,2,100001);
cT(:,:,1) = ones(20,2)*25;
dt = 4;
for i = 1:100000
    gain = sin((i*dt/43200)*pi)*3000+1400;
    gain(gain<0) = 0;
    cT(:,:,i+1) = thermalGain(gain,0,cT(:,:,i),22,[],[],dt);
    if mod(i,1000) == 0
        x = 1:20;
        y = cT(:,1,i+1);
        h = plot(x,y);
        set(h,'XDataSource','x');
        set(h,'YDataSource','y');
        refreshdata
        pause(0.2)
    end
end

plot(permute(cT(1,1,[1:100:100001]),[3,2,1]))