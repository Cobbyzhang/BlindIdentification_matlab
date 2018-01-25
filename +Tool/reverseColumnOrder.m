function [R] = reverseColumnOrder(R, n)
%以t为循环周期将矩阵R的列逆序
%   用以在计算监督矩阵时重新排列系数的顺序（计算的向量是逆序的）

if rem(size(R, 2), n) ~= 0
    error('Parameter Error!');
end

t = size(R, 2) / n; % 计算u+1的值，也就是每个多项式的位数

for iter = 0 : t - 1 % 由于现在多项式还是交错排列，因此需要以n为块的t个块都翻转
    R( : , iter * n + 1 : (iter + 1) * n ) = R( : , (iter + 1) * n : -1 : iter * n + 1 );
end

end

