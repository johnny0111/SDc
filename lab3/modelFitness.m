function f = modelFitness(theta,dctr,yreal)

% dctr;    % Control action
% yreal;   % Plant output

% ARX(3,2,1)
f = 0;
N = length(yreal);
y = zeros(N);

for  index = 4 : N 
    
    y(index) = -theta(1)*y(index-1) - theta(2)*y(index-2) - theta(3)*y(index-3)...
        + theta(4)*dctr(index-2) + theta(5)*dctr(index-3);
    
    f = f + ((y(index)-yreal(index))^2)/(N-4); % MSE - Mean Squared error

end

end