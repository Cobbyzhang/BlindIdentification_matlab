clear
clc 
testNumber = 1000000;
tic

for iter = 1:testNumber
    a = randi(100000);
    b = randi(100000);
    c = xor(a,b);
end

toc


tic

for iter = 1:testNumber
    a = randi(100000);
    b = randi(100000);
    c = a+b;
end

toc