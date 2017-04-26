clc
clear
%{
%% ��ѡ������g
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


%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
% v  = v2;
% g  = g2;
% gt = gt2;
% n  = n2;
% k  = k2;
%}

%% ��������뼯��
load GeneratorCard.mat
vCard = GeneratorCard.vCard;
GCard = GeneratorCard.GCard;
nCard = GeneratorCard.nCard;
kCard = GeneratorCard.kCard;
tCard = GeneratorCard.tCard;
TGCard = GeneratorCard.TGCard;

%% ͳһ���� (�Ͳ�Ҫ�޸ĺ���Ĵ�����)
selected = 5;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % ͬ��ͷ����
tblen = max(max(v)); %���������
sNum = 10 * k; % ͬ��ͷ����

%% ��������b1 & c1
K= 3000;
b1 = round(rand(1,K));
c1 = convenc(b1,g);

%% c1 ͨ���ޣ��У������ŵ� -> c
%c = awgn(c1,3);
c = c1;

%% ���ܵ��ض��ź� c -> r
%startnum = randi([100,200],1);
startnum = 1;
endnum = randi([K-100,K],1);
r = c(startnum:endnum);

%% ����ͬ��ͷ�Լ�Gminʶ�����ɾ���g1
% ����Gmin,��������r��ͬ��ͷs
% ������ȱ任����T
% ��ʱû�а취��Gminת��Ϊg1t����ʱ�����ֶ����뷽ʽ
b1t = vitdec(r(1:end-rem(length(r),n)),gt,tblen,'trunc','hard'); %���ر�����
x = reshape(b1(1:sNum-rem(sNum,k)),k,[]);% ����һ�µõ�˳��
disp('x = ') 
disp(x);
xt = reshape(b1t(1:numel(x)),size(x));
disp('xt = ')
disp(xt);
T = Identify_T(x,xt,v); % ʶ���㷨
disp('T=')
disp(T)
