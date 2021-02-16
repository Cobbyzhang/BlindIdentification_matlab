function [ matrix ] = reshapeMatrixWithColumn( matrix, column )
%RESHAPEMATRIXWITHCOLUMN 允许仅仅使用列数reshape矩阵，多余的不超过列数的位将被舍去
%   注意，这里按行储存，实际上这里Matrix限制于Vector，因为matlab内置矩阵存储方式是按列储存
%   matrix 输入矩阵
%   column 列数
len = numel(matrix);
len = len - rem(len,column);
matrix = reshape(matrix(1:len),column,[])';

end

