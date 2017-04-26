function [ G, B ] = LT_transfer( R )
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

%% ��ʼ��
[L,l] = size(R);
G = R;
B = eye(l);

%% ѭ��
% for iter1 = 1:l-1
%     if ~any(G(iter1,:))
%         continue
%     end
%     pp = find(G(iter1,iter1:end));%ע���ҵ��������λ��
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
