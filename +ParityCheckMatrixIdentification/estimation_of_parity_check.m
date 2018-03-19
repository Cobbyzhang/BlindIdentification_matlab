function [ parityCheckMatrix ] = estimation_of_parity_check(r, n, k, u, rowNumber, gammaOpt)
%


if nargin < 6
    rowNumber = 1000;
end
%%
R = Tool.reshapeMatrixWithColumn(r, n);
Base = R(:, 1 : k);
Ex = R(:,k + 1 : end);
parityCheckMatrix = zeros(n -k, n);
n_alpha = floor((u / (n - k) + 1)) * n;
iteration = 50;
%%

for iters = 1 : n - k
    R_temp = [Base,Ex(:, iters)]';
    for iterl = (k + 1) * (u + 1) : n_alpha + n
        RR = Tool.reshapeMatrixWithColumn(R_temp, iterl);
        L = min(size(RR, 1), rowNumber);
        RR(L + 1 : end, :) = [];
        decision = (L - iterl) * gammaOpt / 2;
        h = 0;
        for iterh = 1 : iteration
            if h
                break
            end
                        
            permutation = randi(L, [1, iterl]);
            R_t = RR(1:iterl, :);
            RR(1:iterl, :) = RR(permutation, :);
            RR(permutation, :) = R_t;

            [~, B] =  MatrixTransfer.LT_transfer(RR(1:iterl, :)); 
            G = mod(RR * B, 2);
            N_l = sum(G(iterl + 1 : end, :), 1);
            

            for iteri = 1 : iterl
                if N_l(iteri) < decision
                    h = B(:, iteri)';
                    % ����1 ����h��deg ����k+1��ֳ�k+1�����������deg
                    [h, deg] = ParityCheckMatrixIdentification.my_degree(h, k + 1);
                    if  deg == u + 1
                        % ����2 ��ֳ�k+1��poly���� (���У�binVec2poly)
                        h = TypeConversion.binVec2poly(fliplr(reshape(h, k + 1, [])));
                        % ������ ��parityCheckMatrix ����ʽд��
                        parityCheckMatrix(iters, 1 : k) = h(1:  k);
                        parityCheckMatrix(iters, k + iters) = h(k + 1); 
                    end
                end
            end
        end
    end
end


if any(sum(parityCheckMatrix, 2)==0)
    parityCheckMatrix = -1 * ones(n - k, n);
end


end

