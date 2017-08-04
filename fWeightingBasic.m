function [ c ] = fWeightingBasic( a,b )
% 基础加权函数，用于不检查地计算单一权值情况
% a 待计算的标量矩阵，每一行对应一个多项式，最左侧为最低位
% b 十进制数字表示的权值，代表一个多项式权值，其二进制形式的高位对应着多项式形式的高位
% c 输出结果，仍然为一个标量矩阵
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


