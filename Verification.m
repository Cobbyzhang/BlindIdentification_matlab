%% ��֤�㷨һ����֤gx�ı�������
% g����0-D^(degT+1��-1��x����0-D^k-1
% ���g��D^(k+1)���ʣ�gx��mod(D^(k+1))�����±���D^k������ͬ����

k = 3;
degT = 2;
result = zeros(2^(degT+1),2^k);
for iter = 1 : 2^k
    x2 = dec2bin(iter-1, k) - 48;
    for f = 1 : 2^(degT+1)
        result(f,iter) = bin2dec(num2str(fWeightingBasic(x2, f-1)));
    end
end

disp(result)