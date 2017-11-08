function [ n, n_alpha ] = identify_n_Gauss( r, gammaOpt, iteration )
%IDENTIFY_N_GAUSS 

%% 生成截断矩阵 r -> R
% MaxN = 60; % 尝试的n的最大值
maxN = floor(sqrt(size(r,2))); % 行数大于列数就没意义了
% gammaOpt = 0.6;  最优判决门限
Z_l = zeros(1, maxN); % 
for l = 2:maxN  %l表示当前列数
%iter = 5;
    L = floor(size(r, 2) / l); % L表示当前行数
    R_save = reshape(r(1: l * L), l, L)'; % 当前截断矩阵
    decision = (L - l) * gammaOpt / 2; % 判决门限


%% 随机交换部分行和列，计算
%Iteration

    for iteri = 1:iteration
        R = R_save;
        permutation = randi(L, [1, l]);
        R_temp = R(1:l, :);
        R(1:l, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        [G, ~] = LT_transfer(R); % 分解
        N_l = sum(G, 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
        Z_l(l) = Z_l(l) + nnz(find(N_l < decision));  % Number of nonzero matrix elements，也就是；列数为l时，有多少个线性组合的列
    end

end

%% 找到n 
f = find(Z_l>0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
if numel(f)<2
    n = 0;
    n_alpha = 0;
    disp('Identify insuccessfully')
    return
end
n = f(2)-f(1); % 差值就是估计的n
n_alpha = f(1);

end

