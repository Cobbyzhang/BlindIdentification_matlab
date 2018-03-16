function [ n ] = identify_dimension_of_interleaver( c, r, iteration, defaultRowNumber, gamma )
%IDENTIFY_N_GAUSS 


if nargin < 5
    gamma = 0.6; % gammaOpt = 0.6;  最优判决门限
end
if nargin < 4
    defaultRowNumber = 1000;
end

if nargin < 3
    iteration = 1;
end



% C = [];
codeRate = 1;
n = 0;
Smin = 20;
Smax = 120;

%% 生成截断矩阵 r -> R
Smax = min(floor(sqrt(size(r, 2))), Smax); % 行数大于列数就没意义了
for itern = Smin : Smax  % itern表示当前列数
    Z = [];
    R_noiseless = Tool.reshapeMatrixWithColumn(c,itern);
    rowNumber = min(size(R_noiseless, 1), defaultRowNumber + itern); % L表示当前行数
    decision = (rowNumber - itern) * gamma / 2; % 判决门限

%% 随机交换部分行和列，计算
%Iteration
    for iteri = 1 : iteration
        R = Tool.reshapeMatrixWithColumn(r,itern); % 当前截断矩阵
        R = R(1:rowNumber,:);
        permutation = randi(rowNumber, [1, itern]);
        % permutation = 1:itern;
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        % R = ParameterIdentification.EliminateUpperDiagnolNoise(R, R_noiseless(permutation, :));
        [G, B] = MatrixTransfer.LT_transfer(R,4); % 分解
        N_l = sum(G(itern + 1 : end, :), 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
        Q_l = find(N_l < decision);
        if any(Q_l)
            Z = [Z, B(:, Q_l)];
%             disp(['(index,dependent columns)=(',num2str(itern),',',num2str(numel(Q_l)),')']);
        end
    end
    if ~any(Z)
        continue;
    end
    r_temp = 1 - gfrank(Z,2) / itern;
    if codeRate > r_temp
        codeRate = r_temp;
        n = itern;
%        C = Z;
    end
end
% if n~=56
%     disp(['Error Identification of n !! /n Estimation of n is ', num2str(n)]); 
% end

end

