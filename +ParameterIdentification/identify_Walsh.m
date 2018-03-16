function [ n, k, u ] = identify_Walsh( r, threshold, rowNumber )
%IDENTIFY_N  基于Walsh变换的参数识别方法
%   根据接收序列，判决门限和数据行数，利用Walsh变换识别卷积码参数
%   输入：  接收序列r
%           判决门限threshold
%           数据使用的行数rowNumber
%   输出：  卷积码参数(n, k, n_alpha)


%%  default input parameter 
if nargin < 3
    rowNumber = 1000;
end
testNumber = 18;
if nargin < 2
    load +ParameterIdentification/thresholdParameter0001.mat thresholdParameter0001
    threshold = thresholdParameter0001 / sqrt(rowNumber);
else
    threshold = threshold*ones(1,testNumber);
end


%%  basic parameters
mostPossibleSolution = zeros(1,testNumber);
Dimension = zeros(1,testNumber);
detectionRate = 2/3;
index_flag = 0;
hight_flag = 0;
%failTime = 0;


%%  loop
for itern = 6:testNumber
    R = Tool.reshapeMatrixWithRow(r,itern)';
    w = zeros(1,2^itern);
    rowNumber = min(size(R,1),rowNumber);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        w(1,wValue) = w(1,wValue) + 1;
    end
    Y = MyFWHT.myfwht(w);
    mostPossibleSolution(itern) = max(Y(2:end)) / rowNumber; % 找到每个谱的最高峰
    Dimension(itern) = numel(find(Y > rowNumber * threshold(itern)));
    if mostPossibleSolution(itern) > max(threshold(itern), detectionRate * hight_flag)
        if index_flag == 0 || itern == index_flag + 1 || mostPossibleSolution(itern) > hight_flag / detectionRate
            %failTime = failTime +1;
            index_flag = itern;
            hight_flag = mostPossibleSolution(itern);            
        else
            n = itern - index_flag;
            n_alpha = index_flag;
            if rem(n_alpha,n) ~= 0
                continue
            end
            % rank_Rl2 = itern - round(log2(Dimension(itern)));
            % rank_Rl1 = index_flag - round(log2(Dimension(index_flag)));
            % k = rank_Rl2 - rank_Rl1;
            % u = rank_Rl1 - n_alpha * k / n;
            rank_Rl2 = itern - log2(Dimension(itern));
            rank_Rl1 = index_flag - log2(Dimension(index_flag));
            k = round(rank_Rl2 - rank_Rl1);
            u = round(rank_Rl1) - n_alpha * k / n;
            return
        end
    end
end
n = -1;
u = -1;
k = -1;


end
