function [ c ] = fWeightingBasic_2( a,b )
%������Ȩ����2�����ڲ����ؼ��㵥һȨֵ���
%���ò�ͬ�㷨�����Է����ٶȽ���
if b == 1
    c = a;
elseif b~=0
    d = dec2bin(b*bin2dec(num2str(a)));
    c = d(:,1:size(a,2));
else
    c = false(size(a));

end
