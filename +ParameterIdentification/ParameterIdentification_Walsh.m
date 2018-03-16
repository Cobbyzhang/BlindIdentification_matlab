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

%% ͳһ���� 
selected = 13;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
sNum = 10 * k; % ͬ��ͷ����
testNumber = 10;
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);

%% ʶ����-����������
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 16;
Error = zeros(1,ErrorSamplingNum+1);
Errorn = zeros(1,ErrorSamplingNum+1);
Errork = zeros(1,ErrorSamplingNum+1);
Erroru = zeros(1,ErrorSamplingNum+1);
testTimes = (ErrorSamplingNum + 1) * testNumber;
for iterr = 0:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itern = 1:testNumber
        % ��������b1 & c1
        K= 30000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 ͨ���ޣ��У������ŵ� -> c
        c = Tool.addErrorWithPossibility(c1,errorRate);

        % ���ܵ��ض��ź� c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);

        %ʶ��
        [n_estimate, k_estimate, u_estimate] = ParameterIdentification.identify_Walsh(r);

        if n_estimate ~= n
            Errorn(iterr + 1) = Errorn(iterr + 1) + 1;
        end
        if u_estimate ~= u
            Erroru(iterr + 1) = Erroru(iterr + 1) + 1;
        end
        if k_estimate ~= k
            Errork(iterr + 1) = Errork(iterr + 1) + 1;
        end
        if n_estimate ~= n || u_estimate ~= u || k_estimate ~= k
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
plot(0.01*(0:ErrorSamplingNum),1-Errorn/testNumber,'k');
plot(0.01*(0:ErrorSamplingNum),1-Errork/testNumber,'-or');
plot(0.01*(0:ErrorSamplingNum),1-Erroru/testNumber,'-*g');
plot(0.01*(0:ErrorSamplingNum),1-Error/testNumber,'b');
axis([0 0.01*ErrorSamplingNum 0 1]);







