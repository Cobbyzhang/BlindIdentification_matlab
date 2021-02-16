function [ G, B ] = LT_transfer( R, method )
%% 算法描述
%将截断矩阵R分解为 R = A*G*B
%   A 是行初等变换矩阵
%   B 是列初等变换矩阵
%   G 是一个下三角矩阵
%算法描述： 
%   初始化检查（这里没做检查，要求R必须为二元域上的矩阵）
%   获取R的size [L,l]
%   B初始化为eye(l)
%   for iter = 1:l
%     如果 R(iter,:)全为0，跳过
%     否则找到R(iter,iter:end)的第一个1非零元素位置pp(1)
%     交换 R([iter,pp(1)],:)=R([pp(1),iter],:)
%     计算B
%     for iter2 = iter1+1:l
%       把第iter列加到改该行非0 的列
%       计算B
%     end
%   end
% 

%     1. If the ith element of the ith column is a zero, we
%     permute this column with the first column i (i >
%     i) that has a one on its ith element.
%     2. If there is no column that has a one on its ith element, 
%     we permute the ith row with the first row i
%     (i > i) that has a one on its ith element.
%     3. We add (modulo 2) this column to any column on
%     its left that has a one on its ith row. This clears the
%     ith row.
%     4. If we get a column with zero, it is a dependent
%     column.
%     5. We repeat the procedure with the next column
%     (i.e. set i = i + 1 and go back to 1.)



%% 初始化
[L,l] = size(R);
G = R;
B = eye(l);
if nargin < 2
    method = 4;
end

% 循环
if method == 1
    for iter1 = 1:l-1
        pp = find(G(iter1,iter1:end));%注意找到的是相对位置
        if ~any(pp)
            continue
        end
        if pp(1)~= 1 
            G(:,[iter1, iter1 + pp(1) - 1]) = G(:,[iter1 + pp(1) - 1, iter1]);
            B(:,[iter1, iter1 + pp(1) - 1]) = B(:,[iter1 + pp(1) - 1, iter1]);
        end
        for iter2 = iter1+1:l
            if G(iter1,iter2)==1
                G(:,iter2) = xor(G(:,iter2),G(:,iter1));
                B(:,iter2) = xor(B(:,iter2),B(:,iter1));
            end
        end
    end
elseif method == 2
%% 改进版循环
    row = 1; %标记当前操作的行号
    for iter1 = 1:l-1
        pp = [];
        while ~any(pp) 
            pp = find(G(row,iter1:end));%注意找到的是相对位置
            row = row + 1;
            if row > L
                return
            end 
        end
        row = row - 1;
        if pp(1)~= 1 
            G(:,[iter1, iter1 + pp(1) - 1]) = G(:, [iter1 + pp(1) - 1, iter1]);
            B(:,[iter1, iter1 + pp(1) - 1]) = B(:, [iter1 + pp(1) - 1, iter1]);
        end
        for iter2 = iter1+1:l
            if G(row, iter2)==1
                G(:, iter2) = xor(G(:, iter2),G(:, iter1));
                B(:, iter2) = xor(B(:, iter2),B(:, iter1));
            end
        end
    end

%% 矩阵乘法式
elseif method ==3
    for iter1 = 1:l-1
        pp = find(G(iter1,iter1:end));%注意找到的是相对位置
        if ~any(pp)
            continue
        end
        if pp(1)~= 1 
            G(:,[iter1, iter1 + pp(1) - 1]) = G(:,[iter1 + pp(1) - 1, iter1]);
            B([iter1, iter1 + pp(1) - 1],:) = B([iter1 + pp(1) - 1, iter1],:);
        end

        temp = eye(l);
        temp(iter1, iter1:end) = G(iter1, iter1:end);
        G = mod(G * temp, 2);
        B = temp * B;

    end
    B = mod(inv(mod(B,2)),2);
else
    for iter1 = 1 : l - 1
        if ~G(iter1, iter1)
            pp = find(G(iter1, iter1 : end));%注意找到的是相对位置
            if any(pp)
                G(:, [iter1, iter1 + pp(1) - 1]) = G(:, [iter1 + pp(1) - 1, iter1]);
                B(:, [iter1, iter1 + pp(1) - 1]) = B(:, [iter1 + pp(1) - 1, iter1]);
            else
                qq = find(G(iter1 : end, iter1));
                if ~any(qq)
                    continue
                end
                G([iter1, iter1 + qq(1) - 1], :) = G([iter1 + qq(1) - 1, iter1], :);
            end
        end
        for iter2 = iter1 + 1 : l
            if G(iter1, iter2) == 1
                G(:, iter2) = xor(G(:, iter2), G(:, iter1));
                B(:, iter2) = xor(B(:, iter2), B(:, iter1));
            end
        end
    end
    
    
end
