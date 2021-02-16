function [ Y ] = mywht( a )
%MYWHT 自定义Walsh-Hadamard变换
row = size(a,2);
if log2(a) > 12
    a1 = mywht(a(1:row/2));
    a2 = mywht(a(row/2+1:end));
    Y = [a1+a2,a1-a2];
else
    Y = a * hadamard(row);

end

