function [ result ] = Multi_gcd( a )
%����ֵ�����Լ��
num = numel(a);
%a(a == 0) = 1;
for i = 1 : num - 1
    a(num - i) = gcd(a(num - i + 1), a(num - i));
end
result = a(1);
end

