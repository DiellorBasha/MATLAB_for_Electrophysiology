k=2;
s(k).Gamma.cleanup.name     = 'Bandpassed signal (30-100 Hz)';
s(k).Gamma.cleanup.filtered   =  filtfilt (gamfil.Numerator,1,s(k).Gamma.cleanup.signal);
s(k).Gamma.cleanup.squared    = (s(k).Gamma.cleanup.filtered).^2; 
[s(k).Gamma.cleanup.hi,...
s(k).Gamma.cleanup.lo]        = envelope(s(k).Gamma.cleanup.squared,1200, 'rms');
s(k).Gamma.cleanup.envelope   = s(k).Gamma.cleanup.hi-s(k).Gamma.cleanup.lo;
 
threshold                   = mean (s(k).Gamma.cleanup.envelope)+std(s(k).Gamma.cleanup.envelope);
[s(k).Gamma.cleanup.pks ,...
s(k).Gamma.cleanup.locs]      = findpeaks(s(k).Gamma.cleanup.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold ); 
 
s(k).Gamma.cleanup.logical    = zeros(length(s(k).Gamma.cleanup.envelope),1);
s(k).Gamma.cleanup.logical((s(k).Gamma.cleanup.envelope>threshold)) = 1;
s(k).Gamma.cleanup.derivative = diff(s(k).Gamma.cleanup.logical);
s(k).Gamma.cleanup.derivative = [s(k).Gamma.cleanup.derivative; s(k).Gamma.cleanup.derivative(1)];

s(k).Gamma.cleanup.ON         = find (s(k).Gamma.cleanup.derivative==1);
s(k).Gamma.cleanup.ON (:,2)   = s(k).Gamma.cleanup.ON/Fs;

s(k).Gamma.cleanup.OFF        = find (s(k).Gamma.cleanup.derivative==-1); 
s(k).Gamma.cleanup.OFF (:,2)  = s(k).Gamma.cleanup.OFF/Fs;