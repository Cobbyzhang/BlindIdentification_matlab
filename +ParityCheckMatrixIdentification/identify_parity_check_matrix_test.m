clear
clc


%% 载入测试码集合
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;


%% 统一定义 (就不要修改后面的代码了)
selected = 17;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
errorRate = 0.01;
testNumber = 24;
rowNumber = 1000;
u = sum(v)-numel(v);
%% 生成码字b1 & c1
K= 30000;
b1 = round(rand(1,K));
c1 = convenc(b1,g);


%% c1 通过无（有）噪声信道 -> c
%c = awgn(c1,3);
c = Tool.addErrorWithPossibility(c1,errorRate);


%% 接受到截断信号 c -> r
%startnum = randi([100,200],1);
startnum = 1;
endnum = randi([K-100,K],1);
r = c(startnum:endnum);
%r = rand(1,size(c,2));

%% 
R = Tool.reshapeMatrixWithRow(r, n * (u + 1))';
if rowNumber < size(R, 1)
    R(rowNumber + 1 : end, : ) = [];
end
l = (k + 1) * (u + 1);
parityMatrix = zeros(n-k, k+1);

%% 处理截断矩阵，并利用Walsh变换寻找峰值
w = zeros(n-k,2^l);
for iters = 1:n-k
    R_temp = ParityCheckMatrixIdentification.extractParityRelation(R,n,k,iters);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R_temp(iterr, :)) + 1;
        w(iters, wValue) = w(iters, wValue) + 1;
    end
    Y = MyFWHT.myfwht(w(iters, :));
    figure(iters)
    stem(Y,'Marker','none');
    [~, pos] = max(Y(2:end));
    parityMatrix(iters,:) = TypeConversion.num2poly(pos, l, u + 1);
end

%% 
parityCheckMatrix = ParityCheckMatrixIdentification.resumeParityCheckMatrix(parityMatrix, n);


disp(parityCheckMatrix)








