function [ result ] = Multi_lcm( a )
%求多个值的最小公倍数
num = numel(a);
%a(a == 0) = 1;
for i = 1 : num - 1
    a(num - i) = lcm(a(num - i + 1), a(num - i));
end
result = a(1);
end

