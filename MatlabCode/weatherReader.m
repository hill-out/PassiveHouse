function [] = weatherReader()
% DO NOT RUN
% downloads the data for the weather and saves them as a matrix and a
% structure
%
% run: *load('weatherMAT.mat')* for matrix
% run: *load('weatherSTRUCT.mat')* for structure
[wMAT,~,c] = xlsread('../CIBSE approved Edinburgh Weather data.xls');
t = cell(1,20);
for i = 1:10
    t(i*2-1) = {c{3,i}(~isspace(c{3,i}))};
    t(i*2) = {wMAT(:,i)};
end

wSTRUCT = struct(t{:});
save('weatherSTRUCT.mat','wSTRUCT')
save('weatherMAT.mat','wMAT')
end