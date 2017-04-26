function [ Row ] = RowCalculation( matrix, row, weight )
% 进一步抽象计算，row是行号组成的矩阵
% 将对应行号加权计算得到向量

%% 检查
if nargin < 3
    weight = ones(1, size(row,2));
end
if isempty(weight)
    Row = zeros(1,size(matrix,2));
    return
end
if max(max(row)) > size(matrix,1) || min(min(row)) < 1
    disp('Wrong(exceed matrix dimension)!')
    return
end
if size(weight,2) ~= size(row,2) ||(size(weight,1)>1 && size(row,1)>1)
    disp('Wrong(row and weight do not match)!')
    return
end

%% 计算
if size(weight,1)==1      % 情况一，weight 为一维数组
    rr = num2cell(row,2);
    f = @(x) fWeighting(matrix(x{:},:),weight);
    Row = cell2mat(arrayfun(f,rr,'un',0));
elseif size(row,1) == 1   % 情况二,row为一维数组  
    ww = num2cell(weight,2);
    M =matrix(row,:);
    f = @(x)fWeighting(M,x{:});
    ww = arrayfun(f,ww,'un',0);
    Row = cell2mat(ww);
end
end

