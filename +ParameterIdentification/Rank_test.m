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
selected = 15;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
testNumber = 10000;
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);

%% 识别率-误码率曲线
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 36;
Iterval = 0.005;
Rl1 = zeros(1,ErrorSamplingNum+1);
Rl2 = zeros(1,ErrorSamplingNum+1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
for iterr = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * Iterval;
    for itern = 1:testNumber
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

        %识别
        [rank_Rl1, rank_Rl2] = ParameterIdentification.identify_Walsh(r, 0.15);
        Rl1(iterr + 1) = Rl1(iterr + 1) + rank_Rl1;
        Rl2(iterr + 1) = Rl2(iterr + 1) + rank_Rl2;
        
        curr_waitbar = ((iterr)*testNumber + itern)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end

delete(h);
clear h;

Rl1 = Rl1 / testNumber;
Rl2 = Rl2 / testNumber;


figure(1)
hold on
plot(Iterval * (0:ErrorSamplingNum),Rl1,'k');
plot(Iterval * (0:ErrorSamplingNum),Rl2,'-or');
plot(Iterval * (0:ErrorSamplingNum),Rl2-Rl1,'-b');
%axis([0 0.01*ErrorSamplingNum 0 1]);







