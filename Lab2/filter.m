function [xk1,pk1] = filter(model, xk, pk, y, u, W, V,k)
    A = model.A;
    B = model.B;
    C = model.C;
    xk(:,:,k+1) = A*xk(:,:,k) + B*u(:,k);
    pk(:,:, k+1) = A*pk(:,:,k)*A' + W;
    
    KalmanG = pk(:,:, k+1)*C'*(C*pk(:,:, k+1)*C'+V)^-1;
    xk1(:,:,k+1) = xk(:,:,k+1) + KalmanG*(y(:,k+1)-C*xk(:,:,k+1));
    pk1(:,:,k+1) = (eye(numel(xk(:,:,k+1)))-KalmanG*C) * pk(:,:,k+1);
end

