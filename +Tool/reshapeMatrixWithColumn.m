function [ matrix ] = reshapeMatrixWithColumn( matrix, column )
%RESHAPEMATRIXWITHCOLUMN �������ʹ������reshape���󣬶���Ĳ�����������λ������ȥ
%   ע�⣬���ﰴ�д��棬ʵ��������Matrix������Vector����Ϊmatlab���þ���洢��ʽ�ǰ��д���
%   matrix �������
%   column ����
len = numel(matrix);
len = len - rem(len,column);
matrix = reshape(matrix(1:len),column,[])';

end

