function [oct] = binVec2poly_oct(binVec)
%BINVEC2OCT �Ѷ���������ת��Ϊpoly������ʹ�õİ˽�������������ʵ�İ˽����������ǰ˽��Ʊ�ʾ����������
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

