function [ c ] = fWeighting( a, b )
% ��Ȩ����
% a ������ı�������ÿһ�ж�Ӧһ������ʽ�������Ϊ���λ
% b ʮ��������������ʾ��Ȩֵ����������һ������ʽȨֵ��������ÿ��ֵ�Ķ�������ʽ�ĸ�λ��Ӧ�Ŷ���ʽ��ʽ�ĸ�λ
%   ���bΪһ��ֵ���a��ÿһ�о��������Ȩֵ����Ϊһ����������a�Ķ�Ӧ�г��Զ�Ӧ��Ȩֵ
% c ����������ȻΪһ����������
%% ���
if size(b,1)>1 ||(numel(b)>1 && size(b,2)~=size(a,1)) % ���b��ά����ҪôΪһά������������a��������ͬ��ҪôΪһ����
    disp('Wrong(dimention do not match)!')
    return
end
if any(rem(b,1)) ||any(b(b < 0)) % b ��Ԫ�ر���Ϊ��Ȼ��
    disp('Wrong!')
    return
end

%% ��Ȩ����
c = false(1,size(a,2));
if numel(b)==1
    c = fWeightingBasic(a,b);
else
    for iter = 1:numel(b)
        c = xor(c,fWeightingBasic(a(iter,:),b(iter)));
    end
end
end

