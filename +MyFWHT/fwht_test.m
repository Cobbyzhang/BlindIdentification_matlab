clear
clc

testNumber = 25;
maxNum = 20;

%% 测试fwht的输入输出及计算结果

% a = [1 1 1 0];
% Y = fwht(a,4,'hadamard');
% disp (Y)
% disp(hadamard(16))

%% 测试最多能算到多少位
% test_n = 2^2;
% tic
% for iter=1:1
%     a = round(rand(1,test_n));
%     Y = ifwht(a,test_n);
% end
% toc

%% 测试hadamard矩阵最多能计算时间
% for iter = 2.^(1:12)
%     tic
%     hadamard(iter);
%     toc
% end
% Elapsed time is 0.000120 seconds.
% Elapsed time is 0.000031 seconds.
% Elapsed time is 0.000028 seconds.
% Elapsed time is 0.000034 seconds.
% Elapsed time is 0.000040 seconds.
% Elapsed time is 0.000054 seconds.
% Elapsed time is 0.000102 seconds.
% Elapsed time is 0.000510 seconds.
% Elapsed time is 0.002776 seconds.
% Elapsed time is 0.010839 seconds.
% Elapsed time is 0.040813 seconds.
% Elapsed time is 0.160084 seconds.

%% 测试hadamard矩阵与向量乘积计算的时间

% for iter = 2.^(1:testNumber)
%     a = round(rand(1,iter));
%     tic
%     b = a*hadamard(iter);
%     toc
% end
% Elapsed time is 0.000125 seconds.
% Elapsed time is 0.000065 seconds.
% Elapsed time is 0.000057 seconds.
% Elapsed time is 0.000064 seconds.
% Elapsed time is 0.000072 seconds.
% Elapsed time is 0.000178 seconds.
% Elapsed time is 0.000317 seconds.
% Elapsed time is 0.000537 seconds.
% Elapsed time is 0.004329 seconds.
% Elapsed time is 0.016927 seconds.
% Elapsed time is 0.052987 seconds.
% Elapsed time is 0.188712 seconds.

%% 测试mywht计算时间

% for iter = 2.^(1:testNumber)
%     a = round(rand(1,iter));
%     tic
%     b = MyFWHT.mywht(a);
%     toc
% end

%% 测试大规模矩阵reshape时间
% 
% matrixSize = 1024;
% a = round(rand(1024));
% tic
% for iter = 1:maxNum % maxNum = 20
%     a = reshape(a,[],2^iter);
% end
% toc
% % Elapsed time is 0.000105 seconds.



%% 测试myfwht是否正常工作
% y = MyFWHT.myfwht([0 1 0 0]);
% disp(y)
% 
% tic
% for itert = 1:testNumber
%     s = 2^itert;
%     for iterm = 1:maxNum
%         a = round(rand(1,s));
%         Y1 = a * hadamard(s);
%         Y2 = MyFWHT.myfwht(a);
%         if ~isequal(Y1,Y2)
%             error('something wrong')
%         end
% %         if Y1~=Y2
% %             error('something wrong')
% %         end
%     end
% end
% toc

%% 测试myfwht速度

% for iter = 2.^(1:testNumber) % testNumebr = 25
%     a = round(rand(1,iter));
%     tic
%     b = MyFWHT.myfwht(a);
%     toc
% end

% Elapsed time is 0.000591 seconds.
% Elapsed time is 0.000085 seconds.
% Elapsed time is 0.000075 seconds.
% Elapsed time is 0.000076 seconds.
% Elapsed time is 0.000081 seconds.
% Elapsed time is 0.000103 seconds.
% Elapsed time is 0.000108 seconds.
% Elapsed time is 0.000133 seconds.
% Elapsed time is 0.000185 seconds.
% Elapsed time is 0.000168 seconds.
% Elapsed time is 0.000351 seconds.
% Elapsed time is 0.001069 seconds.
% Elapsed time is 0.001183 seconds.
% Elapsed time is 0.003248 seconds.
% Elapsed time is 0.003865 seconds.
% Elapsed time is 0.007075 seconds.
% Elapsed time is 0.023876 seconds.
% Elapsed time is 0.088370 seconds.
% Elapsed time is 0.207275 seconds.
% Elapsed time is 0.453010 seconds.
% Elapsed time is 0.924567 seconds.
% Elapsed time is 1.945144 seconds.
% Elapsed time is 3.956561 seconds.
% Elapsed time is 8.193506 seconds.
% Elapsed time is 15.100931 seconds.















