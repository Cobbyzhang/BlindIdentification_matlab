clc
clear
%{ 
%% 候选编码器g 备份
% g1
v1  = [2,3];
g1  = poly2trellis(v1,[3 1 2;4 7 1]);
gt1 = poly2trellis(v1,[3 1 2;1 4 7]);
n1  = 3;
k1  = 2;
t1  = [1 0;3 1];
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
t2 = [1 1;0 1];
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
t4 = [1 0 0;11 0 1;12 1 1];
T4 = num2symmat(t4);
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

v5  = [3,4,6,6];
g5  = poly2trellis(v5,[4 2 5 1 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
n5  = 7;
k5  = 4;
GD5 = poly2symmat(v5,[4 2 5 1 6 3 7;11 7 12 16 5 17 2;51 62 4 23 60 40 7;10 24 61 77 5 16 64]);
% GD5 =
% [             1,             x,     x^2 + 1,                           x^2,     x + 1,           x^2 + x,     x^2 + x + 1]
% [       x^3 + 1, x^3 + x^2 + x,     x^2 + 1,                   x^2 + x + 1,   x^3 + x, x^3 + x^2 + x + 1,             x^2]
% [ x^5 + x^2 + 1,   x^4 + x + 1,         x^3,                 x^5 + x^4 + x,     x + 1,                 1, x^5 + x^4 + x^3]
% [           x^2,       x^3 + x, x^5 + x + 1, x^5 + x^4 + x^3 + x^2 + x + 1, x^5 + x^3,   x^4 + x^3 + x^2,     x^3 + x + 1]
t5 = [1 0 0 0;2 1 0 0;11 5 1 0;13 4 1 1];
T5 = num2symmat(t5);
%   +-                           -+ 
%   |       1,         0,   0, 0  | 
%   |                             | 
%   |       x,         1,   0, 0  | 
%   |                             | 
%   |    3           2            | 
%   |   x  + x + 1, x  + 1, 1, 0  | 
%   |                             | 
%   |   3    2         2          | 
%   |  x  + x  + 1,   x ,   1, 1  | 
%   +-                           -+
[v5_test,poly5_test] = symmat2poly(mod(T5*GD5,2));
gt5 = poly2trellis(v5_test,poly5_test);
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
selected = 11;
v  = vCard{selected};
g  = GCard{selected};
gt = TGCard{selected};
n  = nCard{selected};
k  = kCard{selected};
t  = tCard{selected};
%sNum = 10 * k; % 同步头长度
tblen = max(max(v)); %最大记忆深度
degT = max(max(v)) - min(min(v));
%repetition = 1000000;
testNum = 4;
error = ones(1,testNum);
error_type_bug = 0; % 记录非1,2,3型错误的个数
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
            ErrorSetCell{sNum}(iter)=1;
            % 临时处理函数，待完善 begin
            %
            if rank(x)==k && rank(xt)==k &&any(x(1,1:end-degT)) && any(x(2,1:end-degT))
                error_type_bug = error_type_bug + 1; 
            end
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
if error_type_bug
    disp('There are some errors that do not belong to error type 1,2 or 3!')
else
    disp('No error type bug!')
end