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
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
testNumber = 10;
rowNumber = 200;
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);
gammaOpt = 0.6;
%%
%% 识别率-误码率曲线
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 6;
Error = zeros(1,ErrorSamplingNum+1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
iteration = 50;
for iterr = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itern = 1:testNumber
        % 生成码字b1 & c1
        K= 6000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 通过无（有）噪声信道 -> c
        c = Tool.addErrorWithPossibility(c1,errorRate);

        % 接受到截断信号 c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);
        
        % 识别参数n,n_alpha
        [n_estimate, n_alpha_estimate] = ParameterIdentification.identify_n_Gauss(r, gammaOpt, iteration, rowNumber);
        if n_estimate ~= n || n_alpha_estimate ~= n_alpha
            Error(iterr + 1) = Error(iterr + 1) + 1;
            continue;            
        end
                
        %识别监督矩阵
        parityCheckMatrix = ParityCheckMatrixIdentification.identify_parity_check_matrix(r, n_estimate, k, u, rowNumber);

               
        if ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)
            Error(iterr + 1) = Error(iterr + 1) + 1;
        end
        curr_waitbar = ((iterr)*testNumber + itern)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end


delete(h);
clear h;

figure(1)
hold on
plot(0.01*(0:ErrorSamplingNum),1-Error/testNumber,'b');
axis([0 0.01*ErrorSamplingNum 0 1]);






