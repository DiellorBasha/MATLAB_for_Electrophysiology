dsFactor = 20;
for k=1:6
s(k).downsample.signal  = downsample (s(k).signals, 20);
end
s(1).downsample.Fs      = Fs/dsFactor;
disp('Downsampling...')
  for k=2:3
s(k).downsample.name     = 'Bandpassed signal (100-300 Hz)';
s(k).downsample.filtered   = filtfilt (ripfilter1k.Numerator,1,s(k).downsample.signal);
s(k).downsample.squared    = (s(k).downsample.filtered).^2; 
 
[s(k).downsample.hi,...
s(k).downsample.lo]        = envelope(s(k).downsample.squared,60, 'rms');
s(k).downsample.envelope   = s(k).downsample.hi-s(k).downsample.lo;
 
threshold                    = mean (s(k).downsample.envelope)+10*std(s(k).downsample.envelope)/4;

[s(k).downsample.pks ,...
s(k).downsample.locs]      = findpeaks(s(k).downsample.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold ); 

s(k).downsample.logical    = zeros(length(s(k).downsample.envelope),1);
s(k).downsample.logical((s(k).downsample.envelope>threshold)) = 1;
s(k).downsample.derivative = diff(s(k).downsample.logical);
s(k).downsample.artefact.ON         = find (s(k).downsample.derivative==1);
s(k).downsample.artefact.ON (:,2)   = s(k).downsample.artefact.ON/s(1).downsample.Fs;
s(k).downsample.artefact.OFF        = find (s(k).downsample.derivative==-1);
s(k).downsample.artefact.OFF (:,2)  = s(k).downsample.artefact.OFF/s(1).downsample.Fs;

  end
  
  time1k = [1:length(s(1).downsample.signal)].';
 clear j k
 
  
  s(3).downsample.artefact.remove = {};
for k = 1: size (s(3).downsample.artefact.OFF,1)
s(3).downsample.artefact.remove {k,1}...
    =linspace (s(3).downsample.signal (s(3).downsample.artefact.ON (k,1)),...
    s(3).downsample.signal (s(3).downsample.artefact.OFF (k,1)),...
        s(3).downsample.artefact.OFF (k,1)-s(3).downsample.artefact.ON (k,1));
end

for k = 1:size (s(3).downsample.artefact.remove,1)
s(3).downsample.signal(s(3).downsample.artefact.ON (k,1):(s(3).downsample.artefact.OFF (k,1)-1))...
    = s(3).downsample.artefact.remove{k,1}; 
end
 
  PlotDetectedArtefactsDownsample