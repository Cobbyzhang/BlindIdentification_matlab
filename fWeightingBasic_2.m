function [ c ] = fWeightingBasic_2( a,b )
%基础加权函数2，用于不检查地计算单一权值情况
%采用不同算法，测试发现速度较慢
if b == 1
    c = a;
elseif b~=0
    d = dec2bin(b*bin2dec(num2str(a)));
    c = d(:,1:size(a,2));
else
    c = false(size(a));

end
