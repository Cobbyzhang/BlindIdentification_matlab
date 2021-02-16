clc
clear
%% ��������뼯��
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 12;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
t_inv  = symmat2num(mod(inv(num2symmat(t)),2));
tblen = max(max(v)); %���������
degT = max(max(v)) - min(min(v));
repetition = 100;
testLength = 300000;
%testNum = 4;
%error = ones(1,testNum);

%% ���Ծ�������
% testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1);
% testTimes = testNum * repetition;
ErrorRate = 0.01:0.01:0.05;
l = numel(ErrorRate);
ber = zeros(1,l);
berbb = zeros(1,l);
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for iterE = 1:l
    errorrate = ErrorRate(iterE);
    errorbb = zeros(1,repetition);
    error = zeros(1,repetition);
    for iterR = 1:repetition
        if getappdata(h,'canceling')
            break
        end
        b = round(rand(1,testLength)); %������Ϣ
        code = convenc(b, g);  % ��g���б���
        out = randperm(testLength);  
        e = out(1:round(errorrate * testLength)); % ���մ����ʵõ�����λ���
        code(e) = ~code(e); % ��Ӵ���
        bt = vitdec(code,gt,tblen,'trunc','hard'); % �Ժ��������code����ʹ��gt���ر�����
        bb = vitdec(code,g, tblen,'trunc','hard');
        b_temp = reshape(b,k,[]);% ����һ�µõ�˳��
        bt_standard = reshape(T_transfer(b_temp,t_inv),1,[]);         % ���ɱ�׼���֣���������
        error(iterR) = sum(bt ~= bt_standard);
        errorbb(iterR) = sum(bb ~= b);
        progress = ((iterE - 1) * repetition + iterR) / (repetition * l);
        str = ['Please wait...',num2str(100 * progress, '%.2f'),'%'];
        waitbar(progress,h,str);

    end
    ber(iterE) = sum(error) / (repetition * testLength);
    berbb(iterE) = sum(errorbb) / (repetition * testLength);
end
delete(h);
clear h;

disp(ber);
disp(berbb);















