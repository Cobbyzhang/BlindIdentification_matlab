function [a] = gcdOfTwobinVecOverGF2(a, b)
%ISTWOPOLYRELATIVELYPRIME �������������Ϊ0����������Ϊ��������������飬�������
%   
while sum(b) > 0
    t = b;
    [~, remd] = gfdeconv(a,b);
    b = remd;
    a = t;
end

end

