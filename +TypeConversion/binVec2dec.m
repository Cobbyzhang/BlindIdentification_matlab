function [ dec ] = binVec2dec( binVec, high_order )
%BINVEC2DEC 将一个二进制向量转换为十进制数
%   binVec为一个二进制向量，默认左边为高位，右边为低位
%   high_order 为高位所在位置
%   dec是返回的十进制数
%   不检查是否真为binVec向量


%   突然发现描述除了错误，实际上左侧为默认低位，这意味着如果要转换为十进制数应该是right模式
%   设计目的是针对多项式结构的变换，默认左侧为低延迟位，右侧为高延迟
%   懒得改了，要是谁看到自己注意点吧


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

