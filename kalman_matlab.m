clear all
close all

n_iter = 50;

stdev = 0.1;
z = 0.125 + stdev*randn(n_iter, 1);
for i=1:n_iter
	z(i) = z(i) + 0.025 * i;
end

del_t = .01; % Time
q_f = 0.05;   % Process error
r = 0.1;     % measurement error
% Variances
p_l = 1.5;
p_lf = 0.0;
p_f = 1.5;

x_hat = zeros(2, 1, n_iter);
P = zeros(2, 2, n_iter);
K = zeros(2, 2, n_iter);
x_hat(:, :, 1) = [1; 0];
P(:, :, 1) = [p_l p_lf; p_lf p_f];
K(:, :, 1) = [1 0; 0 1];

F = [1 del_t; 0 1];
H = [1 0; 0 0];
Q = [del_t^3*q_f/3, del_t^2*q_f/2; del_t^2*q_f/2, del_t*q_f ];
R = [r 0; 0 r];

for t=2:n_iter
	x_hat_interim = F * x_hat(:, :, t-1);
	P_interim = F * P(:, :, t-1) * F' + Q;

	K(:, :, t) = P_interim * H' * inv(H * P_interim * H' + R);
	x_hat(:, :, t) = x_hat_interim + K(:, :, t) * (z(t) - H * x_hat_interim);
	P(:, :, t) = (eye(2) - K(:, :, t) * H) * P_interim;
end

x_positions = reshape(x_hat(1, 1, :), n_iter, 1);
velocities = reshape(x_hat(2, 1, :), n_iter, 1);
plot(x_positions);
hold all
plot(z);
pause;
plot(velocities)
% converges to 0.025 / .01 = 2.5
