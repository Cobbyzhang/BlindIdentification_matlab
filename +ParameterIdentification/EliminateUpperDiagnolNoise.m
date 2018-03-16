function [R] = EliminateUpperDiagnolNoise(R, R_noiseless)

n = min(size(R));
for iter = 1 : n
    R(iter,iter:end) = R_noiseless(iter,iter:end);
end

end

