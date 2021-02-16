function [ n ] = identify_dimension_of_interleaver( c, r, iteration, defaultRowNumber, gamma )
%IDENTIFY_N_GAUSS 


if nargin < 5
    gamma = 0.6; % gammaOpt = 0.6;  �����о�����
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

%% ���ɽضϾ��� r -> R
Smax = min(floor(sqrt(size(r, 2))), Smax); % ��������������û������
for itern = Smin : Smax  % itern��ʾ��ǰ����
    Z = [];
    R_noiseless = Tool.reshapeMatrixWithColumn(c,itern);
    rowNumber = min(size(R_noiseless, 1), defaultRowNumber + itern); % L��ʾ��ǰ����
    decision = (rowNumber - itern) * gamma / 2; % �о�����

%% ������������к��У�����
%Iteration
    for iteri = 1 : iteration
        R = Tool.reshapeMatrixWithColumn(r,itern); % ��ǰ�ضϾ���
        R = R(1:rowNumber,:);
        permutation = randi(rowNumber, [1, itern]);
        % permutation = 1:itern;
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        % R = ParameterIdentification.EliminateUpperDiagnolNoise(R, R_noiseless(permutation, :));
        [G, B] = MatrixTransfer.LT_transfer(R,4); % �ֽ�
        N_l = sum(G(itern + 1 : end, :), 1); % ÿһ�е�1�ĸ�������ĳһ��1�ĸ���С������ʱ����Ϊ��һ���������е��������
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

