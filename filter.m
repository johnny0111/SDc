function [xkk,pkk] = filter(model, xk, Pk, y, u, W, V)

A = model.A;
B = = model.B;
C = = model.C;
D = = model.D;
xk1 = A*xk + B*u; %a priori estimate
pk1 = A*Pk*A' + W
K = pk1*C'*inverse((C*pk1*C' + V));%kalman gain
xk = xk1 + K*(y - C*xk1)%corrected xk
Pk = %corrected pk
end

