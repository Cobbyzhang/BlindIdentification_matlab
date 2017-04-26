function [ symmat ] = num2symmat( a )
%Êı×Ö¾ØÕó×ª»»Îª·ûºÅ¾ØÕó
symmat = sym('x')*ones(1,numel(a));
for iter = 1:numel(a)
    symmat(iter) = poly2sym(num2str(dec2bin(a(iter)))-48);
end
symmat = reshape(symmat,size(a));

end

