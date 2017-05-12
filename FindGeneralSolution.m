clear
clc
%% Ñ°ÕÒ×îÓÅ½â

n = 3;
degT = 1;
result = zeros(2^n,2^(degT+1));

for iter = 2^degT+1 :2 ^n
    x2 = dec2bin(iter-1, n) - 48;
    for f = 1 : 2^(degT+1)
        result(iter,f) = bin2dec(num2str(fWeightingBasic(x2, f-1)));
    end
end

disp(result(2^degT+1:end,:))