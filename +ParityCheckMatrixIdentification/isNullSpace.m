function isornot = isNullSpace(v1, poly1, v2, poly2)
%ISPARITYCHECKMATRIX 此处显示有关此函数的摘要
%   
x1 = TypeConversion.poly2symmat(v1, poly1);
x2 = TypeConversion.poly2symmat(v2, poly2).';
result = mod(collect(x1 * x2), 2);
isornot = all(result(:) == 0);

end

