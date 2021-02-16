function [k, u] = estimation_of_k_u(n, n_alpha)
% ����n��n_alphaֵ������ܵ�k��u
%% �������
if n<2 || rem(n_alpha,n)
    error('Parameter Error!')
end

%% ��������
SIZE = n * (n - 1) / 2;
k = zeros(1, SIZE);
u = zeros(1, SIZE);
flag = 0;
alpha = n_alpha / n;

%%
for iterk = 1 : n - 1
    for iterZ = 1 : n - iterk
        flag = flag + 1;
        k(flag) = iterk;
        u(flag) = (n - iterk) * alpha - iterZ;
    end
end

for iter = SIZE : -1 : 1
    if u(iter) < k(iter) || u(iter) < n - k(iter)
        k(iter) = [];
        u(iter) = [];
    end
end

end

