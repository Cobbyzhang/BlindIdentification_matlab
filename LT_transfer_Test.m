% 测试文件，测试各种函数的正确性
% 测试LT_transfer 函数是否正常完成功能

testTimes = 10;
maxDemention = 1000;
h = waitbar(0,'Please wait...');
%h = waitbar(0,'Please wait...','CreateCancelBtn','delete(gcbf)');
%hBtn = findall(h, 'type', 'uicontrol');
%set(hBtn, 'string', '取消', 'FontSize', 10);
for iter1 = 1:testTimes
    l = randi([3,maxDemention],1);
    L = l + randi([1,maxDemention],1);
    R = rand(L,l)>0.5;
    [G,B] = LT_transfer(R);
    if any(mod(R*B-G,2))
        disp('Wrong!分解错误')
        break
    end
    for iter2 = 1:l
        for iter3 = iter2+1:l
            if G(iter2,iter3)
                disp('Wrong! G不为下三角')
                break
            end
        end
    end
    waitbar(iter1/testTimes,h);
end
delete(h);
clear h;