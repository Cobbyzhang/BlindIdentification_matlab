clc
clear
%% 编码器&交织器参数
G = [ 1 1 0 1 0 0 0; 0 1 1 0 1 0 0;1 1 1 0 0 1 0;1 0 1 0 0 0 1];
[k,n] = size(G);
multi = 8;
InterSize = multi * n;
% interleaver = reshape(reshape(1:InterSize,n,multi)',1,InterSize);
% interleaver = randperm(InterSize);
interleaver = [47,13,22,20,36,49,23,5,7,41,34,30,15,1,40,46,35,51,14,16,54,55,11,6,50,21,44,28,25,48,8,37,27,9,32,31,53,3,18,29,52,38,45,2,24,42,56,17,12,4,33,19,43,10,39,26];

%% 测试参数
ga = 0.6: 0.05 : 0.8;
er = 0.05 : 0.01 : 0.05;
gammaSamplingNum = size(ga, 2);
errorSamplingNum = size(er, 2);
repetition = 1000;
testTimes =  errorSamplingNum * gammaSamplingNum * repetition;
Error = zeros(1, testTimes);

%% 算法参数
rowNumber = 1000;
iteration = 1;

%% 并行计算参数设置
workerNum = 2;
PCT = parpool(workerNum);

%% 算法主体程序
clc
Tool.parfor_progress(testTimes);%并行运行
parfor iter = 1 : testTimes
    itere = ceil(iter / (repetition * gammaSamplingNum));
    errorRate = er(itere);
    iterg = ceil(iter / repetition) - (itere - 1) * gammaSamplingNum; 
    gamma = ga(iterg);
    % 生成码字b1 & c1
    K= 30000;
    b1 = round(rand(1,K));
    b = Tool.reshapeMatrixWithColumn(b1, k);
    c1 = Tool.reshapeMatrixWithRow(reshape(mod(b * G, 2)', 1, []), InterSize);
    c1 = reshape(c1(interleaver,:), 1, []);
    % c1 通过无（有）噪声信道 -> c
    % c(InterSize*InterSize+1:end) = Tool.addErrorWithPossibility(c1(InterSize*InterSize+1:end),errorRate);
    c = Tool.addErrorWithPossibility(c1,errorRate);
    % 接受到截断信号 c -> r
    startnum = 1;
    endnum = randi([1,100],1);
    r = c(startnum:end-endnum);
    n_estimate = ParameterIdentification.test.identify_dimension_of_interleaver(c1(startnum:end-endnum), r, iteration, rowNumber, gamma);
    if n_estimate ~= InterSize
        Error(iter) = 1;
    end
    Tool.parfor_progress;
end
Tool.parfor_progress(0);
delete(PCT);
clc;

%% 后续处理及绘图
ErrorMean = Tool.reshapeMatrixWithRow(sum(Tool.reshapeMatrixWithRow(Error, repetition)) / repetition, gammaSamplingNum);
plot(er,1 - min(ErrorMean));
axis([er(1) er(end) 0 1]);



% clc
% clear
% %%
% G = [ 1 1 0 1 0 0 0; 0 1 1 0 1 0 0;1 1 1 0 0 1 0;1 0 1 0 0 0 1];
% [k,n] = size(G);
% multi = 8;
% InterSize = multi * n;
% % interleaver = reshape(reshape(1:InterSize,n,multi)',1,InterSize);
% % interleaver = randperm(InterSize);
% interleaver = [47,13,22,20,36,49,23,5,7,41,34,30,15,1,40,46,35,51,14,16,54,55,11,6,50,21,44,28,25,48,8,37,27,9,32,31,53,3,18,29,52,38,45,2,24,42,56,17,12,4,33,19,43,10,39,26];
% 
% %%
% testNumber = 10;
% gammaSamplingNum = 10;
% initial = 0.2;
% interval = 0.05;
% Error = zeros(testNumber,gammaSamplingNum + 1);
% ErrorRate = 0.02;
% 
% %%
% rowNumber = 1000;
% iteration = 1;
% 
% %%
% % testTimes = ( gammaSamplingNum + 1) * testNumber;
% 
% Tool.parfor_progress(testNumber * (gammaSamplingNum + 1));%并行运行
% 
% parfor itert = 1 : testNumber
%     for iterg = 1 : gammaSamplingNum + 1  
%         gamma = initial + (iterg - 1) * interval;
%         errorRate = ErrorRate;
%         % 生成码字b1 & c1
%         K= 30000;
%         b1 = round(rand(1,K));
%         b = Tool.reshapeMatrixWithColumn(b1, k);
%         c1 = Tool.reshapeMatrixWithRow(reshape(mod(b * G, 2)', 1, []), InterSize);
%         c1 = reshape(c1(interleaver,:), 1, []);
%         % c1 通过无（有）噪声信道 -> c
%         % c(InterSize*InterSize+1:end) = Tool.addErrorWithPossibility(c1(InterSize*InterSize+1:end),errorRate);
%         c = Tool.addErrorWithPossibility(c1,errorRate);
%         % 接受到截断信号 c -> r
%         startnum = 1;
%         endnum = randi([1,100],1);
%         r = c(startnum:end-endnum);
%         n_estimate = ParameterIdentification.test.identify_dimension_of_interleaver(c1(startnum:end-endnum), r, iteration, rowNumber, gamma);
%         if n_estimate ~= InterSize
%             Error(itert, iterg) = 1;
%         end
%     end
%     Tool.parfor_progress;
% end
% Tool.parfor_progress(0);
% clc;
% 
% %%
% ErrorMean = sum(Error)/testNumber;
% th = initial: interval : initial + interval * gammaSamplingNum;
% plot(th,1-ErrorMean);
% axis([initial initial + interval * gammaSamplingNum 0 1]);