function [ n, n_alpha ] = identify_n( r, threshold )
%IDENTIFY_N 

testNumber = 18;
mostPossibleSolution = zeros(1,testNumber);
% average = zeros(1,testNumber);
% MaxAverRate = zeros(1,testNumber);
T = zeros(1,testNumber);
Z_l =  zeros(1,testNumber);
for itern = 6:testNumber
    R = Tool.reshapeMatrixWithRow(r,itern)';
    w = zeros(1,2^itern);
    rowNumber = size(R,1);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        w(1,wValue) = w(1,wValue) + 1;
    end
    Y = MyFWHT.myfwht(w);
    mostPossibleSolution(itern) = max(Y(2:end)) / rowNumber;
%     average(itern) = sum(abs(Y))/numel(Y);
%     MaxAverRate(itern) = rowNumber * mostPossibleSolution(itern)/average(itern);
    T(itern) = mostPossibleSolution(itern) * sqrt(rowNumber);
    if T(itern)>threshold
        Z_l(itern) = 1;
    end
end
f = find(Z_l);
if numel(f)<2
    n = 0;
    n_alpha = 0;
    disp('Identify insuccessfully')
    return
end
n = f(2)-f(1);
n_alpha = f(1);
end

