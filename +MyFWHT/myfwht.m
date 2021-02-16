function [ Y ] = myfwht( a )
%MYFWHT 完成自定义的快速walsh-hadamard变换

%% 数据类型检查
if ~isnumeric(a)
    error('Parameter class error')
end

%% 维数读取
m = numel(a);
pow = log2(m);

%% 维数检查，不为2的幂次则报错
if 2^pow ~= m
    error('Dimension error')
end

%% 预处理和基础参数定义
curr_column = 1;
curr_row = m;
cursor = curr_row/2;
a = reshape(a,[],1);


%% 快速walsh hadamard变换
for iter = 1:pow
    a = [a(1:cursor,:)+a(cursor+1:end,:);a(1:cursor,:)-a(cursor+1:end,:)];
    a = reshape(a,cursor,[]);
    curr_column = curr_column * 2;
    cursor = cursor / 2;
    curr_row = curr_row / 2;
    
end
Y = a;












