function [ a ] = symmat2num( symmat )
% 
a = zeros(size(symmat));
for iter = 1:numel(symmat)
    if symmat(iter)==0||symmat(iter) == 1
        a(iter) = symmat(iter);
    else
        a(iter) = bin2dec(num2str(sym2poly(symmat(iter))));
    end
end

end

