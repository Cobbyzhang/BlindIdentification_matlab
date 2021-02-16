function [ binVec ] = dec2binVec( dec, order, high_order )
%DEC2BINVEC ��һ������������ת��Ϊʮ������
%   binVecΪһ��������������Ĭ��������Ϊ��λ���ұ�Ϊ��λ
%   high_order Ϊ��λ����λ��
%   dec�������ʮ������

if nargin < 3
    high_order = 'left';
end

if ~isnumeric(dec) || (dec < 0 )
    error('Input number error!');
end
if ~strcmp(high_order,'left') && ~strcmp(high_order,'right')
    error('Parameter error!')
end

if nargin < 2
    order = 1;
end

dec = round(dec);
binVec = dec2bin(dec,order) - 48;

if strcmp(high_order,'right')
    binVec = fliplr(binVec);
end

end

