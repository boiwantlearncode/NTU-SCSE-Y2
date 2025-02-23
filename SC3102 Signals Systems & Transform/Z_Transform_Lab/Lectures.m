close all
syms n a f F z
f = a^n;
F=ztrans(f);
'f= ', pretty(f)
'F= ', pretty(F)

%========Residuez for Z partial fraction=================
Num = [1 0 1]
Den = [1 2]
[r,p,k] = residuez(Num,Den)
%r and p gives fraction, k gives non-fraction
%(1.25)/1+2z^-1  + (-0.25) + (0.5)
%   r    p           k1       k2
%use 'help residuez' for format


%==============
given = (1/z-0.95)*(z*(z-cos(0.03*pi))/(z^2-2*cos(0.03*pi)*z+1))
pretty(given);  %cant see clearly but nvm

num = conv([1], [1 -cos(0.03*pi) 0]);
den = conv([1 -0.95], [1 -2*cos(0.03*pi) 1]);

% Given z is in positive power hence we use residue to find pfe
[r, p, k] = residue(num, den);

n = 0:100; % Assuming 'n' is your x-axis data

% Calculate the real and imaginary parts separately
y5s_real = 2 * abs(r(1)) * cos((angle(p(1)) * n) + angle(r(1)));
y5s_imag = 2 * abs(r(1)) * sin((angle(p(1)) * n) + angle(r(1)));

y5t = r(3) * (real(p(3)).^n); %transient
y5 = y5s_real + y5t;

figure;
plot(n, y5s_real, 'b-'); hold on;
plot(n, y5t, 'g-');
plot(n, y5, 'r-');
stem(n, y5, 'gx')

xlabel('n');
ylabel('Amplitude');
title('Plot of y5s, y5t, and y5');
legend('y5s', 'y5t', 'y5', 'Location', 'NorthEast');
grid on;
%==================================================
%================!!!!!!!!!!!!===================
% Define the coefficients of the numerator and denominator for H(z)
numerator_H = [1 0.8];
denominator_H = [1 -0.9];

% Create a transfer function object for H(z)
H = tf(numerator_H, denominator_H, 1, 'Variable', 'z');

% Define the coefficients of the numerator and denominator for X(z)
numerator_X = [1];
denominator_X = [1 -1];

% Create a transfer function object for X(z)
X = tf(numerator_X, denominator_X, 1, 'Variable', 'z');

% Calculate the overall transfer function Y(z) by multiplying H(z) and X(z)
Y = H * X

[r,p,k] = residuez(conv(numerator_H,numerator_X),conv(denominator_H,denominator_X))
%========== straightforward code to obtain close form
H_z = (z + 0.8) / (z - 0.9);  % Define H(z)
X_z = z / (z - 1)  % Define X(z)

Y_z = H_z *X_z
y_n = iztrans(Y_z)


%=========pyp q3===============
syms y(t) x(t)
dy =diff(y)
d2y = diff(dy)
dx = diff(x)
ode = d2y +3*dy +2*y(t) == 2*dx + x(t)
pretty(ode)
x_input = heaviside(t) + cos(t)*heaviside(t) +sin(2*t - pi/3)
X_s = ztrans(x_input)
%transfer function (Doesnt work with multiplication but can use to check)
Num_y = [1 3 2]
Den_y = [2 1]
G = tf(Den_y, Num_y);
%----


%====== (not working)
syms y(t) x(t) t
dy = diff(y);
d2y = diff(dy);
dx = diff(x);
ode = d2y + 3*dy + 2*y == 2*dx + x
x_input = heaviside(t) + cos(t) * heaviside(t) + sin(2*t - pi/3);

% Initial conditions
y0 = 1;
dy0 = -1;

% Solve the differential equation
ySol = dsolve(ode, [y(0) == y0, dy(0) == dy0])

% Assume steady-state response
y_steady_state = subs(ySol, t, Inf)

%============
h_n = iztrans((z+0.5)/(z-1/3))

%===========
B = [1 1]
A = [1 -1/3]
x1 = [ 1 1 1 1 1 1 1 1 1 1 1 1 1 1]
y1 = filter(B,A,x1)
n=[0:length(y1)-1]
figure
stem(n ,x1)
hold on
stem(n, y1)