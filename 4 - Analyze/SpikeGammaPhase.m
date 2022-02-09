%you'll need spike2 file with: 1. Gamma filtered signal
                              %2. Spike times in separate channels
                              %3. Gamma burst onsets

 for k=1:7   
s(k).channel = d(k).title;
s(k).signals  =d(k).wv;
 end
    
 k=2
 s(k).Gamma.signal     = 'Bandpassed signal (30-100 Hz)';
%s(k).Gamma.filtered   =  filtfilt (gamfil1k.Numerator,1,s(k).signals);
s(k).Gamma.filtered   =  s(k).signals;
s(k).Gamma.squared    = (s(k).Gamma.filtered).^2; 
[s(k).Gamma.hi,...
s(k).Gamma.lo]        = envelope(s(k).Gamma.squared,100, 'rms');
s(k).Gamma.envelope   = s(k).Gamma.hi-s(k).Gamma.lo;
 s(k).Gamma.hilbert = hilbert(s(k).signals);
 s(k).Gamma.phase = angle(s(k).Gamma.hilbert);
 s(k).Gamma.mag  = abs(s(k).Gamma.hilbert);
threshold                   = mean (s(k).Gamma.envelope)+std(s(k).Gamma.envelope);
[s(k).Gamma.pks ,...
s(k).Gamma.locs]      = findpeaks(s(k).Gamma.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold/4 ); 
 [y, threshold] = ginput
 findpeaks(s(k).Gamma.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold )
  
 time = 1:length(d(2).wv);                                                     
 window = 0.5*Fs;
for j = 1:size(s(k).Gamma.locs, 1)
    idx=find(time==s(k).Gamma.locs(j,1));
 if idx>window/2 && idx<length(time)-window/2
    s(k).Gamma.ONtimes (1:window+1,j) = time(idx-window/2:idx+window/2);
 end
end                             
                              
      
                              
% 
% idx2 = find(GammaBurst(:,2)==1); %find where gamma burst starts
% timeON = round ((GammaBurst(idx2,1))*Fs) %get index vectors coordinates of gamma onset
% timeOFF = timeON+0.6*Fs; %add 600 ms to start of gamma burst
% %make array of gamma on times
% for k = 1:length(timeON)       
% ONtimes (k,:) = timeON(k,1):timeOFF(k,1);
% end

% 
%% 

s(k).phase.ang = angle(hilbert(s(2).signals));%get phases of gamma filtered signal
s(k).phase.angON = s(k).phase.ang(s(k).Gamma.ONtimes);%get phase when gamma burst is on
for k = [1,3]
s(k).spike.ON = s(k).signals(s(2).Gamma.ONtimes); %get spike times when gamma burst is on
s(k).spike.phases.phases = s(2).phase.angON(s(k).spike.ON==1);
s(k).spike.phases.phases = rad2deg(s(k).spike.phases.phases);
end
%% 


nBins2 = 360; % Use different number of bins, resulting in 20 deg bins
h(1) = figure ('Name', 'EPSP/Spikes on SO and Respiration phase', 'units','normalized','outerposition',[0.2 0.2 0.8 0.8]);

clf
for k = [1,3]
s(k).spike.phases.subAx = subplot(1, 3, k, polaraxes);
s(k).spike.phases.obj = CircHist(s(k).spike.phases.phases, nBins2, 'parent', s(k).spike.phases.subAx);

     %adjust appearance
     
     s(k).spike.phases.obj.colorBar = 'k';  % change color of bars
s(k).spike.phases.obj.avgAngH.LineStyle = '--'; % make average-angle line dashed
s(k).spike.phases.obj.avgAngH.LineWidth = 1; % make average-angle line thinner
s(k).spike.phases.obj.colorAvgAng = [.5 .5 .5]; % change average-angle line color
% remove offset between bars and plot-center
rl = rlim; % get current limits
s(k).spike.phases.obj.setRLim([0, rl(2)]); % set lower limit to 0
% draw circle at r == 0.5 (where r == 1 would be the outer plot edge)
rl = rlim;
s(k).spike.phases.obj.drawCirc((rl(2) - rl(1)) /2, '--b', 'LineWidth', 2)
s(k).spike.phases.obj.scaleBarSide = 'right'; % draw rho-axis on the right side of the plot
s(k).spike.phases.obj.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0° on the right side
s(k).spike.phases.obj.setThetaLabel(s(k).channel, 'bottomleft'); % add label
% draw resultant vector r as arrow
delete(s(k).spike.phases.obj.rH)
s(k).spike.phases.obj.drawArrow(s(k).spike.phases.obj.avgAng, s(k).spike.phases.obj.r * range(rl), 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r')
% Change theta- and rho-axis ticks
s(k).spike.phases.obj.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
thetaticks(0:90:360); % change major ticks
rticks(0:4:20); % change rho-axis tick-steps
s(k).spike.phases.obj.drawScale; % update scale bar    

end
