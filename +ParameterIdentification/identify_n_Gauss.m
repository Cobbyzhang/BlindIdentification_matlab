function [ n, n_alpha ] = identify_n_Gauss( r, gammaOpt, iteration, rowNumber )
%IDENTIFY_N_GAUSS 


if nargin < 4
    rowNumber = 1000;
end
%% 生成截断矩阵 r -> R
% MaxN = 60; % 尝试的n的最大值
maxN = min(floor(sqrt(size(r,2))),25); % 行数大于列数就没意义了
% gammaOpt = 0.6;  最优判决门限
Z_l = zeros(1, maxN); % 
for itern = 2:maxN  %l表示当前列数
%iter = 5;
    
    R = Tool.reshapeMatrixWithRow(r,itern)'; % 当前截断矩阵
    rowNumber = min(size(R,1), rowNumber); % L表示当前行数
    decision = (rowNumber - itern) * gammaOpt / 2; % 判决门限
    R = R(1:rowNumber,:);

%% 随机交换部分行和列，计算
%Iteration

    for iteri = 1:iteration
        permutation = randi(rowNumber, [1, itern]);
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        
        
        [G, ~] = MatrixTransfer.LT_transfer(R,4); % 分解
%         [G0, B0] = MatrixTransfer.LT_transfer(R); % 分解
%        G = mod(R*B,2);
%         if ~isequal(G0,G(1:l,:))%||~isequal(B0,B)
%             disp(G0)
%             disp(G(1:l,:))
%         end


        N_l = sum(G(itern + 1 : end, :), 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
        
%         if nnz(N_l < decision)
%             disp(B(:,N_l < decision).')
%             pause
%         end
        
        Z_l(itern) = Z_l(itern) + nnz(find(N_l < decision));  % Number of nonzero matrix elements，也就是；列数为l时，有多少个线性组合的列
    end

end

%% 找到n 
f = find(Z_l > 0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
if numel(f)<2
    n = 0;
    n_alpha = 0;
    disp('Identify insuccessfully')
    return
end
n = f(2)-f(1); % 差值就是估计的n
n_alpha = f(1);

if n~= 3 || n_alpha ~= 12
     disp(n)
     disp(n_alpha)
end

end

