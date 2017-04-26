function [ c ] = GenerateTraversal( a )
%������������
%% ���
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

%% ������������
n = size(a,2);
x = cell(n,1);
for iter = 1:n
    x{iter} = 0:a(2,iter);
end
[c{1:n}] = ndgrid(x{:});
c = cell2mat(cellfun(@(a)a(:),c,'un',0));
end

