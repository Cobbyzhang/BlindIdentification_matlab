function [ gamma ] = optimal_gamma( p, m)
%OPTIMAL_THRESHOLD 
if p < 0.01
    p = 0.01;
end
a = -m * (1 - 2 * p)^2;
b = -2 * m * p * (1 - 2 * p);
c = 4 * m * p * (1 - 2 * p) - 2 * p * (1 - p) * log(4 * p * (1 - p));
gamma = (-b - sqrt(b^2 - a * c)) / a;

end

