function Hd = spikefilter
%SPIKEFILTER Returns a discrete-time filter object.

% MATLAB Code
% Generated by MATLAB(R) 9.3 and Signal Processing Toolbox 7.5.
% Generated on: 10-Oct-2019 17:31:19

% Butterworth Bandpass filter designed using FDESIGN.BANDPASS.

% All frequency values are in Hz.
Fs = 20000;  % Sampling Frequency

Fstop1 = 100;         % First Stopband Frequency
Fpass1 = 150;         % First Passband Frequency
Fpass2 = 1000;        % Second Passband Frequency
Fstop2 = 1200;        % Second Stopband Frequency
Astop1 = 60;          % First Stopband Attenuation (dB)
Apass  = 1;           % Passband Ripple (dB)
Astop2 = 80;          % Second Stopband Attenuation (dB)
match  = 'stopband';  % Band to match exactly

% Construct an FDESIGN object and call its BUTTER method.
h  = fdesign.bandpass(Fstop1, Fpass1, Fpass2, Fstop2, Astop1, Apass, ...
                      Astop2, Fs);
Hd = design(h, 'butter', 'MatchExactly', match);

% [EOF]
