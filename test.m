clc
clear
%% 载入测试码集合
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;

%% 统一定义 (就不要修改后面的代码了)
selected = 4;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
t_inv  = symmat2num(mod(inv(num2symmat(t)),2));
tblen = max(max(v)); %最大记忆深度
testNum = 4;
error = ones(1,testNum);
sNum = 30;
% iter = randi(2^(k*testNum),1);
matrix = [0 0 0 0 1 1 0 1 1 0;1 1 0 0 1 0 0 1 0 1;1 1 0 0 0 1 0 0 1 1];
matrix = num2str(matrix);
matrix(matrix==' ')=[];
matrix = bin2dec(matrix)+1;
iter = matrix;
K= 40 * k - sNum;
b1 = round(rand(1,K));
firstblc = dec2bin(iter - 1,sNum) - 48;
b = [firstblc, b1];
c1 = convenc(b, g);
c = c1;
startnum = 1;
endnum = randi([K-10,K],1);
r = c(startnum:endnum);
bt = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %威特比译码
x = reshape(b(1:sNum-rem(sNum,k)),k,[]);% 重排一下得到顺序
xt = reshape(bt(1:numel(x)),size(x));
%x2 = T_transfer(x,t_inv);
disp('x =')
disp(x)
disp('xt = ')
disp(xt)
% disp('x2 = ')
% disp(x2)
T = Identify_T(x,xt,v); % 识别算法
if ~isequal(T,t)
    disp('Isn''t T ')
else
    disp('Succeed in Identification! ')
end
