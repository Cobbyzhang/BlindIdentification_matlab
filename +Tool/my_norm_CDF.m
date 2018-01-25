function [ val ] = my_norm_CDF(a)
%
format long;
p = 0.2316419; 
b1 = 0.31938153; 
b2 = -0.356563782; 
b3 = 1.781477937; 
b4 = -1.821255978; 
b5 = 1.330274429; 
x = abs(a); 
t = 1/(1+p*x); 
val = 1 - (1/(sqrt(2*pi))  * exp(-1*a^2/2)) * (b1*t + b2 * t^2 + b3*t^3 + b4 * t^4 + b5 * t^5 ); 
if a<0
    val = 1-val;
end

end

