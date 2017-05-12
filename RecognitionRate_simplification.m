clc
clear
tic
%% 载入测试码集合
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;

%% 统一定义 (就不要修改后面的代码了)
selected = 11;
v  = vCard{selected};
k  = kCard{selected};
t  = tCard{selected};
t_inv  = symmat2num(mod(inv(num2symmat(t)),2));
testNum = 4;
error = ones(1,testNum);
% error_type_bug = 0; % 记录非1,2,3型错误的个数
%% 测试识别率错误率
testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1);
ErrorSetCell = cell(1,testNum);
for iter = 1:testNum
    ErrorSetCell{iter} = zeros(1,2^iter);
end
% testTimes = testNum * repetition;
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for sNum = 1:testNum
    pferror = 0;
    for iter = 1:2^(sNum * k)
        if getappdata(h,'canceling')
            break
        end
        b = dec2bin(iter - 1,sNum * k) - 48;
        x = reshape(b,k,[]);% 重排一下得到顺序
        xt = T_transfer(x,t_inv);
        T = Identify_T(x,xt,v); % 识别算法
        if ~isequal(T,t)
            pferror = pferror + 1;
            ErrorSetCell{sNum}(iter)=1;
            % 临时处理函数，待完善 begin
            %
            % if rank(x)==k && rank(xt)==k &&any(x(1,1:end-degT)) && any(x(2,1:end-degT))
            %    error_type_bug = error_type_bug + 1; 
            % end
            %
            % 临时处理函数，待完善 end

        end
        progress = ((2^(sNum * k)  - 2^k)/(2^k - 1) + iter)/testTimes;
        str = ['Please wait...',num2str(100 * progress,'%.2f'),'%'];
        waitbar(progress,h,str);
    end
    error(sNum) = pferror;
end
delete(h);
clear h;
ber = error./2.^(k:k:testNum*k);
plot(ber);


%% 处理错误信息
ErrorSetCell = arrayfun(@(x,y)dec2bin(find(x{:})-1,y),ErrorSetCell,2*(1:testNum),'un',0);
% if error_type_bug
%     disp('There are some errors that do not belong to error type 1,2 or 3!')
% else
%     disp('No error type bug!')
% end
toc