

time = 1: length(d(1).wv);
time = time/1000;
time = time.';


figure (1)
for k = 1:length (d)
   hold on 
   plot (time, d(k).wv)
end


%% 
Fs=1000;
% d(4).wv=Red;
time = 1:length (d(1).wv);
EEG = downsample (d(1).wv, 10);
Resp = downsample (d(4).wv, 20);
filterweights=gamfil1k;
    EEGLowPass1 = filtfilt(gamfil1k.Numerator,1,d(1).wv);
    EEGHilbert = hilbert (EEGLowPass1); EEGPhase = angle (EEGHilbert); EEGmag=abs(EEGHilbert);
    EEGPhase1k = interp (EEGPhase, 10); 
    EEGLowPass1 = d(1).wv;
    
   downsample.squared    = EEGLowPass1.^2; 
 
[downsample.hi,...
downsample.lo]        = envelope(downsample.squared,60, 'rms');
downsample.envelope   = downsample.hi-downsample.lo;
 
threshold                    = mean (s(k).downsample.envelope)+std(s(k).downsample.envelope);

[downsample.pks ,...
downsample.locs]      = findpeaks(s(k).downsample.envelope,'MinPeakDistance',0.3*s(1).downsample.Fs, 'MinPeakHeight', threshold ); 

    
    %% 
  
    [pks, locs] = findpeaks(EEGLowPass1,'MinPeakDistance',250, 'MinPeakHeight', 0.025); %find spike peaks
 pks = pks;
   locs = locs;   %% 
   
  figure (1) 
      plot (time/Fs, d(3).wv, time (locs)/Fs, pks,'mo',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',6)
    
    %% 
    ticks = 1: length(d(4).wv);

    clear coh
    for ch = 1:length(d)
    for k = 1:length (locs)
    idx  = find(ticks == locs(k,1)); %peak of gamma
 if idx>500 & idx<length(ticks)-2000
     coh(ch).names = d(ch).title;
    coh(ch).waves(1:2501,k) = d(ch).wv(idx-500:idx+2000);
    end
    end
    end
  
    
   index2clean = find( sum (coh(1).waves)~=0);
   for k = 1:length(d)
       coh(k).waves = coh(k).waves(:, index2clean);
   end
   


%% 

t  = linspace(0,2.501,2501);
x=coh(1).waves(:,1);
y=coh(2).waves(:,1);
% z=EEGwaves(:,5);

figure (3)
subplot(2,1,1)
plot(t,x)
title('X')
subplot(2,1,2)
plot(t,y)
title('Y')
xlabel('Time (seconds)')
% subplot(3,1,3)
% plot(t,y)
% title('Y')
% xlabel('Time (seconds)')

%% 

clear m
for k = 1:size(coh(1).waves,2)
[m(k).wcoh,~,m(k).fr,m(k).coi] = wcoherence(coh(9).waves(:,k),coh(11).waves(:,k),Fs);
end

MA={};
for k =1:length(m)
MA{k}=m(k).wcoh;
end;

B=cat(3,MA{:});
out=mean(B,3);

fg(2).name = 'Reu Hipp Coherence';fg(2).out{1,15} = out; 

%% 

MB=fg(2).out;
% MB = {AmandeCoherence1 AmandeCoherence2 AmandeCoherence3 AmandeCoherence4 AmandeCoherence5 AmandeCoherence6 AmandeCoherence7};
B=cat(3,MB{:});

out=mean(B,3);
%% 


figure(2)
clf
% period = seconds(period);
% coi = seconds(coi);
% phasebase = mean (coh(4).waves, 2); 
h = pcolor(t,fr,out);
h.EdgeColor = 'none';
ylim ([1 100])
ax = gca;
ax.XLabel.String='Time (s)';
ax.YLabel.String='Frequency (Hz)';
ax.Title.String = 'Wavelet Coherence (mPFC-Reu)';
hcol = colorbar;
hcol.Label.String = 'Magnitude-Squared Coherence';
hold on;
% CoherenceAverage = mean(out(30:60,:), 1)./mean(out(70:100,:),1);
% plot (t, CoherenceAverage*80, 'r', 'Linewidth', 2)
% RespM = mean (coh(3).waves, 2); 
% plot (t, (RespM*5)+25, 'k', 'Linewidth', 2)
legend ('', 'mPFC-Reu Coherence', 'Respiration')



%% 



fs = 1000;                    % Sampling frequency (samples per second)
dt = 1/fs;                   % seconds per sample
StopTime = 2.5;             % seconds
t1 = (0:dt:StopTime)';     % seconds
F = 0.7;                      % Sine wave frequency (hertz)
data1 = sin(2*pi*F*t+2.8);
plot (t1, data1)
%%   %% 
    
    figure
t  = linspace(0,1,2501);
[wcoh,~,fr,coi] = wcoherence(x,y,Fs);

period = seconds(period);
coi = seconds(coi);
h = pcolor(t,fr,wcohm);
h.EdgeColor = 'none';
ax = gca;
ytick=round(pow2(ax.YTick),3);
ax.YTickLabel=ytick;
ax.XLabel.String='Time';
ax.YLabel.String='Period';
ax.Title.String = 'Wavelet Coherence';
hcol = colorbar;
hcol.Label.String = 'Magnitude-Squared Coherence';
hold on;
plot(ax,t,log2(coi),'w--','linewidth',2)

    