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

%% ͳһ���� 
selected = 1;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
sNum = 10 * k; % ͬ��ͷ����
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);

%% ���Բ���
er = 0 : 0.01 : 0.12;
errorSamplingNum = size(er, 2);
repetition = 1000;
testTimes =  errorSamplingNum * repetition;
Error = zeros(1, testTimes);
Errorn = zeros(1,testTimes);
Errork = zeros(1,testTimes);
Erroru = zeros(1,testTimes);

%% �㷨����
rowNumber = 1000;

%% ���м����������
workerNum = 24;
% PCT = parpool(workerNum);

%%

clc
Tool.parfor_progress(testTimes);%��������
parfor iterr = 1:testTimes
    itere = ceil(iterr / repetition);
    errorRate = er(itere);
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



%% ����������ͼ

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







