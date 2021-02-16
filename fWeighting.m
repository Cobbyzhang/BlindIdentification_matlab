function [ c ] = fWeighting( a, b )
% 加权函数
% a 待计算的标量矩阵，每一行对应一个多项式，最左侧为最低位
% b 十进制数字向量表示的权值向量，代表一个多项式权值向量，其每个值的二进制形式的高位对应着多项式形式的高位
%   如果b为一个值则对a的每一行均乘上这个权值，若为一个向量，则a的对应行乘以对应的权值
% c 输出结果，仍然为一个标量矩阵
%% 检查
if size(b,1)>1 ||(numel(b)>1 && size(b,2)~=size(a,1)) % 检查b的维数，要么为一维数组且列数和a的列数相同，要么为一个数
    disp('Wrong(dimention do not match)!')
    return
end
if any(rem(b,1)) ||any(b(b < 0)) % b 的元素必须为自然数
    disp('Wrong!')
    return
end

%% 加权计算
c = false(1,size(a,2));
if numel(b)==1
    c = fWeightingBasic(a,b);
else
    for iter = 1:numel(b)
        c = xor(c,fWeightingBasic(a(iter,:),b(iter)));
    end
end
end

