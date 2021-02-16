function [ symmat ] = poly2symmat( v, poly )
% 将二元域多项式系数转换为符号矩阵

%% 检查
if numel(v) ~= size(poly,1)
    disp('dimension does not match!')
    return
end

%% 转换为符号矩阵
f = @(x,y)fliplr(dec2bin(base2dec(num2str(x),8),y)-48);
g = @(x)poly2sym(x{:});
polymat = arrayfun(f,poly,repmat(v.',1,size(poly,2)),'un',0);
symcell = arrayfun(g,polymat,'un',0);
symmat = sym('x')*ones(1,numel(symcell));
for iter = 1:numel(symcell)
    symmat(iter) = symcell{iter};
end
symmat = reshape(symmat,size(poly));
end

