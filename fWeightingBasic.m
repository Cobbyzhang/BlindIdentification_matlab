function [ c ] = fWeightingBasic( a,b )
%������Ȩ���������ڲ����ؼ��㵥һȨֵ���
c = false(size(a));
while b ~= 0
    q = rem(b,2);
    b = fix(b/2);
    if q==1
        c = xor(c,a);
    end
    a = [zeros(size(a,1),1),a(:,1:end-1)];
end
end


