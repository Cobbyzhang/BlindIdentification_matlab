clc
clear

%% ���ɱ�����g1
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


%% ��������b1 & c1
K= 1000;
b1 = round(rand(1,K));
%temp_b2 = [b1(1:2:K-1);b1(2:2:K)]; % ȡ��������
%temp_b2(1,:) = rem(temp_b2(1,:) + [0,temp_b2(2,1:end-1)],2);
%b2 = zeros(1,K);
%b2(1:2:K-1) = temp_b2(1,:);
%b2(2:2:K) = temp_b2(2,:);

c1 = convenc(b1,g1);
%c2 = convenc(b2,g2);

%% c1 ͨ���ޣ��У������ŵ� -> c

%c = awgn(c1,3);
c = c1;

%% �������뺯����ȷ��
% b1_test = vitdec(c,g1,3,'trunc','hard');
% if any(b1==b1_test)
%     disp('������ȷ��')
% end


%% ���ܵ��ض��ź� c -> r
%startnum = randi([100,200],1);
startnum = 1;
endnum = randi([K-100,K],1);

r = c(startnum:endnum);

%% ���ɽضϾ��� r -> R
%MaxN = 60; % ���Ե�n�����ֵ
maxN = floor(sqrt(size(r,2))); % ��������������û������
gammaOpt = 0.6; % �����о�����
Z_l = zeros(1, maxN); % 
for l = 2:maxN  %l��ʾ��ǰ����
%iter = 5;
    L = floor(size(r, 2) / l); % L��ʾ��ǰ����
    R = reshape(r(1: l * L), l, L)'; % ��ǰ�ضϾ���
    decision = (L - l) * gammaOpt / 2; % �о�����


%% ������������к���
%Iteration
%     permutation = randi(L, [1, l]);
%     R(1:l, :) = R(permutation, :);

%% ʵ��һ��������ͨ�����б任��R��Ϊ�����Ǿ�������б任����������Ǿ���
    [G, ~] = LT_transfer(R); % �ֽ�
    N_l = sum(G, 1); % ÿһ�е�1�ĸ�������ĳһ��1�ĸ���С������ʱ����Ϊ��һ���������е��������
    Z_l(l) = nnz(find(N_l < decision));  % Number of nonzero matrix elements��Ҳ���ǣ�����Ϊlʱ���ж��ٸ�������ϵ���


end

%% �ҵ�n 
pp = find(Z_l>0); % �ҵ����е���������ص�l����˵��l��ʱΪn�ı���
nEstimate = pp(2)-pp(1); % ��ֵ���ǹ��Ƶ�n

%% �ҵ�na �Լ� H
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

%% ȷ��k �� v 
kv = zeros(2,(nEstimate^2 - nEstimate)/2);
iter = 1;
for iterk = 1:nEstimate - 1
    for iterZ = 1:nEstimate - iterk
        kv(1,iter) = iterk;
        kv(2,iter) = nAlphaEstimate * (1 - iterk/double(nEstimate)) - iterZ;
        iter = iter + 1;
    end
end


%% �ҵ���ż������ɾ���
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

%% �ع�У�����Ķ���ʽ��ʽHD
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
%% �ع����ɾ���G��ϵͳ��ʽGD_sys
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

%% ���ò������ӷֽ�õ����ɾ���g1�ĵ�Ч����������Gbase


%% �õ����ɾ���g1�ĵ�Ч��С��������Gmin


%% ����ͬ��ͷ�Լ�Gminʶ�����ɾ���g1
% ����Gmin,��������r��ͬ��ͷs
% ������ȱ任����T

% ��ʱû�а취��Gminת��Ϊg1t����ʱ�����ֶ����뷽ʽ
b1t = vitdec(r(1:end-rem(length(r),3)),g1t,3,'trunc','hard');
v = [2,3];
% ͬ��ͷ����
sNum = 30;
% ����һ�µõ�˳��
x = reshape(b1(1:sNum-rem(sNum,k)),k,[]);
disp('x = ') 
disp(x);
xt = reshape(b1t(1:numel(x)),size(x));
disp('xt = ')
disp(xt);

T = Identify_T(x,xt,v);






