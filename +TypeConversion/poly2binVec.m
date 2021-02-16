function [binVec] = poly2binVec(v, poly)
%POLY2BINVEC 此处显示有关此函数的摘要
%   

binVec = [];
while poly ~= 0
    a = rem(poly, 10);
    poly = (poly - a) / 10;
    if v<3 
        binVec = [dec2bin(base2dec(num2str(a), 8), v) - 48, binVec];
    else
        binVec = [dec2bin(base2dec(num2str(a), 8), 3) - 48, binVec];
    end
    v = v - 3;
end

end

