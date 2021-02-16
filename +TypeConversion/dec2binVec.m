function [ binVec ] = dec2binVec( dec, order, high_order )
%DEC2BINVEC 将一个二进制向量转换为十进制数
%   binVec为一个二进制向量，默认输出左边为高位，右边为低位
%   high_order 为高位所在位置
%   dec是输入的十进制数

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

