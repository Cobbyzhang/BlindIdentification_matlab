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
selected = 13;
v  = vCard{selected};
g  = GCard{selected};
poly = polyCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
H  = HCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
testNumber = 1000;
rowNumber = 1000;
u = sum(v)-numel(v);

%%
%% 识别率-误码率曲线
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 18;
Error = zeros(1,ErrorSamplingNum+1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
exitFlag = 0;
for iterr = 15:ErrorSamplingNum
    if exitFlag == 1
        break;
    end
    errorRate = iterr * 0.01;
    for itern = 1:testNumber
        if getappdata(h,'canceling')
            exitFlag = 1;
            break
        end
        % 生成码字b1 & c1
        K= 30000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 通过无（有）噪声信道 -> c
        c = Tool.addErrorWithPossibility(c1,errorRate);

        % 接受到截断信号 c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);
        
        % 识别参数
        [n_estimate, k_estimate, u_estimate] = ParameterIdentification.identify_Walsh(r);
        if n_estimate ~= n || u_estimate ~= u || k_estimate ~= k
            Error(iterr + 1) = Error(iterr + 1) + 1;
        else        
            %识别监督矩阵
            parityCheckMatrix = ParityCheckMatrixIdentification.identify_parity_check_matrix(r, n_estimate, k_estimate, u_estimate, rowNumber);

            if ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)
                Error(iterr + 1) = Error(iterr + 1) + 1;
            end
        end
        curr_waitbar = ((iterr)*testNumber + itern)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end


delete(h);
clear h;

detRate = 1-Error/testNumber;

figure(1)
hold on
plot(0.01*(0:ErrorSamplingNum),detRate,'b');
axis([0 0.01*ErrorSamplingNum 0 1]);
hold off

save(['+data/+Research2/+整体识别率/',num2str(k),'_',num2str(n),'_',num2str(u),'码_',num2str(testNumber),'.mat'], 'detRate')

t = 0.01*(0:(size(detRate,2)-1));
plot(t,detRate,'-*k');


