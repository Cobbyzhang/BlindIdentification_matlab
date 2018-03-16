function [ G, B ] = LT_transfer( R, method )
%% �㷨����
%���ضϾ���R�ֽ�Ϊ R = A*G*B
%   A ���г��ȱ任����
%   B ���г��ȱ任����
%   G ��һ�������Ǿ���
%�㷨������ 
%   ��ʼ����飨����û����飬Ҫ��R����Ϊ��Ԫ���ϵľ���
%   ��ȡR��size [L,l]
%   B��ʼ��Ϊeye(l)
%   for iter = 1:l
%     ��� R(iter,:)ȫΪ0������
%     �����ҵ�R(iter,iter:end)�ĵ�һ��1����Ԫ��λ��pp(1)
%     ���� R([iter,pp(1)],:)=R([pp(1),iter],:)
%     ����B
%     for iter2 = iter1+1:l
%       �ѵ�iter�мӵ��ĸ��з�0 ����
%       ����B
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



%% ��ʼ��
[L,l] = size(R);
G = R;
B = eye(l);
if nargin < 2
    method = 4;
end

% ѭ��
if method == 1
    for iter1 = 1:l-1
        pp = find(G(iter1,iter1:end));%ע���ҵ��������λ��
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
%% �Ľ���ѭ��
    row = 1; %��ǵ�ǰ�������к�
    for iter1 = 1:l-1
        pp = [];
        while ~any(pp) 
            pp = find(G(row,iter1:end));%ע���ҵ��������λ��
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

%% ����˷�ʽ
elseif method ==3
    for iter1 = 1:l-1
        pp = find(G(iter1,iter1:end));%ע���ҵ��������λ��
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
            pp = find(G(iter1, iter1 : end));%ע���ҵ��������λ��
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
