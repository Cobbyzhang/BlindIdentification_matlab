function [ matrix ] = reshapeMatrixWithRow( matrix, row )
%reshapeMatrixWithRow �������ʹ������reshape���󣬶���Ĳ�����������λ������ȥ
%   ע�⣬���ﰴ�д��棬ʵ��������Matrix������Vector����Ϊmatlab���þ���洢��ʽ�ǰ��д���
%   matrix �������
%   row    ����
len = numel(matrix);
len = len - rem(len,row);
matrix = reshape(matrix(1:len),row,[]);

end

