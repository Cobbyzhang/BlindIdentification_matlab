function [ n, n_alpha ] = identify_n_Gauss( r, gammaOpt, iteration )
%IDENTIFY_N_GAUSS 

%% ���ɽضϾ��� r -> R
% MaxN = 60; % ���Ե�n�����ֵ
maxN = floor(sqrt(size(r,2))); % ��������������û������
% gammaOpt = 0.6;  �����о�����
Z_l = zeros(1, maxN); % 
for l = 2:maxN  %l��ʾ��ǰ����
%iter = 5;
    L = floor(size(r, 2) / l); % L��ʾ��ǰ����
    R_save = reshape(r(1: l * L), l, L)'; % ��ǰ�ضϾ���
    decision = (L - l) * gammaOpt / 2; % �о�����


%% ������������к��У�����
%Iteration

    for iteri = 1:iteration
        R = R_save;
        permutation = randi(L, [1, l]);
        R_temp = R(1:l, :);
        R(1:l, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        [G, ~] = LT_transfer(R); % �ֽ�
        N_l = sum(G, 1); % ÿһ�е�1�ĸ�������ĳһ��1�ĸ���С������ʱ����Ϊ��һ���������е��������
        Z_l(l) = Z_l(l) + nnz(find(N_l < decision));  % Number of nonzero matrix elements��Ҳ���ǣ�����Ϊlʱ���ж��ٸ�������ϵ���
    end

end

%% �ҵ�n 
f = find(Z_l>0); % �ҵ����е���������ص�l����˵��l��ʱΪn�ı���
if numel(f)<2
    n = 0;
    n_alpha = 0;
    disp('Identify insuccessfully')
    return
end
n = f(2)-f(1); % ��ֵ���ǹ��Ƶ�n
n_alpha = f(1);

end

