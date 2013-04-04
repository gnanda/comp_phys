clear all
close all

n_iter = 50;

stdev = 0.1;
z = 0.125 .+ randn(n_iter, 1, 'double');
for i=1:n_iter
	z(i) += 0.25 * i;
end

del_t = 1.0; % Time
q_f = 0.05;   % Process error
r = 0.1;     % measurement error
% Variances
p_l = 1.5;
p_lf = 0.0;
p_f = 1.5;

x_hat = zeros(n_iter, 2, 1);
P = zeros(n_iter, 2, 2);
K = zeros(n_iter, 2, 2);
x_hat(1, :, :) = [1; 0];
P(1, :, :) = [p_l p_lf; p_lf p_f];
K(1, :, :) = [1 0; 0 1];

F = [1 del_t; 0 1];
H = [1 0];
Q = [del_t^3*q_f/3, del_t^2*q_f/2; del_t^2*q_f/2, del_t*q_f ];
R = [r 0; 0 r];

for t=2:n_iter
	x_hat_interim = F * x_hat(t-1, :, :);
	P_interim = F * P(t-1, :, :) * F' + Q;

	K(t, :, :) = P_interim * H' * inv(H * P_interim * H' + R);
	x_hat(t, :, :) = x_hat_interim + K(t, :, :) * (z(t) - H * x_hat_interim);
	P(t, :, :) = (eye(2) - K(t, :, :) * H) * P_interim;
end

