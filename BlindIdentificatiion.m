clc
clear

%% 生成编码器g1
g1 = poly2trellis([2,3],[3 1 2;4 7 1]);
%{
G(D) = 
  +-                                    -+ 
  |                                      | 
  |   x + 1 ,        x       ,      1    | 
  |                                      | 
  |               2                  2   | 
  |      1  ,    x  + x + 1  ,      x    | 
  +-                                    -+
%}
g1t = poly2trellis([2,3],[3 1 2;1 4 7]);
%{
T(D)G(D) = 
  +-                                    -+ 
  |                                      | 
  |   x + 1 ,       x      ,      1      | 
  |                                      | 
  |      2                     2         | 
  |     x   ,       1      ,  x  + x + 1 | 
  +-                                    -+
%}

%g2 = poly2trellis([2,3],[3 1 2;7 6 3]);


%% 生成码字b1 & c1
K= 1000;
b1 = round(rand(1,K));
%temp_b2 = [b1(1:2:K-1);b1(2:2:K)]; % 取出来两列
%temp_b2(1,:) = rem(temp_b2(1,:) + [0,temp_b2(2,1:end-1)],2);
%b2 = zeros(1,K);
%b2(1:2:K-1) = temp_b2(1,:);
%b2(2:2:K) = temp_b2(2,:);

c1 = convenc(b1,g1);
%c2 = convenc(b2,g2);

%% c1 通过无（有）噪声信道 -> c

%c = awgn(c1,3);
c = c1;

%% 测试译码函数正确性
% b1_test = vitdec(c,g1,3,'trunc','hard');
% if any(b1==b1_test)
%     disp('译码正确！')
% end


%% 接受到截断信号 c -> r
%startnum = randi([100,200],1);
startnum = 1;
endnum = randi([K-100,K],1);

r = c(startnum:endnum);

%% 生成截断矩阵 r -> R
%MaxN = 60; % 尝试的n的最大值
maxN = floor(sqrt(size(r,2))); % 行数大于列数就没意义了
gammaOpt = 0.6; % 最优判决门限
Z_l = zeros(1, maxN); % 
for l = 2:maxN  %l表示当前列数
%iter = 5;
    L = floor(size(r, 2) / l); % L表示当前行数
    R = reshape(r(1: l * L), l, L)'; % 当前截断矩阵
    decision = (L - l) * gammaOpt / 2; % 判决门限


%% 随机交换部分行和列
%Iteration
%     permutation = randi(L, [1, l]);
%     R(1:l, :) = R(permutation, :);

%% 实现一个函数，通过行列变换将R变为下三角矩阵，输出列变换矩阵和下三角矩阵
    [G, ~] = LT_transfer(R); % 分解
    N_l = sum(G, 1); % 每一列的1的个数，当某一列1的个数小于门限时，认为这一列是其他列的线性组合
    Z_l(l) = nnz(find(N_l < decision));  % Number of nonzero matrix elements，也就是；列数为l时，有多少个线性组合的列


end

%% 找到n 
pp = find(Z_l>0); % 找到所有导致线性相关的l，这说明l此时为n的倍数
nEstimate = pp(2)-pp(1); % 差值就是估计的n

%% 找到na 以及 H
L1 = floor(size(r, 2) / pp(1));
R1 = reshape(r(1: pp(1) * L1), pp(1), L1)';
[G1, B1] = LT_transfer(R1);
N_l1 = sum(G1(pp(1)+1:end,:),1);
columnH = find(N_l1<((L1 - pp(1)) * gammaOpt/2 ));
H1 = B1(:,columnH);
nAlphaEstimate = size(H1,1);
alpha = nAlphaEstimate/nEstimate;
%disp('H1 = ')
%disp(H1)
% disp('G1(l*l) = ')
% disp(G1(1:l,:))

%% 确定k 和 v 
kv = zeros(2,(nEstimate^2 - nEstimate)/2);
iter = 1;
for iterk = 1:nEstimate - 1
    for iterZ = 1:nEstimate - iterk
        kv(1,iter) = iterk;
        kv(2,iter) = nAlphaEstimate * (1 - iterk/double(nEstimate)) - iterZ;
        iter = iter + 1;
    end
end


%% 找到对偶码的生成矩阵
L = floor(size(r, 2) / nAlphaEstimate);
R = reshape(r(1: nAlphaEstimate * L), nAlphaEstimate, L)';  
for iter = 1:size(kv,2)
    kEstimate = kv(1,iter);
    vEstimate = kv(2,iter);
    for sss = 1:nEstimate-kEstimate
        columns = [1:kEstimate,kEstimate+sss];
        Rl = R(:,columns);
    end
end

%% 重构校验矩阵的多项式形式HD
h = reshape(H1,nEstimate,alpha);
%HD = zeros(nEstimate,1);
syms 'x' a real;
HD = sym('x',[1,nEstimate]);
for i = 1:nEstimate
    %HD(i) = poly2sym(h(i,end:-1:1));
    HD(i) = poly2sym(h(i,:));
end
%display('H(D) = ');
%pretty(HD)
%% 重构生成矩阵G的系统形式GD_sys
GD_temp = null(HD);
[~, k] = size(GD_temp);
[nu, de] = numden(GD_temp);
for iterk = 1:k
    delcm = Multi_lcm(de(:,iterk));
    GD_temp(:,iterk) = mod(expand(GD_temp(:,iterk) * delcm),2);
end
GD_sys = GD_temp.';
%display('G(D) = ');
%pretty(GD_sys);

%% 利用不变因子分解得到生成矩阵g1的等效基础编码器Gbase


%% 得到生成矩阵g1的等效最小生编码器Gmin


%% 根据同步头以及Gmin识别生成矩阵g1
% 输入Gmin,接受码字r，同步头s
% 输出初等变换矩阵T

% 暂时没有办法将Gmin转换为g1t，暂时采用手动输入方式
b1t = vitdec(r(1:end-rem(length(r),3)),g1t,3,'trunc','hard');
v = [2,3];
% 同步头长度
sNum = 30;
% 重排一下得到顺序
x = reshape(b1(1:sNum-rem(sNum,k)),k,[]);
disp('x = ') 
disp(x);
xt = reshape(b1t(1:numel(x)),size(x));
disp('xt = ')
disp(xt);

T = Identify_T(x,xt,v);






