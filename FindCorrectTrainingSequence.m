clc
clear
tic

%% ��������뼯��
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 10;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
tblen = max(max(v)); %���������
degT = max(max(v)) - min(min(v));
testNum = 3;
% error = ones(1,testNum);
%% ����ʶ���ʴ�����
% testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1);
testTimes = 2^(3 * testNum);
correctSet = [];
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
sNum = testNum;
pferror = 0;
for iter = 1:2^(sNum * k)
    if getappdata(h,'canceling')
        break
    end
    K= 40 * k - (sNum * k);
    b1 = round(rand(1,K));
    firstblc = dec2bin(iter - 1,sNum * k) - 48;
    b = [firstblc, b1];
    c1 = convenc(b, g);
    c = c1;
    startnum = 1;
    endnum = randi([K-10,K],1);
    r = c(startnum:endnum);
    bt = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %���ر�����
    x = reshape(b(1:sNum * k),k,[]);% ����һ�µõ�˳��
    xt = reshape(bt(1:numel(x)),size(x));
    T = Identify_T(x,xt,v); % ʶ���㷨
    if ~isequal(T,t)
        pferror = pferror + 1;
        if rank(x)==k && rank(xt)==k &&any(x(1,1:end-degT)) && any(x(2,1:end-degT))
        end
    else
        correctSet = [correctSet, iter];
    end
    str = ['Please wait...',num2str(100 * iter/testTimes,'%.2f'),'%'];
    waitbar(iter/testTimes,h,str);
end
error = pferror;

delete(h);
clear h;
ber = error/2^(testNum*k);
disp(correctSet)
toc
