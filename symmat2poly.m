function [ v, poly ] = symmat2poly( symmat )
% �����ž���ת��Ϊ��Ԫ�����ʽϵ��
%% Ԥ����
[k,n] = size(symmat);
polycell = cell(k,n);
vv = zeros(k,n);

%% ����v
for iter = 1:k*n 
    polycell{iter} = sym2poly(symmat(iter));
    vv(iter) = size(polycell{iter},2);
end
v = max(vv,[],2).';

%% �����Ԫ�����ʽϵ��
for iteri = 1:k
    for iterj = 1:n
        polycell{iteri,iterj} = [zeros(1,v(iteri)-vv(iteri,iterj)),polycell{iteri,iterj}];
    end
end
f = @(x)str2double(dec2base(bin2dec(num2str(fliplr(x{:}))),8));
poly = cell2mat(arrayfun(f,polycell,'un',0));
end