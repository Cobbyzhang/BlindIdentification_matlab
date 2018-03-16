clc
clear

%H = [ 1 1 1 1 1 0 0; 1 1 0 1 0 1 0;1 0 1 1 0 0 1 ];
G = [ 1 1 0 1 0 0 0; 0 1 1 0 1 0 0;1 1 1 0 0 1 0;1 0 1 0 0 0 1];
[k,n]=size(G);

testNumber = 1000;
ErrorSamplingNum = 12;
Error = zeros(1,ErrorSamplingNum + 1);
gammaOpt = 0.6;
rowNumber = 1000;



h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
testTimes = ( ErrorSamplingNum + 1) * testNumber;
for iterr = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itert = 1:testNumber
            if getappdata(h,'canceling')
                break
            end
            % 生成码字b1 & c1
            K= 50000;
            b1 = round(rand(1,K));
            b = Tool.reshapeMatrixWithRow(b1,k)';
            c1 = reshape(mod(b * G, 2)',1,[]);
            % c1 通过无（有）噪声信道 -> c
            c = Tool.addErrorWithPossibility(c1,errorRate);

            % 接受到截断信号 c -> r
            startnum = 1;
            endnum = randi([1,100],1);
            r = c(startnum:end-endnum);
            n_estimate = ParameterIdentification.identify_n_Gauss(r, gammaOpt, rowNumber);
            %n_estimate = ParameterIdentification.identify_Walsh(r, 0.3, rowNumber);
            if n_estimate ~= n
                Error(iterr + 1) = Error(iterr + 1) + 1;
            end
            curr_waitbar = (iterr*testNumber + itert)/testTimes;
            str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
            waitbar(curr_waitbar,h,str);
    end
end

delete(h);
clear h;

th = 0:0.01:0.01*ErrorSamplingNum;
plot(th,1-Error/testNumber);
axis([0 0.01*ErrorSamplingNum 0 1]);
