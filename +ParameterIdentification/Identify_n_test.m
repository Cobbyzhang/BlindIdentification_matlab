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
selected = 13;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
errorRate = 0.15 ;
testNumber = 18;
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

%% 识别n
mostPossibleSolution = zeros(1,testNumber);
average = zeros(1,testNumber);
MaxAverRate = zeros(1,testNumber);
T = zeros(1,testNumber);
for itern = 1:testNumber
    R = Tool.reshapeMatrixWithRow(r,itern)';
    % isequal(r(1:numel(R)),reshape(R,1,[]))
    w = zeros(1,2^itern);
    rowNumber = size(R,1);
    for iterr = 1:rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        w(1,wValue) = w(1,wValue) + 1;
    end
    Y = MyFWHT.myfwht(w);
    mostPossibleSolution(itern) = max(Y(2:end)) / rowNumber;
    average(itern) = sum(abs(Y))/numel(Y);
    MaxAverRate(itern) = rowNumber * mostPossibleSolution(itern)/average(itern);
    T(itern) = mostPossibleSolution(itern) * sqrt(rowNumber);
    %mostPossibleSolution = max(max(Y(2:end)));
    disp(['l = ',num2str(itern),': ',num2str(mostPossibleSolution(itern))])
    % disp(mostPossibleSolution)
    if itern == 9
        figure(2)
        stem(Y,'Marker','none');
        disp(find(Y==max(Y(2:end))))
    end
end


figure(3)
%stem(T)
%hold on
%stem(MaxAverRate,'-r')
stem(mostPossibleSolution,'-k*')










