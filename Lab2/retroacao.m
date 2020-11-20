function [ K,Kf,m ] = retroacao( A,B,C,P,Q,R,m,kfinal,ref )
    for k=kfinal:-1:1
       P(:,:,k)=A'*P(:,:,k+1)*(eye(size(A,1))-B*inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1))*A+C'*Q*C;
       m(:,k)=(A'-A'*P(:,:,k+1)*B*inv(B'*P(:,:,k+1)*B+R)*B')*m(:,k+1)+C'*Q*ref(k);
       K(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B'*P(:,:,k+1)*A;
       Kf(:,:,k)=inv(B'*P(:,:,k+1)*B+R)*B';
    end
end

