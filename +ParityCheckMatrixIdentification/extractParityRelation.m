function [RR] = extractParityRelation(R, n, k, s)
%将截断矩阵转换为待Walsh变换的矩阵形式
%  
%% basic Parameter
t = size(R, 2) / n; % 识别出u+1的值，也就是每个监督多项式的位数
if n <= k || s > n-k || rem(t,1) % 参数检测
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

