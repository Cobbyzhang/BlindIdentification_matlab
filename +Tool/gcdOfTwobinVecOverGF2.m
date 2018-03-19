function [a] = gcdOfTwobinVecOverGF2(a, b)
%ISTWOPOLYRELATIVELYPRIME 不能有输入参数为0，但这里作为基础函数不做检查，在外层检查
%   
while sum(b) > 0
    t = b;
    [~, remd] = gfdeconv(a,b);
    b = remd;
    a = t;
end

end

