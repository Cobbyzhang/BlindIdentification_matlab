function [ matrix ] = reshapeMatrixWithRow( matrix, row )
%reshapeMatrixWithRow 允许仅仅使用行数reshape矩阵，多余的不超过行数的位将被舍去
%   注意，这里按行储存，实际上这里Matrix限制于Vector，因为matlab内置矩阵存储方式是按列储存
%   matrix 输入矩阵
%   row    行数
len = numel(matrix);
len = len - rem(len,row);
matrix = reshape(matrix(1:len),row,[]);

end

