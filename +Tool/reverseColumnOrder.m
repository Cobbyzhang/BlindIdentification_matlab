function [R] = reverseColumnOrder(R, n)
%��tΪѭ�����ڽ�����R��������
%   �����ڼ���ල����ʱ��������ϵ����˳�򣨼��������������ģ�

if rem(size(R, 2), n) ~= 0
    error('Parameter Error!');
end

t = size(R, 2) / n; % ����u+1��ֵ��Ҳ����ÿ������ʽ��λ��

for iter = 0 : t - 1 % �������ڶ���ʽ���ǽ������У������Ҫ��nΪ���t���鶼��ת
    R( : , iter * n + 1 : (iter + 1) * n ) = R( : , (iter + 1) * n : -1 : iter * n + 1 );
end

end

