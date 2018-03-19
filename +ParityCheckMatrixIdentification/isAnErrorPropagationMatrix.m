function [TrueOrFalse] = isAnErrorPropagationMatrix(v,Matrix)
%ISABADMATRIX 此处显示有关此函数的摘要
%   此处显示详细说明
if size(v,1) ~= 1 || size(v, 2) ~= size(Matrix, 1) 
    Error('Parameter Error!')
end

for iter = 1 : size(Matrix, 1)
    gcd = Tool.gcdOverGF2(v,Matrix(iter, :));
    if size(gcd, 2) > 1
        TrueOrFalse = 1;
        return
    end
end
TrueOrFalse = 0;


end

