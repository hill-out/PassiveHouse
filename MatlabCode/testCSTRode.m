s = [-1,  0;
     -1, -2;
      1,  0;
      0,  1]; 
k = [0.75, 1.5];       % L/(mol min)
c_in = [2; 1.5; 0; 0];     % mol/L
V = 500;                  % L
q_in = [14; 14; 0; 0];

ode15s(@(t,c)(CSTRode(c, c_in, q_in, k, V, s)),[0 5], c_in)
