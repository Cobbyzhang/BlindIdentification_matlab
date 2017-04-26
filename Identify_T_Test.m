clc
clear
%{
%% 候选编码器g
% g1
v1  = [2,3];
g1  = poly2trellis(v1,[3 1 2;4 7 1]);
gt1 = poly2trellis(v1,[3 1 2;1 4 7]);
n1  = 3;
k1  = 2;
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

%g2
v2  = [3,3];
g2  = poly2trellis(v2,[4 6 1;5 1 2]);
gt2 =  poly2trellis(v2,[1 7 3;4 6 1]);
n2  = 3;
k2  = 2;

%g3
v3  = [4,4,4];
g3  = poly2trellis(v3,[15 06 10 11;04 16 11 13;14 01 12 16]);
gt3 = poly2trellis(v3,[10 17 03 05;11 10 01 02;05 11 13 14]);
%GD3 = poly2symmat(v3,[15 06 10 11;04 16 11 13;14 01 12 16]);
%pretty(GD3)
%[v_test,poly_test] = symmat2poly(GD3);
n3  = 4;
k3  = 3;
%{
G(D) = 
  +-                                                      -+ 
  |    3                2                         3        | 
  |   x + x + 1 ,      x +  x      ,    1     ,  x + 1     | 
  |                                                        | 
  |                   2                3          3   2    | 
  |      x      ,    x  + x + 1    ,  x  + 1  ,  x + x + 1 | 
  |                       3            2          2        | 
  |     x + 1   ,        x         ,  x + 1   ,  x + x + 1 | 
  +-                                                      -+
%}

%g4
v4  = [3,6,6];
g4  = poly2trellis(v4,[4 6 1 5 2;01 32 43 60 04;24 61 42 70 41]);
%gt4 = poly2trellis(v4,[4 6 1 5 2;40 37 57 01 73;31 41 02 07 43]);

n4  = 5;
k4  = 3;
GD4 = poly2symmat(v4,[4 6 1 5 2;01 32 43 60 04;24 61 42 70 41]);
T4 = num2symmat([1 0 0;11 0 1;12 1 1]);
%T4 = poly2symmat([1 1 1],[1 0 0;0 1 0;1 1 1]);
[v4_test,poly4_test] = symmat2poly(mod(T4*GD4,2));
gt4 = poly2trellis(v4_test,poly4_test);
%GDT4 = poly2symmat(v4,[4 6 1 5 2;40 37 57 01 73;31 41 02 07 43]);
%pretty(T4)
%pretty(GD4)
%pretty(GDT4)
%{
% GD4 = 
%   +-                                                      -+ 
%   |                             2         2                | 
%   |     1,      x + 1,         x ,       x  + 1,      x    | 
%   |                                                        | 
%   |     5     4    2       5    4                     3    | 
%   |    x ,   x  + x  + x, x  + x  + 1,    x + 1,     x     | 
%   |                                                        | 
%   |   3        5              4         2           5      | 
%   |  x  + x,  x  + x + 1,    x  + 1,   x  + x + 1, x  + 1  | 
%   +-                                                      -+
%}


%% 统一定义 (就不要修改后面的代码了)
% v  = v2;
% g  = g2;
% gt = gt2;
% n  = n2;
% k  = k2;
%}

%% 载入测试码集合
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;

%% 统一定义 (就不要修改后面的代码了)
selected = 5;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
sNum = 10 * k; % 同步头长度

%% 生成码字b1 & c1
K= 3000;
b1 = round(rand(1,K));
c1 = convenc(b1,g);

%% c1 通过无（有）噪声信道 -> c
%c = awgn(c1,3);
c = c1;

%% 接受到截断信号 c -> r
%startnum = randi([100,200],1);
startnum = 1;
endnum = randi([K-100,K],1);
r = c(startnum:endnum);

%% 根据同步头以及Gmin识别生成矩阵g1
% 输入Gmin,接受码字r，同步头s
% 输出初等变换矩阵T
% 暂时没有办法将Gmin转换为g1t，暂时采用手动输入方式
b1t = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %威特比译码
x = reshape(b1(1:sNum-rem(sNum,k)),k,[]);% 重排一下得到顺序
disp('x = ') 
disp(x);
xt = reshape(b1t(1:numel(x)),size(x));
disp('xt = ')
disp(xt);
T = Identify_T(x,xt,v); % 识别算法
disp('T=')
disp(T)
