function [ rowNumber ] = FindRow( row, matrix, inclusion )
% 找row 在matrix中的哪一行，返回行号，否则返回0
% inclusion一个向量表示寻找的行数
%% 检查
if nargin < 3 
    M = matrix;
    inclusion = 1:size(M,1);
elseif size(row,2) ~= size(matrix,2) || isempty(inclusion) || max(inclusion)>size(matrix,1)
    %disp('Wrong!');
    rowNumber = [];
    return 
else
    inclusion = reshape(inclusion,1,[]);
    M = matrix(inclusion,:);
end

%% 高级操作，判断row的每一行与matrix的哪一行相同
rr = num2cell(row,2);
f = @(x) find(sum(bsxfun(@ne,M,x{:}),2)==0,1);
rowTempCell = arrayfun(f,rr,'un',0);
for iter =1:numel(rowTempCell)
    if isempty(rowTempCell{iter})
        rowTempCell{iter} = 0;
    else
        rowTempCell{iter} = inclusion(rowTempCell{iter});
    end
end
rowNumber = cell2mat(rowTempCell);
end

