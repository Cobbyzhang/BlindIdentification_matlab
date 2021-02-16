function [ Y ] = myfwht( a )
%MYFWHT ����Զ���Ŀ���walsh-hadamard�任

%% �������ͼ��
if ~isnumeric(a)
    error('Parameter class error')
end

%% ά����ȡ
m = numel(a);
pow = log2(m);

%% ά����飬��Ϊ2���ݴ��򱨴�
if 2^pow ~= m
    error('Dimension error')
end

%% Ԥ����ͻ�����������
curr_column = 1;
curr_row = m;
cursor = curr_row/2;
a = reshape(a,[],1);


%% ����walsh hadamard�任
for iter = 1:pow
    a = [a(1:cursor,:)+a(cursor+1:end,:);a(1:cursor,:)-a(cursor+1:end,:)];
    a = reshape(a,cursor,[]);
    curr_column = curr_column * 2;
    cursor = cursor / 2;
    curr_row = curr_row / 2;
    
end
Y = a;












