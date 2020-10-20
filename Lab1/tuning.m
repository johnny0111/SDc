function [F,G] = tuning (A) 
    [F,Gd] = deconv(A, eye(1, length(A)));
    G = [Gd( 2:(length(Gd))) zeros(1) ];

end