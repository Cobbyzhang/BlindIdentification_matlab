function [ G, B ] = LT_transfer( R )
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

%% 初始化
[L,l] = size(R);
G = R;
B = eye(l);

%% 循环
% for iter1 = 1:l-1
%     if ~any(G(iter1,:))
%         continue
%     end
%     pp = find(G(iter1,iter1:end));%注意找到的是相对位置
%     if any(pp) && pp(1)~= 1 
%         G(:,[iter1, iter1 + pp(1) - 1]) = G(:,[iter1 + pp(1) - 1, iter1]);
%         B(:,[iter1, iter1 + pp(1) - 1]) = B(:,[iter1 + pp(1) - 1, iter1]);
%     end
%     for iter2 = iter1+1:l
%         if G(iter1,iter2)==1
%             G(:,iter2) = xor(G(:,iter2),G(:,iter1));
%             B(:,iter2) = xor(B(:,iter2),B(:,iter1));
%         end
%     end
% end

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
