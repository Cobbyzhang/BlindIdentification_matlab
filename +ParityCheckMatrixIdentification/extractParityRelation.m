function [RR] = extractParityRelation(R, n, k, s)
%���ضϾ���ת��Ϊ��Walsh�任�ľ�����ʽ
%  
%% basic Parameter
t = size(R, 2) / n; % ʶ���u+1��ֵ��Ҳ����ÿ���ල����ʽ��λ��
if n <= k || s > n-k || rem(t,1) % �������
    error('Parameter error!')
end

%% extract Parity relation with Period

% R = Tool.reverseColumnOrder(R, n);
RR = zeros(size(R));
for iter = 1 : n
RR( : , (iter - 1) * t + 1 : iter * t ) = R( : , iter : n : end );
end

%% delete redundant column

Rs = RR(:, (k + s - 1) * t + 1 : (k + s) * t);
RR(:, k * t + 1 : end) = [];
RR = [RR, Rs];

%%
for iter = 1: (k + 1)/2
    RR(:, [(iter - 1) * t + 1 : iter * t,(k + 1 - iter) * t + 1 : (k + 1 - iter + 1) * t]) = RR(:, [(k + 1 - iter) * t + 1 : (k + 1 - iter + 1) * t,(iter - 1) * t + 1 : iter * t]); 
end


end

