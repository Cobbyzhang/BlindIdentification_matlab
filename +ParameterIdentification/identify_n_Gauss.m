function [ n, n_alpha ] = identify_n_Gauss( c, r, iteration, defaultRowNumber, gamma )
%IDENTIFY_N_GAUSS 


if nargin < 5
    gamma = 0.6;
end

if nargin < 4
    defaultRowNumber = 1000;
end

%% Optimal threshold
 gammaOpt = gamma;  % �����о�����


%% ���ɽضϾ��� r -> R
MaxN = 30; % ���Ե�n�����ֵ
maxN = min(floor(sqrt(size(r, 2))), MaxN); % ��������������û������



for iteri = 1 : iteration
    Z_l = zeros(1, maxN);
    H = cell(MaxN);
    for itern = 2:maxN  %l��ʾ��ǰ����
        R_noiseless = Tool.reshapeMatrixWithColumn(c,itern);
        rowNumber = min(size(R_noiseless, 1), defaultRowNumber + itern); % L��ʾ��ǰ����
        decision = (rowNumber - itern) * gammaOpt / 2; % �о�����

    %% ������������к��У�����
        R = Tool.reshapeMatrixWithRow(r,itern)'; % ��ǰ�ضϾ���
        R = R(1:rowNumber,:);
        permutation = randi(rowNumber, [1, itern]);
        % permutation = 1: itern;
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
%         R = ParameterIdentification.EliminateUpperDiagnolNoise(R,
%         R_noiseless(permutation, :)); % ȥ���������������в���������Ҫ
        [G, B] = MatrixTransfer.LT_transfer(R,4); % �ֽ�
        N_l = sum(G(itern + 1 : end, :), 1); % ÿһ�е�1�ĸ�������ĳһ��1�ĸ���С������ʱ����Ϊ��һ���������е��������
        N = find(N_l <= decision);
        if any(N)
            Z_l(itern) = Z_l(itern) + nnz(N);  % Number of nonzero matrix elements��Ҳ���ǣ�����Ϊlʱ���ж��ٸ�������ϵ���
            H{itern} = B(:, N);
        end
    end
    f = find(Z_l > 0); % �ҵ����е���������ص�l����˵��l��ʱΪn�ı���
    if numel(f)>=2
        break;
    end
end

%% �ҵ�n 
f = find(Z_l > 0); % �ҵ����е���������ص�l����˵��l��ʱΪn�ı���
if numel(f)<2
    n = 0;
    n_alpha = 0;
    return
end
n = mode(diff(f),2);
% n = f(2)-f(1); % ԭʼ�������ҵ�ǰ�������ж�

%% ʶ��n_alpha
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
% n_alpha = f(1);  % ���󷽷����õ�һ���ж�����Ӱ����ȷ��

end

