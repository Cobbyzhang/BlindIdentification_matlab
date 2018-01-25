function [poly] = binVec2poly(Vector)
%BINVEC2POLY 此处显示有关此函数的摘要
%   此处显示详细说明
% if rem(size(Vector, 2), t) ~= 0 || size(Vector, 1) > 1
%     error('Parameter Error!');
% end
% 
% if nargin < 3
%     extraction = 'continue';
% end
% 
% 
% if strcmp(extraction,'continue')
%     Vector = reshape(Vector,t,[])';
% elseif strcmp(extraction,'jump')
%     Vector = reshape(Vector,t,[]);
% end
%%
n = size(Vector, 1);
poly = zeros(1,n);
for iter = 1 : n
    poly(iter) = TypeConversion.binVec2poly_oct(Vector(iter, :));
end


end

