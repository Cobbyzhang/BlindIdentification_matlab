function [ A,T,B ] = IF_decomposition( G )
% 不变因子分解定理











%%  还需排除有一个元素为1 的情况
[k,n] = size(G);
T = G;
A = eye(k);
B = eye(n);
for iter = 1:k
    while numel(find(T(:,iter)~=0,2))==2
        row = find(T(:,iter)~=0,2);
        if T(iter,iter)==0  % 
            T([iter,row(1)],:) = T([row(1),iter],:); % 调换两行
            A(:,[iter,row(1)]) = A(:,[row(1),iter]);
        end
        T([iter+1,row(2)],:) = T([row(2),iter+1],:);
        A(:,[iter+1,row(2)]) = A(:,[row(2),iter+1]);
        [delta,a,b] = gcd(T(iter,iter),T(iter+1,iter),'x');
        eleMat = sym(eye(k));
        eleMat(iter,iter) = mod(a,2);
        eleMat(iter,iter+1) = mod(b,2);
        eleMat(iter+1,iter) = mod(T(iter+1,iter)/delta, 2);
        eleMat(iter+1,iter+1) = mod(T(iter,iter)/delta, 2);
        T = mod(eleMat * T, 2);
        A = mod(A * eleMat, 2);
    end
    delete(a)
    delete(b)
    delete(delta)
    while numel(find(T(iter,:)~=0,2))==2
        column = find(T(iter,:)~=0,2);
        if T(iter,iter)==0  % 
            B([iter,column(1)],:) = B([column(1),iter],:); % 调换两行
            T(:,[iter,column(1)]) = T(:,[column(1),iter]);
        end
        B([iter+1,column(2)],:) = B([column(2),iter+1],:);
        T(:,[iter+1,column(2)]) = T(:,[column(2),iter+1]);
        [delta,a,b] = gcd(T(iter,iter),T(iter,iter+1),'x');
        eleMat = sym(eye(n));
        eleMat(iter,iter) = mod(a,2);
        eleMat(iter+1,iter) = mod(b,2);
        eleMat(iter,iter+1) = mod(T(iter+1,iter)/delta, 2);
        eleMat(iter+1,iter+1) = mod(T(iter,iter)/delta, 2);
        T = mod(T * eleMat, 2);
        B = mod(eleMat * B, 2);
    end    
    
    
    
    
end



end