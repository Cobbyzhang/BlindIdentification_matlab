clc
clear

%% 创建测试数据
a = round(rand(randi([2,8],1),randi([2,20],1)));
b = randi([0,16],1);
disp(a)
disp(b)
totality = 1000;


%% 测试两种算法的速度

% Elapsed time is 0.003853 seconds.
tic
for iter = 1:totality
    c = fWeightingBasic(a,b);
end
toc


% Elapsed time is 0.008030 seconds.
tic
for iter = 1:totality
    c = fWeightingBasic_2(a,b);
end
toc