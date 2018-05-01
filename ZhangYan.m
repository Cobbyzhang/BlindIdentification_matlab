clc
clear

%% parameters set of variables 
phi_min = 0.01;
phi_max = 0.5;
m_min = 0;
t_min =0;
t_max = 1;
a_min = 0.01;
a_max = 1;
K_min = 0;
K_max = 1;
interval = 0.1;

%% Results file
if ~exist('Results.txt', 'file')
    delete('Results.txt');
end
f = fopen('Results.txt', 'wt');
if f<0
    error('Do you have write permissions for %s?', pwd);
end




%% function

fprintf(f, '   phi\t\tt\tm\t\ta\t   K\t   S*\t   pai\n');
disp('phi    t     m     a    K     S')
for phi = phi_min : interval : phi_max
    for t = t_min : interval : t_max
        for m = m_min : interval : t/2
            for a = a_min : interval : a_max
                for K = K_min : interval : K_max
                    b1 = 4 * (1 - phi);
                    b2 = -(1 - phi) * a * phi;
                    b3 = 0;
                    b4 = -a * m * phi * (m * phi + 2 * phi * t - 2 * t);
                    S = roots([b1, b2, b3, b4]);
                    for iter = 1:numel(S)
                        SS = S(iter);
                        if imag(SS) == 0 && SS > 0 && SS < 1
                            pai = -3 * SS^2 / a + phi * SS + 2 * K;
                            fprintf(f, '%f | %f | %f | %f | %f | %f | %f\n', phi, t, m, a, K, SS, pai);
                        end
                    end 
                end
            end
        end
    end
end
fclose(f);