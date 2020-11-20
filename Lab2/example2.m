% Kalman filter - Filtering a time-series (Example 2)
clear all, close all, clc
disp('Example 2: Data filtering')
N = 200;
readings = 21*ones(N,1)+.5*randn(N,1); % Generate values from a normal...
%                                            distribution with mean 21 and
%                                            standard deviation .5^2

Pk = 10; % Covariance matrix
W = 0.001; % Process noise variance
V = var(readings); % Process noise variance
xmean = mean(readings);
xf = zeros(N,1);

for k = 1: length(readings) % Kalman filter implementation

if k == 1, x = xmean;
else x = xf(k-1,1);
end
Pk = Pk+ W;
K = Pk*(Pk+V)^-1;
xf(k,1)= x + K*(readings(k,1)-x);
Pk = (1-K)*Pk;
end % End KF

plot(readings,'*b'), hold on, plot(xf,'r')
title('Kalman Filtering')
ylabel('Reading [V]')
xlabel('Sample')
legend('Readings','Smooth','Location','best')

