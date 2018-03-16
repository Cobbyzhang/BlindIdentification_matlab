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
h1Card = GeneratorCard.h1Card;

%% 统一定义 
selected = 17;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
h1 = h1Card{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
testNumber = 100;
u = sum(v) - numel(v);
n_alpha = n * floor(u / (n - k) + 1);
rank_Rl1 = u + n_alpha * k / n;
dimension = 2^(n_alpha - rank_Rl1);

%% 识别率-误码率曲线
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 28;
defualtThreshold = 0.06;% (2,1,7)->0.12 && (3,2,3)->0.10 && (4,1,5)->0.08 && (3,1,3)->0.06
Iterval = 0.0025;
errorRate = 0;
defaultRowNumber = 1000;
Error = zeros(1,ErrorSamplingNum + 1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
for itert = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    
    threshold = defualtThreshold + Iterval * itert;
    for itern = 1:testNumber
        % 生成码字b1 & c1
        K= 30000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 通过无（有）噪声信道 -> c
        c = Tool.addErrorWithPossibility(c1, errorRate);

        % 接受到截断信号 c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);

        %识别
        %dimension_estimate = ParameterIdentification.identify_dimension_Rl1(r, 0.15);
        
        R = Tool.reshapeMatrixWithRow(r,n_alpha)';
        w = zeros(1,2^n_alpha);
        rowNumber = min(size(R,1),defaultRowNumber);
        for iterr = 1:rowNumber
            wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
            w(1,wValue) = w(1,wValue) + 1;
        end
        Y = MyFWHT.myfwht(w);
        % dimension_estimate = numel(find(Y > rowNumber * threshold));
        peakSet = find(Y > rowNumber * threshold);
        % 绘图

        % 判断
        %if dimension_estimate > dimension
        if any(setdiff(peakSet, h1))
            Error(itert + 1) = Error(itert + 1) + 1;
%             figure(3)
%             stem(Y,'Marker','none');
%             hold on
%             plot(1:2^n_alpha,rowNumber*threshold*ones(1,2^n_alpha));
%             hold off
%             pause
        end
        curr_waitbar = ((itert)*testNumber + itern)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end

delete(h);
clear h;

Error = Error / testNumber;


%% 绘图

th = rowNumber * (defualtThreshold + Iterval * (0:ErrorSamplingNum));
%th = defualtThreshold + Iterval * (0:ErrorSamplingNum);
T = normcdf(th * sqrt(rowNumber)).^(2^n_alpha / numel(h1) - 1);
T1 = normcdf(th * sqrt(rowNumber)).^(2^n_alpha - numel(h1));
% T0 = 1 - (1 - normcdf(th*sqrt(rowNumber))) * 2^n_alpha;

figure(1)
hold on
plot(th, Error, 'k');
plot(th, 1 - T,'b');
%plot(th, T1,'--r');
axis([defualtThreshold defualtThreshold + Iterval * ErrorSamplingNum 0 1]);
% plot(th, T0, 'r');
hold off

figure(2)
semilogy(th, Error, th, 1 - T);
% semilogy(th, Error, th, 1 - T, th, 1-T0 );




%%
%TT = normcdf((th*(2^n_alpha-numel(h1))+numel(h1))*sqrt(rowNumber/(2^n_alpha*(2^n_alpha-2*numel(h1))))).^(2^n_alpha-numel(h1));
%TT1 = normcdf((th*(2^n_alpha-1)+1)*sqrt(rowNumber/(2^n_alpha*(2^n_alpha-2)))).^(2^n_alpha-1);
%plot(th, T,'b', th, TT, 'r');
%semilogy(th,Error,th, 1-T,th, 1-TT );

