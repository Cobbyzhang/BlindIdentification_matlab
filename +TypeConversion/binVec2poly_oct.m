function [oct] = binVec2poly_oct(binVec)
%BINVEC2OCT 把二进制向量转换为poly函数中使用的八进制数（并非真实的八进制数，而是八进制表示的生成器）
%   

s = size(binVec, 2);
if rem(s,3) == 1
    binVec = [0, 0, binVec];
end
if rem(s,3) == 2
    binVec = [0, binVec];
end

binVec = reshape(binVec, 3, [])';
oct = 0;
for iter = 1: ceil(s / 3)
    oct = 10 * oct + TypeConversion.binVec2dec(binVec(iter, :),'right');
end



end

