function [ dec ] = binVec2dec( binVec, high_order )
%BINVEC2DEC ��һ������������ת��Ϊʮ������
%   binVecΪһ��������������Ĭ�����Ϊ��λ���ұ�Ϊ��λ
%   high_order Ϊ��λ����λ��
%   dec�Ƿ��ص�ʮ������
%   ������Ƿ���ΪbinVec����

if nargin < 2
    high_order = 'left';
end

binVec = reshape(binVec,1,[]);
if strcmp(high_order,'left')
    dec = binVec * 2.^(0:numel(binVec)-1)';
elseif strcmp(high_order,'right')
    dec = binVec * 2.^(numel(binVec)-1:-1:0)';
else
    error('Parameter Error!');

end
