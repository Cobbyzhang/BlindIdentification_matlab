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

%% 统一定义 
selected = 1;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);

%% 测试参数
er = 0 : 0.01 : 0.12;
errorSamplingNum = size(er, 2);
repetition = 1000;
testTimes =  errorSamplingNum * repetition;
Error = zeros(1, testTimes);
Errorn = zeros(1,testTimes);
Errork = zeros(1,testTimes);
Erroru = zeros(1,testTimes);

%% 算法参数
rowNumber = 1000;

%% 并行计算参数设置
workerNum = 24;
% PCT = parpool(workerNum);

%%

clc
Tool.parfor_progress(testTimes);%并行运行
parfor iterr = 1:testTimes
    itere = ceil(iterr / repetition);
    errorRate = er(itere);
    % 生成码字b1 & c1
    K= 20000;
    b1 = round(rand(1,K));
    c1 = convenc(b1,g);

    % c1 通过无（有）噪声信道 -> c
    c = Tool.addErrorWithPossibility(c1,errorRate);

    % 接受到截断信号 c -> r
    startnum = 1;
    % endnum = randi(100,1);
    % r = c(startnum:end-endnum);
    endnum = 20000;
    r = c(startnum:endnum);

    %识别
    [n_estimate, k_estimate, u_estimate] = ParameterIdentification.identify_Walsh(r);

    if n_estimate ~= n
        Errorn(iterr) = 1;
    end
    if u_estimate ~= u
        Erroru(iterr) = 1;
    end
    if k_estimate ~= k
        Errork(iterr) = 1;
    end
    if n_estimate ~= n || u_estimate ~= u || k_estimate ~= k
        Error(iterr) = 1;
    end
    Tool.parfor_progress;
end

Tool.parfor_progress(0);
% delete(PCT);



%% 后续处理及绘图

ErrornMean = sum(Tool.reshapeMatrixWithRow(Errorn, repetition)) / repetition;
ErrorkMean = sum(Tool.reshapeMatrixWithRow(Errork, repetition)) / repetition;
ErroruMean = sum(Tool.reshapeMatrixWithRow(Erroru, repetition)) / repetition;
ErrorMean = sum(Tool.reshapeMatrixWithRow(Error, repetition)) / repetition;

figure(1)
hold on
plot(er,1-ErrornMean,'k');
plot(er,1-ErrorkMean,'-or');
plot(er,1-ErroruMean,'-*g');
plot(er,1-ErrorMean,'b');
axis([er(1) er(end) 0 1]);







