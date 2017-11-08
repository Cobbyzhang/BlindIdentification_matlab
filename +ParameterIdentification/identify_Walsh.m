function [ n, k, n_alpha ] = identify_Walsh( r, threshold )
%IDENTIFY_N 

testNumber = 20;
mostPossibleSolution = zeros(1,testNumber);
Dimension = zeros(1,testNumber);
detectionRate = 2/3;
index_flag = 0;
hight_flag = 0;
failTime = 0;

for itern = 6:testNumber
    R = Tool.reshapeMatrixWithRow(r,itern)';
    w = zeros(1,2^itern);
    rowNumber = size(R,1);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        w(1,wValue) = w(1,wValue) + 1;
    end
    Y = MyFWHT.myfwht(w);
    mostPossibleSolution(itern) = max(Y(2:end)) / rowNumber; % 找到每个谱的最高峰
    Dimension(itern) = numel(find(Y>rowNumber*threshold));
    if mostPossibleSolution(itern) > max(threshold,detectionRate*hight_flag)
        if itern==index_flag+1
            failTime = failTime +1;
            index_flag = itern;
            hight_flag = mostPossibleSolution(itern);
        elseif index_flag==0
            index_flag = itern;
            hight_flag = mostPossibleSolution(itern);
        else
            n = itern - index_flag;
            n_alpha = index_flag;
            k = (itern - round(log2(Dimension(itern)))) - (index_flag - round(log2(Dimension(index_flag))));
            return
        end
    end
end
n = -1;
n_alpha = -1;
k = -1;


end
