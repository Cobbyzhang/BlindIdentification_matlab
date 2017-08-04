%% 验证算法一：验证gx的遍历性质
% g遍历0-D^(degT+1）-1，x遍历0-D^k-1
% 如果g与D^(k+1)互质，gx在mod(D^(k+1))意义下遍历D^k的所有同余类

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