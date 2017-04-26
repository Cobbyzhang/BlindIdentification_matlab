function [ g,c,d ] = mygcd( a,b )
%自编的最大公约数函数
% Do scalar expansion if necessary
a = a(1);
b = b(1);
if a*b==0||(a~= 1 && b~=1 )
    [ g,c,d ] = gcd( a,b );
    return
elseif a == 1
    g = b;
    c = b + 1;
    d = 1;
elseif b == 1
    g = a;
    c = 1;
    d = c - 1;
else
    
end






end

