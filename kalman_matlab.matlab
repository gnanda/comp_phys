clear all
close all

n_iter = 50;

stdev = 0.1;
random_values = 0.125 + randn(n_iter, 1, 'double');
for i=1:n_iter
	random_values(i) += 0.25 * i;
end

del_t = 1.0; % Time
q_f = 0.05;   % Process error
r = 0.1;     % measurement error
% Variances
p_l = 1.5;
p_lf = 0.0;
p_f = 1.5;

xhat = zeros(n_iter, 2, 1)
