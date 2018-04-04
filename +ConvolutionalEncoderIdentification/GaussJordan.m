clear
clc


%% ��������뼯��
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;
HCard = GeneratorCard.HCard;
polyCard = GeneratorCard.polyCard;

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 17;
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

%% ���Բ���
ga = 0.2:0.05:0.7;
er = 0 : 0.01 : 0.05;
gammaSamplingNum = size(ga, 2);
errorSamplingNum = size(er, 2);
repetition = 100;
testTimes =  errorSamplingNum * gammaSamplingNum * repetition;
Error = zeros(1, testTimes);

%% �㷨����
rowNumber = 1000;
iteration = 10;

%% ���м����������
workerNum = 24;
% PCT = parpool(workerNum);


%% ʶ����-����������

clc
Tool.parfor_progress(testTimes);%��������
% parfor iter = 1 : testTimes
for iter = 1 : testTimes
    itere = ceil(iter / (repetition * gammaSamplingNum));
    errorRate = er(itere);
    iterg = ceil(iter / repetition) - (itere - 1) * gammaSamplingNum; 
    gamma = ga(iterg);
%      gamma = 2 * ParameterIdentification.optimal_gamma(errorRate, rowNumber);
    
    
    % ��������b1 & c1
    K= 20000;
    b1 = round(rand(1,K));
    c1 = convenc(b1,g);
    
    % c1 ͨ���ޣ��У������ŵ� -> c
    c = Tool.addErrorWithPossibility(c1,errorRate);
    
    % ���ܵ��ض��ź� c -> r
    startnum = 1;
    % endnum = randi(100,1);
    % r = c(startnum:end-endnum);
    endnum = 20000;
    r = c(startnum:endnum);
    
    %ʶ��
    for ii = 1:iteration
        k_estimate = 0;
        u_estimate = 0;
        parityCheckMatrix = [];
        [n_estimate, n_alpha_estimate] = ParameterIdentification.identify_n_Gauss(c1(startnum:endnum), r, 1, rowNumber, gamma);
        if n_estimate == 0 || n_estimate == 1 || n_alpha_estimate >= 30
            continue;
        end

        % ���� k,u
        [k_set, u_set] = ParameterIdentification.estimation_of_k_u(n_estimate,n_alpha_estimate);
        total = size(k_set, 2);

        %ʶ��ල����
        for iterr = 1:total
            parityCheckMatrix = ParityCheckMatrixIdentification.estimation_of_parity_check(r, n_estimate, k_set(iterr), u_set(iterr), rowNumber, gamma);
            if rank(parityCheckMatrix) == n_estimate - k_set(iterr) 
                k_estimate = k_set(iterr);
                u_estimate = u_set(iterr);
                break
            end
        end
%         if  ~any(any(parityCheckMatrix < 0)) && ~ParityCheckMatrixIdentification.isAnErrorPropagationMatrix((u_estimate + 1)* ones(1,n_estimate - k_estimate),parityCheckMatrix)
        if  ~any(any(parityCheckMatrix < 0))
            break;
        end
    end
%     if n_estimate~=n || n_alpha_estimate ~= n_alpha || k_estimate ~= k || u_estimate ~= u || any(any(parityCheckMatrix < 0)) || ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)|| ParityCheckMatrixIdentification.isAnErrorPropagationMatrix((u+1)*ones(1,n-k), parityCheckMatrix)
    if n_estimate~=n || n_alpha_estimate ~= n_alpha || k_estimate ~= k || any(any(parityCheckMatrix < 0)) || ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)
        Error(iter) = 1;
    end
    Tool.parfor_progress;
end
Tool.parfor_progress(0);
% delete(PCT);


%% ����������ͼ
ErrorMean = Tool.reshapeMatrixWithRow(sum(Tool.reshapeMatrixWithRow(Error, repetition)) / repetition, gammaSamplingNum);
%plot(er,1 - min(ErrorMean));
plot(er,1 - ErrorMean);
axis([er(1) er(end) 0 1]);





