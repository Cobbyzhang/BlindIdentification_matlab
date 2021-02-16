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
selected = 11;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
degT = max(max(v)) - min(min(v));
repetition = 200000;
testNum = 20;
error = ones(1,testNum);
%% ����ʶ���ʴ�����
% testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1);
% ErrorSetCell = cell(1,testNum);
% for iter = 1:testNum
%     ErrorSetCell{iter} = zeros(1,2^iter);
% end
testTimes = testNum * repetition;
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for sNum = 1:testNum
    pferror = 0;
    for iter = 1:repetition
        if getappdata(h,'canceling')
            break
        end
        % rN = randi(2^(k * sNum),1)-1;
        K= 40 * k - (sNum * k);
        b1 = round(rand(1,K));
        % firstblc = dec2bin(rN,sNum * k) - 48;
        firstblc = round(rand(1,sNum * k));
        b = [firstblc, b1];
        c1 = convenc(b, g);
        c = c1;
        startnum = 1;
        endnum = randi(10,1);
        r = c(startnum:end-endnum);
        bt = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %���ر�����
        x = reshape(b(1:sNum * k),k,[]);% ����һ�µõ�˳��
        xt = reshape(bt(1:numel(x)),size(x));
        T = Identify_T(x,xt,v); % ʶ���㷨
        if ~isequal(T,t)
            pferror = pferror + 1;
            % ErrorSetCell{sNum}(iter)=1;
            % ��ʱ�������������� begin
            %
%             if rank(x)==k && rank(xt)==k &&any(x(1,1:end-degT)) && any(x(2,1:end-degT))
%                 error_type_bug = error_type_bug + 1; 
%             end
            %
            % ��ʱ�������������� end
        end
        % progress = ((2^(sNum * k)  - 2^k)/(2^k - 1) + iter)/testTimes;
        progress = ((sNum - 1) * repetition + iter)/testTimes;
        str = ['Please wait...',num2str(100 * progress,'%.2f'),'%'];
        waitbar(progress,h,str);
    end
    error(sNum) = pferror;
end
delete(h);
clear h;
% ber = error./2.^(k:k:testNum*k);
ber = error/repetition;
plot(ber);


%% ���������Ϣ
% ErrorSetCell = arrayfun(@(x,y)dec2bin(find(x{:})-1,y),ErrorSetCell,2*(1:testNum),'un',0);
% if error_type_bug
%     disp('There are some errors that do not belong to error type 1,2 or 3!')
% else
%     disp('No error type bug!')
% end
toc
save(['data\\G',num2str(selected),'_RecognitionRate_sampling.mat'])