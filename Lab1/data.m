load arx241_new.mat;
A = arx241.A; % Identificação em diferido
b = arx241.B; % Identificação em diferido
B = b(2:end);
save arxdata.mat A B b -mat -v7.3
return