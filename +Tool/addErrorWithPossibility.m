function [ code ] = addErrorWithPossibility( code, p )
%����һ���Ĵ����ʸ�������Ӵ���
% ����code������
% ����p�Ǵ������
% Ĭ��code��0,1����

if p>1 || p<0
    error('Error possibility out of range.');
end
if p == 0
    return;
else
    len = numel(code);
    out = randperm(len);
    e = out(1:round( p * len )); % ���մ����ʵõ�����λ���
    code(e) = ~code(e); % ��Ӵ���


end

