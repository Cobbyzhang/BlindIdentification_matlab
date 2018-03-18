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
polyCard = GeneratorCard.polyCard;

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 13;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
poly = polyCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
sNum = 10 * k; % ͬ��ͷ����
testNumber = 50;
rowNumber = 200;
gammaOpt = 0.6;
u = sum(v)-numel(v);


%% ʶ����-����������
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 6;
Error = zeros(1,ErrorSamplingNum+1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
for iterr = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itern = 1:testNumber
        if getappdata(h,'canceling')
            break
        end
       %% ��������b1 & c1
        K= 3000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);


       %% c1 ͨ���ޣ��У������ŵ� -> c
        %c = awgn(c1,3);
        c = Tool.addErrorWithPossibility(c1,errorRate);


        %% ���ܵ��ض��ź� c -> r
        %startnum = randi([100,200],1);
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);
        %r = rand(1,size(c,2));

        %% 
        R = Tool.reshapeMatrixWithRow(r, n * (u + 1))';
        if rowNumber < size(R, 1)
            R(rowNumber + 1 : end, : ) = [];
        end
        l = (k + 1) * (u + 1);
        %parityMatrix = zeros(n-k, k+1);

        %% ����
        parityCheckMatrix = ParityCheckMatrixIdentification.estimation_of_parity_check(r, n, k, u, rowNumber, gammaOpt);
        if any(parityCheckMatrix < 0) || ~ParityCheckMatrixIdentification.isNullSpace(v, poly, (u+1)*ones(1,n-k), parityCheckMatrix)
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
th = 0.01*(0:ErrorSamplingNum);
plot(th, 1-Error/testNumber,'b');
axis([0 0.01*ErrorSamplingNum 0 1]);


