function [poly] = num2poly(num, l, t)
%NUM2POLY �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
vec = TypeConversion.dec2binVec(num, l);
vec = reshape(vec,t,[])';
poly = TypeConversion.binVec2poly(vec);

end

