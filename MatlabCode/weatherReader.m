function [] = weatherReader()
% DO NOT RUN
% downloads the data for the weather and saves them as a matrix and a
% structure
%
% run: *load('weatherMAT.mat')* for matrix
% run: *load('weatherSTRUCT.mat')* for structure

% for design summer year (dsy)
[wMATdsy,~,cdsy] = xlsread('../CIBSE approved Edinburgh Weather data.xls','Design Summer Year');
t = cell(1,20);
for i = 1:10
    t(i*2-1) = {cdsy{3,i}(~isspace(cdsy{3,i}))};
    t(i*2) = {wMATdsy(:,i)};
end

wSTRUCTdsy = struct(t{:});
save('weatherSTRUCTdsy.mat','wSTRUCTdsy')
save('weatherMATdsy.mat','wMATdsy')

% for test ref. year (try)
[wMATtry,~,ctry] = xlsread('../CIBSE approved Edinburgh Weather data.xls','Test Ref Year');
t = cell(1,20);
for i = 1:10
    t(i*2-1) = {ctry{3,i}(~isspace(ctry{3,i}))};
    t(i*2) = {wMATtry(:,i)};
end

wSTRUCTtry = struct(t{:});
save('weatherSTRUCTtry.mat','wSTRUCTtry')
save('weatherMATtry.mat','wMATtry')
end