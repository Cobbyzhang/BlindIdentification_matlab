function [ matrix ] = reshapeMatrixWithColumn( matrix, column )
%RESHAPEMATRIXWITHCOLUMN �������ʹ������reshape���󣬶���Ĳ�����������λ������ȥ
%   matrix �������
%   column ����
len = numel(matrix);
len = len - rem(len,column);
matrix = reshape(matrix(1:len),[],column);

end

