clear
clc
%% 寻找最优解实验

k = 3;
degT = 1;
result = zeros(2^k,2^(degT+1));
start = 2^degT+1;
for iter = start :2 ^k
    x2 = dec2bin(iter-1, k) - 48;
    for f = 1 : 2^(degT+1)
        result(iter,f) = bin2dec(num2str(fWeightingBasic(x2, f-1)));
    end
end

disp(result(start:end,:))

%% 寻找最优解
% 