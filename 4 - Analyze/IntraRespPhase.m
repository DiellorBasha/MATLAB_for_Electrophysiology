myFolder = 'C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\6 - Data\Intra2'



filePattern = fullfile(myFolder, '*.smr'); % Change to whatever pattern you need.
theFiles = dir(filePattern);


sh = find(strcmp({theFiles.name}, '57.smr')==1)

fn = fullfile(theFiles(sh).folder, theFiles(sh).name);

CheckFilters; d=getspike2 (fn, 'all'); %import data from Spike2
    Fs=d(1).Fs;
    time = [1:length(d(1).wv)].';

    clear idx
     idx(:,1) = find([d.ch] == 10);
    idx(:,2) = find([d.ch] == 12);
    s(10).channel = d(idx(:,1)).title;
    s(12).channel = d(idx(:,2)).title;
    s(10).signals = d(idx(:,1)).wv;
    s(12).signals = d(idx(:,2)).wv; 
    for k=1:7   
s(k).channel = d(k).title;
s(k).signals  =d(k).wv;
    end
  
  
  %% 
  % Filter for EPSP and spikes
  disp ('Correcting Vm to spike threshold...')
s(5).EPSP.filtered    = filtfilt (EPSPfil.Numerator,1, s(5).signals);
s(5).EPSP.derivative  = diff(s(5).EPSP.filtered);
s(5).EPSP.derivative  = [s(5).EPSP.derivative; s(5).EPSP.derivative(1)];
threshold_spike       = mean (s(5).EPSP.derivative) + 12*std (s(5).EPSP.derivative);
findpeaks(s(5).EPSP.derivative,'MinPeakDistance',100, 'MinPeakHeight', threshold_spike); %find spike peaks

[s(5).EPSP.spike_pks,s(5).EPSP.spike_locs,...
s(5).EPSP.spike_widths, s(5).EPSP.spike_proms]...
                            = findpeaks(s(5).EPSP.derivative,'MinPeakDistance',100, 'MinPeakHeight', threshold_spike); %find spike peaks
s(5).EPSP.spike_locs (:,2) = s(5).EPSP.spike_locs/Fs;                   
s(5).EPSP.spike_threshold_locs = s(5).EPSP.spike_locs (:,1) - round (s(5).EPSP.spike_widths);
s(5).EPSP.spike_threshold_vals = s(5).signals (s(5).EPSP.spike_threshold_locs);
s(5).EPSP.correction_val       = -57-mean(s(5).EPSP.spike_threshold_vals);
s(5).signals                   = s(5).signals + s(5).EPSP.correction_val;
for k = 1:length (s(5).EPSP.spike_locs)
    idx  = find(time == s(5).EPSP.spike_locs(k,1)); %peak of gamma
 if idx>500 & idx<length(time)-500
   s(5).EPSP.spikewaves(1:1001,k) = s(5).signals(idx-500:idx+500);
 end
end
disp ('Done.')
%% 
clf
disp('Filtering for spike/EPSP...') 
  threshold                   = mean (s(5).EPSP.derivative) + (std (s(5).EPSP.derivative))/2; 
  
  findpeaks (s(5).EPSP.derivative,...
                              'MinPeakDistance', 50, 'MinPeakHeight', threshold)
                          xlim([2000 200000])
                          ylim([-0.08 0.2])
          hold on 
          plot (s(5).signals/250+0.1)
          
          
  [x,threshold]=ginput
         clf
   findpeaks (s(5).EPSP.derivative,...
                              'MinPeakDistance', 50, 'MinPeakHeight', threshold)     
                         %%                       
[s(5).EPSP.pks,s(5).EPSP.locs,...
s(5).EPSP.widths, s(5).EPSP.proms]...
                            = findpeaks (s(5).EPSP.derivative,...
                              'MinPeakDistance', 50, 'MinPeakHeight', threshold); %find EPSP peaks
s(5).EPSP.EPSP_pks    = setdiff(s(5).EPSP.pks,s(5).EPSP.spike_pks(:,1)); % This returns the data in locs_EPSP that is not in locs_spike: i.e removes spike times
s(5).EPSP.EPSP_locs   = setdiff(s(5).EPSP.locs,s(5).EPSP.spike_locs(:,1));
s(5).EPSP.EPSP_locs (:,2) = s(5).EPSP.EPSP_locs/Fs;
s(5).EPSP.EPSP_widths = setdiff(s(5).EPSP.widths,s(5).EPSP.spike_widths(:,1));
s(5).EPSP.EPSP_proms  = setdiff(s(5).EPSP.proms,s(5).EPSP.spike_proms(:,1));
try
for k = 1:size (s(5).EPSP.spikewaves,2)
[s(5).EPSP.spike_pks1(k),s(5).EPSP.spike_locs1(k),...
s(5).EPSP.spike_widths1(k), s(5).EPSP.spike_proms1(k)]...
     = findpeaks(s(5).EPSP.spikewaves (450:600,k),'MinPeakDistance',100, 'MinPeakHeight', -40); %find spike peaks
end
s(5).EPSP.spike_locs1 =s(5).EPSP.spike_locs1+450;
for k = 1:length (s(5).EPSP.EPSP_locs)
    idx2 = find(time == s(5).EPSP.EPSP_locs(k,1));
 if idx2>500 & idx2<length(time)-500 
   s(5).EPSP.EPSPwaves(1:501,k)=s(5).signals (idx2-250:idx2+250);
 end
end
catch
end

try
s(5).EPSP.AHPcell ={};
for k = 1:size (s(5).EPSP.spikewaves,2)
    [s(5).EPSP.AHPcell{1,k}...
        s(5).EPSP.AHPcell{2,k}...
          s(5).EPSP.AHPcell{3,k}...
            s(5).EPSP.AHPcell{4,k}]...
            =findpeaks ((-s(5).EPSP.spikewaves (500:600,k)),...
               'MinPeakDistance', 90, ...
                   'MinPeakProminence', 0.5,...
                   'Npeaks', 1);
end
for k = 1:size (s(5).EPSP.spikewaves,2)
a(k)=isempty (s(5).EPSP.AHPcell{4,k});
end
b=find (a==0);
s(5).EPSP.AHP.prom = cell2mat (s(5).EPSP.AHPcell(4,b));
s(5).EPSP.AHP.width = cell2mat (s(5).EPSP.AHPcell(3,b));
s(5).EPSP.AHP.meanprom = mean (s(5).EPSP.AHP.prom);
s(5).EPSP.AHP.meanprom(2,:) = std (s(5).EPSP.AHP.prom);
s(5).EPSP.AHP.meanwidth = mean (s(5).EPSP.AHP.width);
s(5).EPSP.AHP.meanwidth(2,:) = std (s(5).EPSP.AHP.width);
catch
end
clear k idx idx2 threshold
disp('Done.')

  % Filter for gamma
 disp('Filtering for gamma...') 
    for k=1:3
s(k).Gamma.signal     = 'Bandpassed signal (30-100 Hz)';
s(k).Gamma.filtered   =  filtfilt (gamfil.Numerator,1,s(k).signals);
s(k).Gamma.squared    = (s(k).Gamma.filtered).^2; 
[s(k).Gamma.hi,...
s(k).Gamma.lo]        = envelope(s(k).Gamma.squared,1200, 'rms');
s(k).Gamma.envelope   = s(k).Gamma.hi-s(k).Gamma.lo;
 
threshold                   = mean (s(k).Gamma.envelope)+std(s(k).Gamma.envelope);
[s(k).Gamma.pks ,...
s(k).Gamma.locs]      = findpeaks(s(k).Gamma.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold ); 
 
s(k).Gamma.logical    = zeros(length(s(k).Gamma.envelope),1);
s(k).Gamma.logical((s(k).Gamma.envelope>threshold)) = 1;
s(k).Gamma.derivative = diff(s(k).Gamma.logical);
s(k).Gamma.derivative = [s(k).Gamma.derivative; s(k).Gamma.derivative(1)];

s(k).Gamma.ON         = find (s(k).Gamma.derivative==1);
s(k).Gamma.ON (:,2)   = s(k).Gamma.ON/Fs;

for j = 1:size(s(k).Gamma.ON, 1)
    idx=find(time==s(k).Gamma.ON(j,1));
 if idx>15000 && idx<length(time)-15000
    s(k).Gamma.ONtimes (1:30001,j) = time(idx-15000:idx+15000);
 end
end

s(k).Gamma.ONtimes=s(k).Gamma.ONtimes (:,find(sum(s(k).Gamma.ONtimes,1)));

s(k).Gamma.OFF        = find (s(k).Gamma.derivative==-1); 
s(k).Gamma.OFF (:,2)  = s(k).Gamma.OFF/Fs;

for j = 1:size(s(k).Gamma.OFF, 1)
    idx=find(time==s(k).Gamma.OFF(j,1));
 if idx>15000 && idx<length(time)-15000
    s(k).Gamma.OFFtimes (1:30001,j) = time(idx-15000:idx+15000);
 end
end

 s(k).Gamma.OFFtimes=s(k).Gamma.OFFtimes (:,find(sum(s(k).Gamma.OFFtimes,1)));

    end
s(2).Gamma.cleanup.signal = s(2).signals;
idx_before         = (s(5).EPSP.spike_locs (:,1))-5;
idx_after          = (s(5).EPSP.spike_locs (:,1))+ 60; 
s(2).Gamma.cleanup.remove = {};
for k = 1: size (s(5).EPSP.spike_locs (:,1),1)
s(2).Gamma.cleanup.remove {k,1}...
                   = linspace (s(2).Gamma.cleanup.signal (idx_before (k)),...
                        s(2).Gamma.cleanup.signal  (idx_after (k)),...
                            (idx_after(k)-idx_before(k)));
end
for k = 1:size (s(2).Gamma.cleanup.remove,1)
s(2).Gamma.cleanup.signal(idx_before(k):(idx_after(k))-1)...
                   = s(2).Gamma.cleanup.remove{k,1}; 
end
GammaCleanup ;clear j k  
 disp('Done.')
AnalyzingVmDistribution   
disp('Filtering for phase...')
  


% Filter for phase
for k=[10,12]
% s(k).Phase.lowpass       = filtfilt (lpfil.Numerator,1, s(k).signals);
s(k).Phase.lowpass       = s(k).signals;
s(k).Phase.hilbert       = hilbert (s(k).Phase.lowpass);
s(k).Phase.phase         = angle (s(k).Phase.hilbert);
s(k).Phase.magnitude     = abs   (s(k).Phase.hilbert);
[s(k).Phase.pks,...
    s(k).Phase.locs]     = findpeaks(s(k).Phase.phase,...
           	                'MinPeakHeight', 3,...
                             'MinPeakDistance', 0.5*Fs);
s(k).Phase.pk2pk         = diff(s(k).Phase.locs);
[s(k).Phase.pk2pk(:,2),...
   s(k).Phase.pk2pk(:,3)] = sort (s(k).Phase.pk2pk (:,1)); 
s(k).Phase.pks           = s(k).Phase.pks (1:end-1);
s(k).Phase.pks           = s(k).Phase.pks (s(k).Phase.pk2pk(:,3));
s(k).Phase.locs          = s(k).Phase.locs (1:end-1);
s(k).Phase.locs          = s(k).Phase.locs (s(k).Phase.pk2pk(:,3));

s(k).Phase.phasetimes    = zeros (2*round(mean(s(k).Phase.pk2pk(:,1))), length(s(k).Phase.locs));


  for j = 1:length(s(k).Phase.locs)
      idx = find(time==s(k).Phase.locs(j));
      
    if idx>mean(s(k).Phase.pk2pk) & idx<(length(time)-mean(s(k).Phase.pk2pk))

s(k).Phase.phasetimes((1:(2*round(mean(s(k).Phase.pk2pk(1,:)))+1)), j)= ...
    time(idx-round(mean(s(k).Phase.pk2pk (1,:))):idx+round(mean(s(k).Phase.pk2pk(1,:))));

    end
  end
  
  s(k).Phase.phasetimes = s(k).Phase.phasetimes (:, find(sum(s(k).Phase.phasetimes,1)));
end
clear j k
disp('Done.')

%Downsample
dsFactor = 20;
for k=1:7
s(k).downsample.signal  = downsample (s(k).signals, 40);
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
 
threshold                    = mean (s(k).downsample.envelope)+std(s(k).downsample.envelope);

[s(k).downsample.pks ,...
s(k).downsample.locs]      = findpeaks(s(k).downsample.envelope,'MinPeakDistance',0.3*s(1).downsample.Fs, 'MinPeakHeight', threshold ); 

s(k).downsample.logical    = zeros(length(s(k).downsample.envelope),1);
s(k).downsample.logical((s(k).downsample.envelope>threshold)) = 1;
s(k).downsample.derivative = diff(s(k).downsample.logical);
s(k).downsample.ON         = find (s(k).downsample.derivative==1);
s(k).downsample.ON (:,2)   = s(k).downsample.ON/s(1).downsample.Fs;
s(k).downsample.OFF        = find (s(k).downsample.derivative==-1);
s(k).downsample.OFF (:,2)  = s(k).downsample.OFF/s(1).downsample.Fs;

  end
  
  time1k = [1:length(s(1).downsample.signal)].';
 clear j k
 
  % Clean up ripples
 disp('Ripple cleanup...')
if size (s(3).downsample.ON, 1) > size (s(3).downsample.OFF, 1)
    s(3).downsample.ON= s(3).downsample.ON (1:end-1, :); 
end 
   s(3).downsample.ON_OFF = s(3).downsample.ON - s(3).downsample.OFF;
   s(3).downsample.ripples.all = {}; s(3).downsample.time = [1:length(s(3).downsample.signal)].';
   
 for k=1:size(s(3).downsample.ON, 1)
idxON  = find(s(3).downsample.time == s(3).downsample.ON(k, 1)); %peak of gamma
idxOFF = find(s(3).downsample.time == s(3).downsample.OFF (k, 1));
%if idx>500 & idx<length(time)-500
 s(3).downsample.ripples.all {1,k}          = idxON:idxOFF;
 s(3).downsample.ripples.all {2,k}          = s(3).downsample.signal   (s(3).downsample.ripples.all {1,k});
 s(3).downsample.ripples.all {3,k}          = s(3).downsample.filtered (s(3).downsample.ripples.all {1,k});
 [s(3).downsample.ripples.all{4,k},...
     s(3).downsample.ripples.all{5,k}]      = xcorr(s(3).downsample.ripples.all {3,k});
 [s(3).downsample.ripples.all{6,k},...
     s(3).downsample.ripples.all{7,k}]      = findpeaks (s(3).downsample.ripples.all{4,k},...
     'MinPeakHeight', max(s(3).downsample.ripples.all{4,k})/10,...
     'MinPeakProminence', max(s(3).downsample.ripples.all{4,k})/100);
 s(3).downsample.ripples.all{8,k}           = length(s(3).downsample.ripples.all{7,k})>3;
 s(3).downsample.ripples.all{9,k}           = mean (diff(s(3).downsample.ripples.all{7,k}))<1/80*(Fs/dsFactor); 
 end
j= find((cell2mat(s(3).downsample.ripples.all(8,:))) + cell2mat(s(3).downsample.ripples.all(9,:)) ==2);
j1= find (cell2mat(s(3).downsample.ripples.all(8,:))>=0); j1 = setdiff (j1, j);
s(3).downsample.ripples.included =  s(3).downsample.ripples.all (:,j);
s(3).downsample.ripples.rejected =  s(3).downsample.ripples.all (:,j1);
s(3).downsample.ONincluded =   s(3).downsample.ON (j,:); s(3).downsample.OFFincluded =   s(3).downsample.OFF (j,:); 
s(3).downsample.ONrejected =   s(3).downsample.ON (j1,:); s(3).downsample.OFFrejected =   s(3).downsample.OFF (j1,:);
s(3).downsample = rmfield (s(3).downsample, {'ON_OFF', 'ON', 'OFF'}); 
s(3).downsample.ON.included = s(3).downsample.ONincluded;  s(3).downsample.ON.rejected = s(3).downsample.ONrejected; 
s(3).downsample.OFF.included = s(3).downsample.OFFincluded;  s(3).downsample.OFF.rejected = s(3).downsample.OFFrejected; 
s(3).downsample = rmfield (s(3).downsample, {'ONincluded', 'OFFincluded', 'ONrejected', 'OFFrejected'}); 
s(3).downsample.ripples = rmfield (s(3).downsample.ripples, 'all'); 
clear idxON idxOFF k j j1
 
 for k = 1: size (s(3).downsample.ripples.included, 2)
     s(3).downsample.ripples.included {10, k}= (s(3).downsample.ripples.included {1,k})/(Fs/dsFactor);
 end

 disp('Done.')

s(3).downsample.ripples = s(3).downsample;
s(3).downsample.ripples.name = 'These data are 1000 Hz Fs';

 
s(5).EPSP.EPSP_phase.Respiration = s(10).Phase.phase(s(5).EPSP.EPSP_locs(:,1));
s(5).EPSP.EPSP_phase.SO = s(12).Phase.phase(s(5).EPSP.EPSP_locs(:,1));
s(5).EPSP.Spike_phase.Respiration = s(10).Phase.phase(s(5).EPSP.spike_locs(:,1));
s(5).EPSP.Spike_phase.SO = s(12).Phase.phase(s(5).EPSP.spike_locs(:,1));

s(3).downsample.ON.phase.respiration = s(10).Phase.phase(round(20*s(3).downsample.ON.included(:,1)));
s(3).downsample.ON.phase.SO = s(12).Phase.phase(round(20*s(3).downsample.ON.included(:,1)));

s(5).downsample.EPSP_locs = round(s(5).EPSP.EPSP_locs/20);

dsFactor = 40;

for k=1:length(s)
s(k).downsample.signal  = downsample (s(k).signals, dsFactor);
end
s(1).downsample.Fs      = Fs/dsFactor;
disp('Downsampling...')
  for k=[1:3] 
s(k).downsample.name     = 'Bandpassed signal (40-100 Hz)';
s(k).downsample.filtered   = filtfilt (gamfil500.Numerator,1,s(k).downsample.signal);
s(k).downsample.squared    = (s(k).downsample.filtered).^2; 
 
[s(k).downsample.hi,...
s(k).downsample.lo]        = envelope(s(k).downsample.squared,60, 'rms');
s(k).downsample.envelope   = s(k).downsample.hi-s(k).downsample.lo;
%  
% threshold                    = mean (s(k).downsample.envelope)+std(s(k).downsample.envelope);
% 
% [s(k).downsample.pks ,...
% s(k).downsample.locs]      = findpeaks(s(k).downsample.envelope,'MinPeakDistance',0.3*s(1).downsample.Fs, 'MinPeakHeight', threshold ); 
% % 
% % s(k).downsample.logical    = zeros(length(s(k).downsample.envelope),1);
% s(k).downsample.logical((s(k).downsample.envelope>threshold)) = 1;
% s(k).downsample.derivative = diff(s(k).downsample.logical);
% s(k).downsample.ON         = find (s(k).downsample.derivative==1);
% s(k).downsample.ON (:,2)   = s(k).downsample.ON/s(1).downsample.Fs;
% s(k).downsample.OFF        = find (s(k).downsample.derivative==-1);
% s(k).downsample.OFF (:,2)  = s(k).downsample.OFF/s(1).downsample.Fs;
  end
  % Get gamma magnitude
  for k=[1:3]
s(k).downsample.Gamma.hilbert      = hilbert (s(k).downsample.filtered);
s(k).downsample.Gamma.phase         = angle (s(k).downsample.Gamma.hilbert );
s(k).downsample.Gamma.magnitude     = abs   (s(k).downsample.Gamma.hilbert );
  end
  
  % Get Intra magnitude
  for k = 5
s(k).downsample.detrend      = detrend(s(k).downsample.signal);  
s(k).downsample.normalized   = normalize(s(k).downsample.detrend);
s(k).downsample.hilbert      = hilbert (s(k).downsample.normalized);
s(k).downsample.phase         = angle (s(k).downsample.hilbert);
s(k).downsample.magnitude     = abs   (s(k).downsample.hilbert);
  end
  % Get resp and SO phase
  for k = [10,12]
s(k).downsample.hilbert      = hilbert (s(k).downsample.signal);
s(k).downsample.phase         = angle (s(k).downsample.hilbert);
s(k).downsample.magnitude     = abs   (s(k).downsample.hilbert);
  end
  % Get LFP PACs
  resolution = 360;
  for k=[1:3]
      [s(k).PAC.respiration.mean, s(k).PAC.respiration.std, s(k).PAC.respiration.edges] = PhaseBinMean(s(10).downsample.phase,s(k).downsample.Gamma.magnitude, resolution, s(10).channel, s(k).channel);
      [s(k).PAC.SO.mean, s(k).PAC.SO.std, s(k).PAC.SO.edges] = PhaseBinMean(s(12).downsample.phase,s(k).downsample.Gamma.magnitude, resolution, s(10).channel, s(k).channel);
  end
   % Get intra PACs
  for k = 5
      [s(k).PAC.respiration.mean, s(k).PAC.respiration.std, s(k).PAC.respiration.edges] = PhaseBinMean(s(10).downsample.phase,s(k).downsample.magnitude, resolution, s(10).channel, s(k).channel);
      [s(k).PAC.SO.mean, s(k).PAC.SO.std, s(k).PAC.SO.edges] = PhaseBinMean(s(12).downsample.phase,s(k).downsample.magnitude, resolution,s(12).channel,  s(k).channel);
  end
  time1k = [1:length(s(1).downsample.signal)].';
 clear j k
 PolarPAC2
 PolarRespiration %% 
 
% Make figures and save things
for k = 1:12
 PACs(k).channel = s(k).channel;
PACs(k).PAC = s(k).PAC;
 end
 
 


disp ('Saving...')
newDirectory = 'C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\7 - Results\Intra';
newFileName  = fullfile(strcat(erase(theFiles(sh).name,'.smr'))); 
newAddress =  fullfile(newDirectory,newFileName)
% mkdir (newAddress);
    fnsave = fullfile (newAddress,strcat (newFileName, '_s.mat'));
    fnsave1 = fullfile (newAddress, strcat(newFileName,'_Phase.mat'))
    fnsave2 = fullfile (newAddress, strcat(newFileName,'_PACs.mat'))
    %MakeRipples
   % s(3).Ripple.Ripples = ripples;
    save(fnsave, 's', '-v7.3')  
     save(fnsave1, 'Phase', '-v7.3')  
     save(fnsave2, 'PACs', '-v7.3')  
% % 


%     disp ('Saving figures...')
%     close all
% newFigName   = strcat (erase (theFiles(sh).name, '.smr'), '.fig');
% figsave= fullfile (newDirectory, newFigName);
%  
%  PolarRespiration;
%  jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Phases.jpg'));
%  figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Phases.fig'));
%  savefig(h(1),figsave); 
%  saveas(h(1),jpgsave)
%  
% try
% h(2) = figure;
% SpikeStats;
% catch
% end
% 
% jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_SpikeStats.jpg'));
% figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_SpikeStats.fig'));
% savefig(h(2),figsave); 
% saveas(h(2),jpgsave)
% 
% h(3)= figure;
% VmDistribution;
% jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Vm.jpg'));
% figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Vm.fig'));
% savefig(h(3),figsave); 
% saveas(h(3),jpgsave)
% 
% PolarPAC2;
% 
% figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_PAC.fig'));
% jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_PAC.jpg'));
% savefig(h(4),figsave);
% saveas(h(4),jpgsave)
% 
% 
% close (h)
% 
% 
% disp(theFiles(sh).name)
% disp ('Donedidley')
% 
close all
ClearVariables
%% Save all

%IO

%SaveIO 
 