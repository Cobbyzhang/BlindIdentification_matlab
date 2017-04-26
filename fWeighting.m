function [ c ] = fWeighting( a, b )
% 加权函数
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

