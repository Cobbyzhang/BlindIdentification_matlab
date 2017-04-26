function [ Row ] = RowCalculation( matrix, row, weight )
% ��һ��������㣬row���к���ɵľ���
% ����Ӧ�кż�Ȩ����õ�����

%% ���
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

%% ����
if size(weight,1)==1      % ���һ��weight Ϊһά����
    rr = num2cell(row,2);
    f = @(x) fWeighting(matrix(x{:},:),weight);
    Row = cell2mat(arrayfun(f,rr,'un',0));
elseif size(row,1) == 1   % �����,rowΪһά����  
    ww = num2cell(weight,2);
    M =matrix(row,:);
    f = @(x)fWeighting(M,x{:});
    ww = arrayfun(f,ww,'un',0);
    Row = cell2mat(ww);
end
end

