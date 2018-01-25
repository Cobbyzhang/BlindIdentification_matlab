function [parityCheckMatrix] = resumeParityCheckMatrix(parityMatrix, n)
%RESUMEPARITYCHECKMATRIX �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��


k = n - size(parityMatrix, 1);
if size(parityMatrix, 2) ~= k + 1
    error('Parameter Error!');
end

parityCheckMatrix = zeros(n - k, n);
parityCheckMatrix(:, 1:k) = parityMatrix(:, 1:k);
for iter = 1 : n - k
    parityCheckMatrix(iter, k + iter) = parityMatrix(iter, k + 1);
end

end

