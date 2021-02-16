clc
clear
%%
G = [ 1 1 0 1 0 0 0; 0 1 1 0 1 0 0;1 1 1 0 0 1 0;1 0 1 0 0 0 1];
%H = [ 1 1 1 1 1 0 0; 1 1 0 1 0 1 0;1 0 1 1 0 0 1 ];
[k,n] = size(G);
multi = 8;
InterSize = multi * n;
% interleaver = reshape(reshape(1:InterSize,n,multi)',1,InterSize);
% interleaver = randperm(InterSize);
interleaver = [47,13,22,20,36,49,23,5,7,41,34,30,15,1,40,46,35,51,14,16,54,55,11,6,50,21,44,28,25,48,8,37,27,9,32,31,53,3,18,29,52,38,45,2,24,42,56,17,12,4,33,19,43,10,39,26];
testNumber = 10;
ErrorSamplingNum = 10;
Error = zeros(1,ErrorSamplingNum + 1);
gammaOpt = 0.5;
rowNumber = 1000;
iteration = 1;
exitFlag = 0;

%%
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
testTimes = ( ErrorSamplingNum + 1) * testNumber;
for iterr = 0 : ErrorSamplingNum
    if exitFlag == 1
        break
    end
    errorRate = iterr * 0.01;
    for itert = 1:testNumber
            if getappdata(h,'canceling')
                exitFlag = 1;
                break
            end
            % 生成码字b1 & c1
            K= 30000;
            b1 = round(rand(1,K));
            b = Tool.reshapeMatrixWithColumn(b1, k);
            c1 = Tool.reshapeMatrixWithRow(reshape(mod(b * G, 2)', 1, []), InterSize);
            c1 = reshape(c1(interleaver,:), 1, []);
            % c1 通过无（有）噪声信道 -> c
            % c = c1;
            % c(InterSize*InterSize+1:end) = Tool.addErrorWithPossibility(c1(InterSize*InterSize+1:end),errorRate);
            c = Tool.addErrorWithPossibility(c1,errorRate);

            % 接受到截断信号 c -> r
            startnum = 1;
            endnum = randi([1,100],1);
            r = c(startnum:end-endnum);
            n_estimate = ParameterIdentification.test.identify_dimension_of_interleaver(c1(startnum:end-endnum), r, iteration, rowNumber);
            %n_estimate = ParameterIdentification.identify_Walsh(r, 0.4, rowNumber);
            if n_estimate ~= InterSize
                Error(iterr + 1) = Error(iterr + 1) + 1;
            end
            curr_waitbar = (iterr*testNumber + itert)/testTimes;
            str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
            waitbar(curr_waitbar,h,str);
    end
end

delete(h);
clear h;

%%
th = 0:0.01:0.01*ErrorSamplingNum;
plot(th,1-Error/testNumber);
axis([0 0.01*ErrorSamplingNum 0 1]);
