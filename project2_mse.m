clc;
clear;
close;
load spydata;
load training;

figure(1)
image(cPic);
axis square

mse = zeros(16,1) - 1;
i = 1;

% IT STARTS FROM HERE
for N = 7:12
L = 32; % number of samples
d = training'; % desired signal
x = received(1:32); % input signal
x = x';
%N = 9;  % filter length
p = zeros(N, 1); % cross-correlation vector
R = zeros(N, N); % autocorrelation matrix

for n = N:L
    xx = x(n:-1:n-N+1).'; % input vector
    p = p + xx * d(n);
    R = R + xx * xx.';
end
p = p / L;
R = R / L;
w = R \ p;

eq_key = conv(received, w);
dec_key = sign(eq_key);

dec_key=dec_key(1:14452);
depic=decoder(dec_key, cPic);

%MSE
% eq_key = eq_key(1:14452);
% D = abs(eq_key - received).^2;
% mse(N) = sum(D)/numel(eq_key);
mse(N) = sum((training - eq_key(1:32)).^2)/numel(training);


subplot(2, 3, i)
image(depic)
title(append('N=',num2str(N),' MSE=',num2str(mse(N))))

%hold on
axis square

i = i + 1;

end



