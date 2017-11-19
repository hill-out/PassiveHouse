function [q] = occupancyGain(wd,we)

a = repmat([ones(24*5,1);zeros(24*2,1)],53,1);
year_wd = a(1:8760);

b = repmat([zeros(24*5,1);ones(24*2,1)],53,1);
year_we = b(1:8760);

q_wd = repmat(wd,365,1);

q_we = repmat(we,365,1);

q = [year_wd.*q_wd]+[year_we.*q_we];

end




