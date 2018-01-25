function [ xt ] = T_transfer( x, t )
% T变换
% t是一个数值矩阵，对应一个多项式矩阵
% x是一个标量矩阵
% 本函数实际为fWeighting函数对权值矩阵的推广（原函数仅能对权值向量操作）
k = size(x, 1);
if size(t, 1) ~= k || size(t, 2) ~= k
    disp('Wrong(dimention do not match)!')
    return
end

tt = num2cell(t.',2);
f = @(X) fWeighting(x,X{:});
xt = cell2mat(arrayfun(f,tt,'un',0));

end

