
 % Filter for gamma
 disp('Filtering for gamma...') 

dsFactor = 20;

tic
fn = fullfile(theFiles(sh).folder, theFiles(sh).name);
CheckFilters; d=getspike2 (fn, 'all'); %import data from Spike2 

    Fs=d(1).Fs;
    time = [1:length(d(1).wv)].';

    for k=1:size(d,2)   

s(k).IO.signals  =d(k).wv;
    end
    
  clear d a 

  %% 
dsFactor=20;

disp('Downsampling...')
  for k=1:3
s(k).IO.name     = 'Downsampled 20k to 1k';
s(k).IO.downsampled = downsample ((s(k).IO.signals), 20); 
s(k).IO.Fs      = Fs/dsFactor;
s(k).IO.gamma.filtered   = filtfilt (gamfil1k.Numerator,1,s(k).IO.downsampled);
s(k).IO.gamma.squared    = (s(k).IO.gamma.filtered).^2; 
 
[s(k).IO.gamma.hi,...
s(k).IO.gamma.lo]        = envelope(s(k).IO.gamma.squared,250, 'rms');
s(k).IO.gamma.envelope   = s(k).IO.gamma.hi-s(k).IO.gamma.lo;
 
threshold                        = mean (s(k).IO.gamma.envelope)+std(s(k).IO.gamma.envelope);
threshold                        = threshold/2;
[s(k).IO.gamma.pks ,...
s(k).IO.gamma.locs]      = findpeaks(s(k).IO.gamma.envelope,'MinPeakDistance',0.3*s(1).IO.Fs, 'MinPeakHeight', threshold ); 

s(k).IO.gamma.logical    = zeros(length(s(k).IO.gamma.envelope),1);
s(k).IO.gamma.logical((s(k).IO.gamma.envelope>threshold)) = 1;
s(k).IO.gamma.derivative = diff(s(k).IO.gamma.logical);
s(k).IO.gamma.ON         = find (s(k).IO.gamma.derivative==1);
s(k).IO.gamma.ON (:,2)   = s(k).IO.gamma.ON/s(1).IO.Fs;
s(k).IO.gamma.OFF        = find (s(k).IO.gamma.derivative==-1);
s(k).IO.gamma.OFF (:,2)  = s(k).IO.gamma.OFF/s(1).IO.Fs;

  end
  
  time1k = [1:length(s(1).IO.signals)].';
 clear j k
 
 
 PlotDetectedUPdownsampled
 
 
 %% 
 
 disp ('Correcting Vm to spike threshold...')

s(5).IO.EPSP.filtered    = filtfilt (EPSPfil.Numerator,1, s(5).IO.signals);
s(5).IO.EPSP.derivative  = diff(s(5).IO.EPSP.filtered);
s(5).IO.EPSP.derivative  = [s(5).IO.EPSP.derivative; s(5).IO.EPSP.derivative(1)];

threshold_spike       = mean (s(5).IO.EPSP.derivative) + 3*std (s(5).IO.EPSP.derivative); 

[s(5).IO.EPSP.spike_pks,s(5).IO.EPSP.spike_locs,...
s(5).IO.EPSP.spike_widths, s(5).IO.EPSP.spike_proms]...
                            = findpeaks(s(5).IO.EPSP.derivative,'MinPeakDistance',100, 'MinPeakHeight', threshold_spike); %find spike peaks

s(5).IO.EPSP.spike_locs (:,2) = s(5).IO.EPSP.spike_locs/Fs;
                        

s(5).IO.EPSP.spike_threshold_locs = s(5).IO.EPSP.spike_locs (:,1) - round (s(5).IO.EPSP.spike_widths);
s(5).IO.EPSP.spike_threshold_vals = s(5).IO.signals (s(5).IO.EPSP.spike_threshold_locs);
s(5).IO.EPSP.correction_val       = -57-mean(s(5).IO.EPSP.spike_threshold_vals);
s(5).IO.EPSP.signals                   = s(5).IO.signals + s(5).IO.EPSP.correction_val;


disp ('Done.')    %% 
    
  s(5).IO.EPSP.downsampled = downsample (s(5).IO.EPSP.signals, 20);
  s(6).IO.EPSP.downsampled = downsample(s(6).IO.signals, 20);    
   
  b=diff(s(6).IO.EPSP.downsampled);
    b = [b; b(end)];
    %% 
    cha = 0.005;
    findpeaks (b, 'MinPeakHeight', cha,'MinPeakDistance', 0.1*Fsds);
    %% 
    
    
 clear pksplu locspls pksminus locsminus   
[pksplus locspls] = findpeaks (b, 'MinPeakHeight',cha,'MinPeakDistance', 0.1*Fsds);
[pksminus locsminus] = findpeaks (-b, 'MinPeakHeight',cha,'MinPeakDistance', 0.1*Fsds);
% 
% if size (locspls,1) > size (locsminus, 1)
%     locspls= locspls(1:end-1, :); 
%     pksplus = pksplus (1:end-1,:);
% end
% 
% if size (locspls,1) < size (locsminus, 1)
%     locsminus = locsminus (1:end-1,:);
%     pksminus = pksminus (1:end-1,:);
% end

if size (locspls,1) < size (locsminus, 1)
a=size(locspls,1);
else 
    a=size(locsminus,1);
end

for k = 1:a
    bb(k)=locspls(k)-locsminus(k);
end


locs = [locspls locsminus];
locs (:,3) = locs(:,2) - locs(:,1);


idx  = find (locs(:,3)>0);
idx2 = find (locs(:,3)<0);
f={};


for k = 1:size(idx)
    f{1,k} =locs(idx(k),1):locs(idx(k),2);
end
 j=size (f,2);
for k = 1:size (idx2)  
f{1,j+k} =locs(idx2(k),2):locs(idx2(k),1);

end

for k = 1:size (f,2); 
  f{2,k}= s(6).IO.EPSP.downsampled(f{1,k});  % CM
  f{3,k}= s(5).IO.EPSP.downsampled(f{1,k}); % Intra
  f{4,k} = mean (f{2,k});
  f{5,k}= std (f{2,k});
  f{6,k} = mean (f{3,k});
  f{7,k}=std (f{3,k});
  
  f{8,k}= (f{1,k}(1,1)-100):(f{1,k}(1,end)+100);  % CM for plotting
  f{9,k}= s(6).IO.EPSP.downsampled (f{8,k});  % CM for plotting
  f{10,k}=s(5).IO.EPSP.downsampled (f{8,k}); % Intra for plotting
  
end

UP = ripples{1,1};
for k = 2:200
    UP = [UP ripples{1,k}];
end

for k = 1:size(f,2)
    f{11,k} = ismember (f{1,k}, UP);
    f{12,k} = sum (f{11,k})/length(f{11,k});
    f{13,k} = find (f{12,k}>0.9);
    f{14,k}=  find (f{12,k}<0.1);
    
end

for k = 1:size (f,2)
    a = find (f{13,k}==1);
end

for  k = 1:size (f,2)
if cell2mat (f(13,k)) == 1
    ind_UP(k)=k ;
else
    ind_DOWN (k) = k;
end
end

ind_UP (ind_UP == 0) = []; ind_DOWN (ind_DOWN == 0) = [];
%s(5).IO.segments = f;

UP = {}; UP = f(:,ind_UP);
DOWN = {}; DOWN = f(:,ind_DOWN);

s(5).IO.EPSP.UP = UP; s(5).IO.EPSP.DOWN = DOWN;
% SaveIO

locstimes = f{1,1};
for k = 2:size (f,2)
  locstimes = [locstimes f{1,k}];
end

time2 = [1:length(s(5).IO.EPSP.downsampled)].';
nolocstimes = setdiff (time2, locstimes);
 baselineCM = mean (s(6).IO.EPSP.downsampled (nolocstimes));
 baselineIntra = mean (s(5).IO.EPSP.downsampled (nolocstimes));

%% 
clear f
 f=UP;
    plottime = 1:size(f{10,2},1); plottime=plottime.';  
        CM = cell2mat (f(4,:)); Intra=cell2mat(f(6,:));
        deltaCM = baselineCM-CM;deltaIntra = baselineIntra-Intra;
        
    %deltaCM=deltaCM/50;

        P = polyfit(deltaCM,deltaIntra,1);
        yfit =  P(1)*deltaCM+P(2);

subplot (121)

hold on
    plot (deltaCM, deltaIntra,'ko')
    plot (deltaCM, yfit, 'r-.')
        xlabel ('\Delta Current (nA)')
        ylabel ('\Delta Voltage (mV)')
        txt = strcat ('Input Resistance =  ', num2str (round (P(1)),2), 'M\Omega');
        aaa=size(deltaCM,2);
        text (deltaCM (round(aaa/4)), deltaIntra (round(aaa/4)), txt);
        title ('Resistance during UP states')
hold off

%% 
 f=DOWN;
    plottime = 1:size(f{10,2},1); plottime=plottime.';
       
        CM = cell2mat (f(4,:)); Intra=cell2mat(f(6,:));
        deltaCM = baselineCM-CM;deltaIntra = baselineIntra-Intra;
        
        
    %deltaCM=deltaCM/50;

        P = polyfit(deltaCM,deltaIntra,1);
        yfit =  P(1)*deltaCM+P(2);


subplot (122)

hold on
    plot (deltaCM, deltaIntra,'ko')
    plot (deltaCM, yfit, 'r-.')
        xlabel ('\Delta Current (nA)')
        ylabel ('\Delta Voltage (mV)')
        txt = strcat ('Input Resistance =  ', num2str (round (P(1)),2), 'M\Omega');
        aaa=size(deltaCM,2);
        text (deltaCM (round(aaa/4)), deltaIntra (round(aaa/4)), txt);
        title ('Resistance during DOWN states')
hold off

%% 
