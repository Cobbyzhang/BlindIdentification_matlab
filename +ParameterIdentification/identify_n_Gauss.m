function [ n, n_alpha ] = identify_n_Gauss( r, gammaOpt, iteration, rowNumber )
%IDENTIFY_N_GAUSS 


if nargin < 4
    rowNumber = 1000;
end
%% ���ɽضϾ��� r -> R
% MaxN = 60; % ���Ե�n�����ֵ
maxN = min(floor(sqrt(size(r,2))),25); % ��������������û������
% gammaOpt = 0.6;  �����о�����
Z_l = zeros(1, maxN); % 
for itern = 2:maxN  %l��ʾ��ǰ����
%iter = 5;
    
    R = Tool.reshapeMatrixWithRow(r,itern)'; % ��ǰ�ضϾ���
    rowNumber = min(size(R,1), rowNumber); % L��ʾ��ǰ����
    decision = (rowNumber - itern) * gammaOpt / 2; % �о�����
    R = R(1:rowNumber,:);

%% ������������к��У�����
%Iteration

    for iteri = 1:iteration
        permutation = randi(rowNumber, [1, itern]);
        R_temp = R(1:itern, :);
        R(1:itern, :) = R(permutation, :);
        R(permutation, :) = R_temp;
        
        
        [G, ~] = MatrixTransfer.LT_transfer(R,4); % �ֽ�
%         [G0, B0] = MatrixTransfer.LT_transfer(R); % �ֽ�
%        G = mod(R*B,2);
%         if ~isequal(G0,G(1:l,:))%||~isequal(B0,B)
%             disp(G0)
%             disp(G(1:l,:))
%         end


        N_l = sum(G(itern + 1 : end, :), 1); % ÿһ�е�1�ĸ�������ĳһ��1�ĸ���С������ʱ����Ϊ��һ���������е��������
        
%         if nnz(N_l < decision)
%             disp(B(:,N_l < decision).')
%             pause
%         end
        
        Z_l(itern) = Z_l(itern) + nnz(find(N_l < decision));  % Number of nonzero matrix elements��Ҳ���ǣ�����Ϊlʱ���ж��ٸ�������ϵ���
    end

end

%% �ҵ�n 
f = find(Z_l > 0); % �ҵ����е���������ص�l����˵��l��ʱΪn�ı���
if numel(f)<2
    n = 0;
    n_alpha = 0;
    disp('Identify insuccessfully')
    return
end
n = f(2)-f(1); % ��ֵ���ǹ��Ƶ�n
n_alpha = f(1);

if n~= 3 || n_alpha ~= 12
     disp(n)
     disp(n_alpha)
end

end

