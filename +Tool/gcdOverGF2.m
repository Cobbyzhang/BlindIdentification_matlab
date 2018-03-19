function [gcd] = gcdOverGF2(v,poly)
% v是一个数
% poly是一个八进制向量

if size(poly,2) ~= 1 || numel(v) ~= 1 
    errror('Parameter Error!!!!')
end
    
f = find(poly~=0);
poly = poly(f);
gcd = TypeConversion.poly2binVec(v, poly(1));

if numel(f) < 2
    return 
end

for iter = 2 : numel(f)
    gcd = Tool.gcdOfTwobinVecOverGF2(gcd, TypeConversion.poly2binVec(v, poly(iter)));
end


end

