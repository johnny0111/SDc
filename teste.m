clc, clear al

A = [-0.5 0.2; 0.3 -0.2];
B = [0.1 0.4]';
C = [1 -1];
P = 4*eye(2,2);
Y = [1 2.1 3 3.4 3.1];
W = 1.1 * diag(P);
V = 0.5;





function [u] = uk(k)
    u = exp(-k) + sin(k);
end