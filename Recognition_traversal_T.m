clc
clear
tic
%% 统一定义 (就不要修改后面的代码了)
v  = [3,5];
g  = poly2trellis(v,[5 2 7;2 35 20]);
n  = 3;
k  = 2;
GD = poly2symmat(v,[5 2 7;2 35 20]);
tblen = max(max(v)); %最大记忆深度
degT = max(max(v)) - min(min(v));
testNum = 4;
error = ones(2^(degT+1),testNum);
%% 测试识别率错误率
testTimes = 2^k * (2^(k * testNum) - 1)/(2^k - 1) ;
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
for tt = 0:2^(degT+1)-1
    t = [1,0;tt,1];
    TD = num2symmat(t);
    [v_test,poly_test] = symmat2poly(mod(TD*GD,2));
    gt = poly2trellis(v_test,poly_test);
    for sNum = 1:testNum
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
            bt = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %威特比译码
            x = reshape(b(1:sNum * k),k,[]);% 重排一下得到顺序
            xt = reshape(bt(1:numel(x)),size(x));
            T = Identify_T(x,xt,v); % 识别算法
            if ~isequal(T,t)
                pferror = pferror + 1;
            end
            progress = tt/2^(degT+1) + ((2^(sNum * k)  - 2^k)/(2^k - 1) + iter)/(testTimes*2^(degT+1));
            str = ['Please wait...',num2str(100 * progress,'%.2f'),'%'];
            waitbar(progress,h,str);
        end
        error(tt+1,sNum) = pferror;
    end
end
delete(h);
clear h;
ber = error./repmat(2.^(k:k:testNum*k),[size(error,1),1]);
% plot(ber);
toc

% save('data\\G7_travese_T_degT_2.mat')