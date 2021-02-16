function [ rank_Rl1, rank_Rl2 ] = identify_rank_k( r, threshold, rowNumber )
%IDENTIFY_N  ����Walsh�任�Ĳ���ʶ�𷽷�����������������rank��ֵ����֤�����
%   ���ݽ������У��о����޺���������������Walsh�任ʶ���������
%   ���룺  ��������r
%           �о�����threshold
%           ����ʹ�õ�����rowNumber
%   �����  ��������(n, k, n_alpha)


%%  default input parameter 
if nargin < 3
    rowNumber = 1000;
end


%%  basic parameters
testNumber = 18;
mostPossibleSolution = zeros(1,testNumber);
Dimension = zeros(1,testNumber);
detectionRate = 2/3;
index_flag = 0;
hight_flag = 0;
%failTime = 0;


%%  loop
for iterk = 6:testNumber
    R = Tool.reshapeMatrixWithRow(r,iterk)';
    w = zeros(1,2^iterk);
    rowNumber = min(size(R,1),rowNumber);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        w(1,wValue) = w(1,wValue) + 1;
    end
    Y = MyFWHT.myfwht(w);
    mostPossibleSolution(iterk) = max(Y(2:end)) / rowNumber; % �ҵ�ÿ���׵���߷�
    Dimension(iterk) = numel(find(Y > rowNumber * threshold));
    if mostPossibleSolution(iterk) > max(threshold, detectionRate * hight_flag)
        if index_flag == 0 || iterk == index_flag + 1 || mostPossibleSolution(iterk) > hight_flag / detectionRate
            %failTime = failTime +1;
            index_flag = iterk;
            hight_flag = mostPossibleSolution(iterk);            
        else
            n = iterk - index_flag;
            n_alpha = index_flag;
            if rem(n_alpha,n) ~= 0
                continue
            end
            rank_Rl2 = iterk - log2(Dimension(iterk));
            rank_Rl1 = index_flag - log2(Dimension(index_flag));
            % rank_Rl2 = itern - round(log2(Dimension(itern)));
            % rank_Rl1 = index_flag - round(log2(Dimension(index_flag)));
            return
        end
    end
end
rank_Rl2 = 0;
rank_Rl1 = 0;

end
