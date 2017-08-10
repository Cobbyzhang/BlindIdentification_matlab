function [ dec ] = binVec2dec( binVec, high_order )
%BINVEC2DEC 将一个二进制向量转换为十进制数
%   binVec为一个二进制向量，默认左边为高位，右边为低位
%   high_order 为高位所在位置
%   dec是返回的十进制数
%   不检查是否真为binVec向量

if nargin < 2
    high_order = 'left';
end

binVec = reshape(binVec,1,[]);
if strcmp(high_order,'left')
    dec = binVec * 2.^(0:numel(binVec)-1)';
elseif strcmp(high_order,'right')
    dec = binVec * 2.^(numel(binVec)-1:-1:0)';
else
    error('Parameter Error!');

end

