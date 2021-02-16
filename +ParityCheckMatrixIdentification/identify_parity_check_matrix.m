function [ parityCheckMatrix ] = identify_parity_check_matrix(r, n, k, u, rowNumber)
%PARITY_CHECK_MATRIX 监督矩阵识别
%   根据接收序列和识别的参数，完成监督矩阵识别
%   输入：  接收序列r
%           卷积码编码参数(n,k,u)
%   输出：  n-k个监督关系（二进制向量输出）


%% Defualt parameter
if nargin < 5
    rowNumber = 1000;
end

%% 
R = Tool.reshapeMatrixWithRow(r, n * (u + 1))';
if rowNumber < size(R, 1)
    R(rowNumber + 1 : end, : ) = [];
end

if rowNumber > size(R, 1)
     rowNumber = size(R, 1);
end
l = (k + 1) * (u + 1);
parityMatrix = zeros(n-k, k+1);

%% 处理截断矩阵，并利用Walsh变换寻找峰值
w = zeros(n-k,2^l);
for iters = 1:n-k
    R_temp = ParityCheckMatrixIdentification.extractParityRelation(R,n,k,iters);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R_temp(iterr, :)) + 1;
        w(iters, wValue) = w(iters, wValue) + 1;
    end
    Y = MyFWHT.myfwht(w(iters, :));
    [~, pos] = max(Y(2:end));
    parityMatrix(iters,:) = TypeConversion.num2poly(pos, l, u + 1);
end

%% 
parityCheckMatrix = ParityCheckMatrixIdentification.resumeParityCheckMatrix(parityMatrix, n);


end

