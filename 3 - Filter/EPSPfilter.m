function Hd = EPSPfilter
%EPSPFILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and Signal Processing Toolbox 7.5.
% Generated on: 15-Apr-2018 17:40:35

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in Hz.
Fs = 10000;  % Sampling Frequency

Fpass = 0;               % Passband Frequency
Fstop = 1000;            % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.0001;          % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);

% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
Hd = dfilt.dffir(b);

% [EOF]
