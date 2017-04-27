function [ c ] = fWeightingBasic( a,b )
%基础加权函数，用于不检查地计算单一权值情况
c = false(size(a));
while b ~= 0
    q = rem(b,2);
    b = fix(b/2);
    if q==1
        c = xor(c,a);
    end
    a = [zeros(size(a,1),1),a(:,1:end-1)];
end
end


