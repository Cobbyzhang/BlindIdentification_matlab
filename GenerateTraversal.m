function [ c ] = GenerateTraversal( a )
%产生遍历矩阵
%% 检查
if isempty(a)
    c = [];
    return
elseif any(a(:)<0) || any(rem(a(:),1))
    disp('Wrong(Unstardard data)!')
    return
elseif size(a,1) ~= 2
    disp('Wrong(dimension)!')
    return
end

%% 产生遍历矩阵
n = size(a,2);
x = cell(n,1);
for iter = 1:n
    x{iter} = 0:a(2,iter);
end
[c{1:n}] = ndgrid(x{:});
c = cell2mat(cellfun(@(a)a(:),c,'un',0));
end

