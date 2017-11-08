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

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 1;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
testNumber = 1000;


%% ʶ����-����������
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 5;
Error = zeros(1,ErrorSamplingNum);
testTimes = ErrorSamplingNum * testNumber;
iteration = 50;
for iterr = 1:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itern = 1:testNumber
        if getappdata(h,'canceling')
            break
        end
        % ��������b1 & c1
        K= 3000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 ͨ���ޣ��У������ŵ� -> c
        c = Tool.addErrorWithPossibility(c1,errorRate);

        % ���ܵ��ض��ź� c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);

        %ʶ��
        [n, n_alpha] = ParameterIdentification.identify_n_Gauss(r, 0.6, iteration);

        if n ~= 3 || n_alpha ~= 12
            Error(iterr) = Error(iterr) + 1;
        end
        curr_waitbar = ((iterr-1)*testNumber + itern)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end


delete(h);
clear h;

plot(0.01*(1:ErrorSamplingNum),1-Error/testNumber);
axis([0.01 0.01*ErrorSamplingNum 0 1]);

save(['data\\C322_Gauss_',num2str(iteration),'_iteration.mat'])


