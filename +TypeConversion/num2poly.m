function [poly] = num2poly(num, l, t)
%NUM2POLY 此处显示有关此函数的摘要
%   此处显示详细说明
vec = TypeConversion.dec2binVec(num, l);
vec = reshape(vec,t,[])';
poly = TypeConversion.binVec2poly(vec);

end

