function [ matrix ] = reshapeMatrixWithColumn( matrix, column )
%RESHAPEMATRIXWITHCOLUMN 允许仅仅使用列数reshape矩阵，多余的不超过列数的位将被舍去
%   matrix 输入矩阵
%   column 列数
len = numel(matrix);
len = len - rem(len,column);
matrix = reshape(matrix(1:len),[],column);

end

