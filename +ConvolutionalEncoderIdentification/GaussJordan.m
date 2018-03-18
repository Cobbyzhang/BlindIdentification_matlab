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
HCard = GeneratorCard.HCard;
polyCard = GeneratorCard.polyCard;

%% 统一定义 (就不要修改后面的代码了)
selected = 1;
v  = vCard{selected};
g  = GCard{selected};
poly = polyCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
H  = HCard{selected};
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);

%% 测试参数
ga = 0.2;
er = 0.02 : 0.01 : 0.04;
gammaSamplingNum = size(ga, 2);
errorSamplingNum = size(er, 2);
repetition = 100;
testTimes =  errorSamplingNum * gammaSamplingNum * repetition;
Error = zeros(1, testTimes);

%% 算法参数
rowNumber = 200;
iteration = 10;

%% 并行计算参数设置
workerNum = 24;
% PCT = parpool(workerNum);


%% 识别率-误码率曲线

clc
Tool.parfor_progress(testTimes);%并行运行
% for iter = 1 : testTimes
for iter = 1 : testTimes
    itere = ceil(iter / (repetition * gammaSamplingNum));
    errorRate = er(itere);
%     iterg = ceil(iter / repetition) - (itere - 1) * gammaSamplingNum; 
%     gamma = ga(iterg);
     gamma = 2 * ParameterIdentification.optimal_gamma(errorRate, rowNumber);
    
    
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
    [n_estimate, n_alpha_estimate] = ParameterIdentification.identify_n_Gauss(c1(startnum:endnum), r, iteration, rowNumber, gamma);
    if n_estimate ~= n || n_alpha_estimate ~= n_alpha
        Error(iter) = 1;
%         Tool.parfor_progress;
        continue;
    end
    
    % 计算 k,u
    [k_set, u_set] = ParameterIdentification.estimation_of_k_u(n_estimate,n_alpha_estimate);
    total = size(k_set, 2);

    %识别监督矩阵
    for iterr = 1:total
        parityCheckMatrix = ParityCheckMatrixIdentification.estimation_of_parity_check(r, n_estimate, k_set(iterr), u_set(iterr), rowNumber, gamma);
        if rank(parityCheckMatrix) == n_estimate - k_set(iterr)
            k_estimate = k_set(iterr);
            u_estimate = u_set(iterr);
            break
        end
    end
    if k_estimate ~= k || u_estimate ~= u || any(any(parityCheckMatrix < 0)) || ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)
        Error(iter) = 1;
    end

%     Tool.parfor_progress;
end
% Tool.parfor_progress(0);
% delete(PCT);


%% 后续处理及绘图
ErrorMean = Tool.reshapeMatrixWithRow(sum(Tool.reshapeMatrixWithRow(Error, repetition)) / repetition, gammaSamplingNum);
%plot(er,1 - min(ErrorMean));
plot(er,1 - ErrorMean);
axis([er(1) er(end) 0 1]);





