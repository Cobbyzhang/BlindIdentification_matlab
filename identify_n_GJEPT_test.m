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

%% 统一定义 (就不要修改后面的代码了)
selected = 1;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};

defaultRowNumber = 200;
u = sum(v)-numel(v);
n_alpha = n*floor(u/(n-k)+1);
gammaOpt = 0.6;




testNumber = 100;


%% 识别率-误码率曲线
h = waitbar(0,'Please wait...','Name','Recognition Rate','CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
ErrorSamplingNum = 2;
Error = zeros(1,ErrorSamplingNum + 1);
testTimes = ( ErrorSamplingNum + 1) * testNumber;
iteration = 1;
for iterr = 1:ErrorSamplingNum
    if getappdata(h,'canceling')
        break
    end
    errorRate = iterr * 0.01;
    for itert = 1:testNumber
        if getappdata(h,'canceling')
            break
        end
        % 生成码字b1 & c1
        K= 3000;
        b1 = round(rand(1,K));
        c1 = convenc(b1,g);

        % c1 通过无（有）噪声信道 -> c
        c = Tool.addErrorWithPossibility(c1,errorRate);

        % 接受到截断信号 c -> r
        startnum = 1;
        endnum = randi([K-100,K],1);
        r = c(startnum:endnum);

        %识别
        for iter = 1:iteration
            maxN = min(floor(sqrt(size(r,2))),25); % 行数大于列数就没意义了
            Z_l = zeros(1, maxN);  
            for itern = 2:maxN  %l表示当前列数
                R = Tool.reshapeMatrixWithRow(r,itern)'; % 生成截断矩阵 r -> R
                rowNumber = min(size(R,1), defaultRowNumber + itern); % L表示当前行数
                decision = (rowNumber - itern) * gammaOpt / 2; % 判决门限
                R = R(1:rowNumber,:);
                permutation = randi(rowNumber, [1, itern]); % 随机交换部分行和列，计算
                R_temp = R(1:itern, :);                     % 随机交换部分行和列
                R(1:itern, :) = R(permutation, :);          % 随机交换部分行和列
                R(permutation, :) = R_temp;                 % 随机交换部分行和列
                [L,l] = size(R);
                G = R;
                B = eye(l);
                if itern == n_alpha && any(find(c1~=c) < n_alpha^2)
                    disp(find(c1~=c))
                end
                for iter1 = 1 : l - 1
                    if ~G(iter1, iter1)
                        pp = find(G(iter1, iter1 : end));%注意找到的是相对位置
                        if any(pp)
                            G(:, [iter1, iter1 + pp(1) - 1]) = G(:, [iter1 + pp(1) - 1, iter1]);
                            B(:, [iter1, iter1 + pp(1) - 1]) = B(:, [iter1 + pp(1) - 1, iter1]);
                        else
                            qq = find(G(iter1 : end, iter1));
                            if ~any(qq)
                                continue
                            end
                            G([iter1, iter1 + qq(1) - 1], :) = G([iter1 + qq(1) - 1, iter1], :);
                        end
                    end
                    for iter2 = iter1 + 1 : l
                        if G(iter1, iter2) == 1
                            G(:, iter2) = xor(G(:, iter2), G(:, iter1));
                            B(:, iter2) = xor(B(:, iter2), B(:, iter1));
                        end
                    end
                end
                N_l = sum(G(itern + 1 : end, :), 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
                if any(find(N_l < decision))
                    %disp(B(:,find(N_l < decision)))
                    Z_l(itern) = Z_l(itern) + nnz(find(N_l < decision));  % Number of nonzero matrix elements，也就是；列数为l时，有多少个线性组合的列
                end
            
                % 找到n 
                f = find(Z_l > 0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
                if numel(f)<2
                    n_estimate = 0;
                    disp('Identify insuccessfully')
                    continue
                end
                n_estimate = f(2)-f(1);
            end
            
            if n_estimate == n
                break
            end
        end
        if n_estimate ~= n
            Error(iterr + 1) = Error(iterr + 1) + 1;
        end
        curr_waitbar = (iterr*testNumber + itert)/testTimes;
        str = ['Please wait...',num2str(100 * curr_waitbar,'%.2f'),'%'];
        waitbar(curr_waitbar,h,str);
    end
end


delete(h);
clear h;

th = 0:0.01:0.01*ErrorSamplingNum;
plot(th,1-Error/testNumber);
axis([0 0.01*ErrorSamplingNum 0 1]);

%save(['+data\\C322_Gauss_',num2str(iteration),'_iteration.mat'])
