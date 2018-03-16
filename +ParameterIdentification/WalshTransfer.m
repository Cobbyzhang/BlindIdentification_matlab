function [Y] = WalshTransfer(r, l, rowNumber)

R = Tool.reshapeMatrixWithRow(r,l)';
w = zeros(1,2^l);
rowNumber = min(size(R,1),rowNumber);
for iterr = 1:rowNumber
    wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
    w(1,wValue) = w(1,wValue) + 1;
end
Y = MyFWHT.myfwht(w);


end

