function Hd = HIghPass500_1kFs
%HIGHPASS500_1KFS Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and Signal Processing Toolbox 7.5.
% Generated on: 06-May-2019 12:08:05

% Equiripple Highpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 1017.3;  % Sampling Frequency

Fstop = 500;             % Stopband Frequency
Fpass = 505;             % Passband Frequency
Dstop = 0.0001;          % Stopband Attenuation
Dpass = 0.057501127785;  % Passband Ripple
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fstop, Fpass]/(Fs/2), [0 1], [Dstop, Dpass]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]