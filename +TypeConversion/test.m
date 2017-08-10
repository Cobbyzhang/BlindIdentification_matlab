clear 
clc


testNumber = 10000;
maxNum = 100000;
%% test binVec2dec

tic
for iter = 1:testNumber
    a = round(rand(1,18));
    b = bin2dec(num2str(a)) ;
end
toc
% Elapsed time is 1.559061 seconds.

tic 
for iter = 1:testNumber
    a = round(rand(1,18));
    b = TypeConversion.binVec2dec(a);
end
toc
% Elapsed time is 0.450357 seconds.

%% test dec2binVec

% tic 
% for iter = 1:testNumber
%     a = randi(maxNum);
%     b = TypeConversion.dec2binVec(a);
% end
% toc
% Elapsed time is 0.504749 seconds.