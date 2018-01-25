function [h, deg] = my_degree(h, k)
%MYDEGREE 
%   
if rem(numel(h), k)
    deg = 0;
    return
end

h = reshape(h, k, []).';
deg = size(h,1);
while ~any(h(1, :))
    deg = deg - 1;
    h(1, :) = [];
end

if ~h
    return
end
    
d = size(h,1);
while ~any(h(d, :))
    deg = deg - 1;
    h(d, :) = [];
    d = d - 1;
end
h = reshape(h',1,[]);

end

