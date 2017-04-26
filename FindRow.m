function [ rowNumber ] = FindRow( row, matrix, inclusion )
% ��row ��matrix�е���һ�У������кţ����򷵻�0
% inclusionһ��������ʾѰ�ҵ�����
%% ���
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

%% �߼��������ж�row��ÿһ����matrix����һ����ͬ
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

