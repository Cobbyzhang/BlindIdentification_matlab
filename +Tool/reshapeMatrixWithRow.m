function [ matrix ] = reshapeMatrixWithRow( matrix, row )
%reshapeMatrixWithRow �������ʹ������reshape���󣬶���Ĳ�����������λ������ȥ
%   matrix �������
%   row    ����
len = numel(matrix);
len = len - rem(len,row);
matrix = reshape(matrix(1:len),row,[]);

end

