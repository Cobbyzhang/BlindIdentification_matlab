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
selected = 14;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
h1 = h1Card{selected};
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度
testNumber = 100;
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);
rank_Rl1 = u + n_alpha * k / n;
dimension = 2^(n_alpha - rank_Rl1);
defualtRowNumber = 1000;

%%

w = zeros(1,2^n_alpha); % 研究是否正态分布
% otherSet = setdiff(1:2^n_alpha, h1);% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
% chooseObject = otherSet(randi(numel(otherSet), 1, 1));% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
% valueDistribution = zeros(1, 2 * defualtRowNumber + 1);% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
% valueSet = zeros(testNumber, 1);% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for itern = 1:testNumber
    if getappdata(h,'canceling')
        break
    end
    % 生成码字b1 & c1
    K= 30000;
    b1 = round(rand(1,K));
    c1 = convenc(b1,g);

    % c1 通过无（有）噪声信道 -> c
    c = Tool.addErrorWithPossibility(c1,0);

    % 接受到截断信号 c -> r
    startnum = 1;
    endnum = randi([K-100,K],1);
    %endnum = K;
    r = c(startnum:endnum);
    R = Tool.reshapeMatrixWithRow(r,n_alpha)';
%     w = zeros(1,2^n_alpha); % 研究Rl各列抽取是否等概论，Y各列和是否均值为0
    rowNumber = min(size(R,1), defualtRowNumber);
    
    for iterr = 1 : rowNumber
        wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
        %w(1,wValue) = w(1,wValue) + 1;
        w(1,wValue) = 1;
    end
%     Y = MyFWHT.myfwht(w); % 研究Rl各列抽取是否等概论，Y各列和是否均值为0
    % stem(Y,'Marker','none');
%     valueSet(itern) = Y(chooseObject);% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
%     valueObject = Y(chooseObject) + defualtRowNumber + 1;% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
%     valueDistribution(valueObject) = valueDistribution(valueObject) + 1;% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
    
    curr_waitbar = itern/testNumber;
    str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
    waitbar(curr_waitbar,h,str);
end
delete(h);
clear h;

%% 研究各列之间的独立性
if sum(w) ~= 2^n_alpha/numel(h1)
    warning('没有遍历到所有可选行！！！')
end
H = hadamard(2^n_alpha);
hh = H(find(w),:);
hh(:, h1) = [];
disp(rank(hh))



%% 研究是否正态分布
% 
% figure(1)
% ind = -defualtRowNumber:defualtRowNumber;
% stem(ind, valueDistribution,'Marker','none');
% 
% figure(2)
% F = valueSet/sqrt(defualtRowNumber);
% normplot(F);
% ALPHA = 0.05;
% [H,P,LSTAT,CV] = lillietest(valueSet/sqrt(defualtRowNumber), ALPHA)
% 
% 
% figure(3)
% [f,xi] = ksdensity(F);
% y = normpdf(xi);
% plot(xi,y,'-r',xi,f);


%% 研究Rl各列抽取是否等概论，Y各列和是否均值为0
% figure(1)
% stem(w/sum(w),'Marker','none');
% hold on
% banchmark = numel(h1)/2^n_alpha;
% plot(banchmark*ones(1,2^n_alpha));
% hold off
% 
% figure(2)
% Y = MyFWHT.myfwht(w);
% stem(Y,'Marker','none');
% 
% disp((sum(Y)-sum(Y(h1)))/testNumber)


%%
% %% 识别率-误码率曲线
% h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
% ErrorSamplingNum = 28;
% defualtThreshold = 0.09;% (2,1,7)->0.12 && (3,2,3)->0.10 && (4,1,5)->0.08 && (3,1,3)->0.06
% Iterval = 0.0025;
% errorRate = 0.03;
% defaultRowNumber = 1000;
% Error = zeros(1,ErrorSamplingNum+1);
% testTimes = (ErrorSamplingNum + 1) * testNumber;
% for itert = 0:ErrorSamplingNum
%     if getappdata(h,'canceling')
%         break
%     end
%     
%     threshold = defualtThreshold + Iterval * itert;
%     for itern = 1:testNumber
%         % 生成码字b1 & c1
%         K= 30000;
%         b1 = round(rand(1,K));
%         c1 = convenc(b1,g);
% 
%         % c1 通过无（有）噪声信道 -> c
%         c = Tool.addErrorWithPossibility(c1,errorRate);
% 
%         % 接受到截断信号 c -> r
%         startnum = 1;
%         endnum = randi([K-100,K],1);
%         r = c(startnum:endnum);
% 
%         %识别
%         %dimension_estimate = ParameterIdentification.identify_dimension_Rl1(r, 0.15);
%         
%         R = Tool.reshapeMatrixWithRow(r,n_alpha)';
%         w = zeros(1,2^n_alpha);
%         rowNumber = min(size(R,1),defaultRowNumber);
%         for iterr = 1:rowNumber
%             wValue = TypeConversion.binVec2dec(R(iterr,:)) + 1;
%             w(1,wValue) = w(1,wValue) + 1;
%         end
%         Y = MyFWHT.myfwht(w);
%         % dimension_estimate = numel(find(Y > rowNumber * threshold));
%         peakSet = find(Y > rowNumber * threshold);
%         % 绘图
% 
%         % 判断
%         %if dimension_estimate > dimension
%         if any(setdiff(peakSet, h1))
%             Error(itert + 1) = Error(itert + 1) + 1;
% %             figure(3)
% %             stem(Y,'Marker','none');
% %             hold on
% %             plot(1:2^n_alpha,rowNumber*threshold*ones(1,2^n_alpha));
% %             hold off
% %             pause
%         end
%         curr_waitbar = ((itert)*testNumber + itern)/testTimes;
%         str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
%         waitbar(curr_waitbar,h,str);
%     end
% end
% 
% delete(h);
% clear h;
% 
% Error = Error / testNumber;
% 
% 
% %% 绘图
% figure(1)
% hold on
% th = defualtThreshold + Iterval * (0:ErrorSamplingNum);
% plot(th, 1 - Error, 'k');
% axis([defualtThreshold defualtThreshold + Iterval * ErrorSamplingNum 0 1]);
% T = normcdf(th*sqrt(rowNumber)).^(2^n_alpha-numel(h1));
% plot(th, T,'b');
% hold off
% 
% figure(2)
% semilogy(th, Error, th, 1 - T);

