function [ xt ] = T_transfer( x, t )
% t±ä»»
k = size(x, 1);
if size(t, 1) ~= k || size(t, 2) ~= k
    disp('Wrong(dimention do not match)!')
    return
end

tt = num2cell(t.',2);
f = @(X) fWeighting(x,X{:});
xt = cell2mat(arrayfun(f,tt,'un',0));

end

