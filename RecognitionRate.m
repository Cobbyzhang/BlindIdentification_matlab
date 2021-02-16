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
selected = 2;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
degT = max(max(v)) - min(min(v));
repetition = 100000;
sNum = 1 : 18;
sNumSampling = size(sNum, 2);
Error = zeros(repetition,sNumSampling);
error_type_bug = 0; % ��¼��1,2,3�ʹ���ĸ���
%% ����ʶ���ʴ�����
% testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1);
% ErrorSetCell = cell(1,testNum);
% for iter = 1:testNum
%     ErrorSetCell{iter} = zeros(1,2^iter);
% end
testTimes = repetition;
% h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');

clc
Tool.parfor_progress(testTimes);
parfor iter = 1:repetition
%     pferror = 0;
%     for iter = 1:2^(sNum * k)
    for iters = 1:sNumSampling
%         if getappdata(h,'canceling')
%             break
%         end
        snum = sNum(iters);
%         K= 40 * k - (snum * k);
        K = 40 * k;
        b1 = round(rand(1,K));
%         firstblc = dec2bin(randi(2^(snum*k)) - 1,snum * k) - 48;
%         b = [firstblc, b1];
        b = b1(1:end-rem(length(b1),k));
        c1 = convenc(b, g);
        c = c1;
        startnum = 1;
        endnum = randi([1,10],1);
        r = c(startnum:end - endnum);
        bt = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %���ر�����
        x = reshape(b(1:snum * k),k,[]);% ����һ�µõ�˳��
        xt = reshape(bt(1:numel(x)),size(x,1),size(x,2));
        T = Identify_T(x,xt,v); % ʶ���㷨
        if ~isequal(T,t)
            Error(iter,iters) = 1;
%             pferror = pferror + 1;
%             ErrorSetCell{sNum}(iter)=1;
            % ��ʱ�������������� begin
            %
%             if rank(x)==k && rank(xt)==k &&any(x(1,1:end-degT)) && any(x(2,1:end-degT))
%                 error_type_bug = error_type_bug + 1; 
%             end
            %
            % ��ʱ�������������� end
        end
%         progress = ((2^(sNum * k)  - 2^k)/(2^k - 1) + iter)/testTimes;
%         progress = ((2^(sNum * k)  - 2^k)/(2^k - 1) + iter)/testTimes;
%         str = ['Please wait...',num2str(100 * progress,'%.2f'),'%'];
%         waitbar(progress,h,str);
    end
%     error(sNum) = pferror;
    Tool.parfor_progress;
end
% delete(h);
% clear h;
% ber = Error./2.^(k:k:testNum*k);
Tool.parfor_progress(0);
ErrorMean = sum(Tool.reshapeMatrixWithRow(Error, repetition)) / repetition;
semilogy(sNum,ErrorMean,'-k');
axis([0 sNum(end) 0 1]);

%% ���������Ϣ
% ErrorSetCell = arrayfun(@(x,y)dec2bin(find(x{:})-1,y),ErrorSetCell,2*(1:testNum),'un',0);
% if error_type_bug
%     disp('There are some errors that do not belong to error type 1,2 or 3!')
% else
%     disp('No error type bug!')
% end

% save(['data\\G',num2str(selected),'_Enumerate.mat'])