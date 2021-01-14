function f = weightsFitness(weights, theta,r, Ks)

% dctr;    % Control action
% yreal;   % Plant output

% ARX(3,2,1)
f = 0;
N = length(r);
y = zeros(N,1);
ek = zeros(N,1);
u = zeros(N,1);
p = weights(1);
q = weights(2);
w = weights(3);
%u(1:4) = r(1:4);







for  index = 3 : N-1
    u(index) = uctrl(u(index-1), ek(index), ek(index-1), ek(index-2), Ks(1), Ks(2), Ks(3), 0.08);
    y(index+1) = -theta(1)*y(index) - theta(2)*y(index-1) - theta(3)*y(index)...
            + theta(4)*u(index) + theta(5)*u(index-1);
    ek(index+1) = r(index+1) - y(index+1);
   
        f = f + (p * (r(index +1) - y(index + 1))^2 + q * (u(index ))^2 +...
        w * (u(index) - u(index -1))^2)/(N -4); 
end

end