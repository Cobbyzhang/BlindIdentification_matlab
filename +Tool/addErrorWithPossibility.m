function [ code ] = addErrorWithPossibility( code, p )
%按照一定的错误率给序列添加错误
% 参数code是序列
% 参数p是错误概率
% 默认code是0,1矩阵

if p>1 || p<0
    error('Error possibility out of range.');
end
if p == 0
    return;
else
    len = numel(code);
    out = randperm(len);
    e = out(1:round( p * len )); % 按照错误率得到错误位标号
    code(e) = ~code(e); % 添加错误


end

