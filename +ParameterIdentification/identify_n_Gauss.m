function [ n, n_alpha ] = identify_n_Gauss( c, r, iteration, defaultRowNumber, gamma )
%IDENTIFY_N_GAUSS 


if nargin < 5
    gamma = 0.6;
end

if nargin < 4
    defaultRowNumber = 1000;
end

%% Optimal threshold
 gammaOpt = gamma;  % 最优判决门限


%% 生成截断矩阵 r -> R
MaxN = 30; % 尝试的n的最大值
maxN = min(floor(sqrt(size(r, 2))), MaxN); % 行数大于列数就没意义了



for iteri = 1 : iteration
    Z_l = zeros(1, maxN);
    H = cell(MaxN);
    for itern = 2:maxN  %l表示当前列数
        R_noiseless = Tool.reshapeMatrixWithColumn(c,itern);
        rowNumber = min(size(R_noiseless, 1), defaultRowNumber + itern); % L表示当前行数
        decision = (rowNumber - itern) * gammaOpt / 2; % 判决门限

    %% 随机交换部分行和列，计算
        R = Tool.reshapeMatrixWithRow(r,itern)'; % 当前截断矩阵
        R = R(1:rowNumber,:);
        permutation = randi(rowNumber, [1, itern]);
        % permutation = 1: itern;
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
%         R = ParameterIdentification.EliminateUpperDiagnolNoise(R,
%         R_noiseless(permutation, :)); % 去掉上三角噪声，有部分文献需要
        [G, B] = MatrixTransfer.LT_transfer(R,4); % 分解
        N_l = sum(G(itern + 1 : end, :), 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
        N = find(N_l <= decision);
        if any(N)
            Z_l(itern) = Z_l(itern) + nnz(N);  % Number of nonzero matrix elements，也就是；列数为l时，有多少个线性组合的列
            H{itern} = B(:, N);
        end
    end
    f = find(Z_l > 0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
    if numel(f)>=2
        break;
    end
end

%% 找到n 
f = find(Z_l > 0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
if numel(f)<2
    n = 0;
    n_alpha = 0;
    return
end
n = mode(diff(f),2);
% n = f(2)-f(1); % 原始方法，找到前两个就判断

%% 识别n_alpha
degree = MaxN;
for iter = 1 : numel(f)
    h = H{f(iter)};
    for iter1 = 1:size(h, 2)
        [~, degree_temp] = ParityCheckMatrixIdentification.my_degree(h(:, iter1),n);
        if degree_temp > 0 && degree_temp < degree
            degree = degree_temp;
        end
    end
end
n_alpha = n * degree;
% n_alpha = f(1);  % 错误方法，用第一个判断严重影响正确率

end

