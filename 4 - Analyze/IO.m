
fn1 = fullfile(theFiles(sh1).folder, theFiles(sh1).name);

c=getspike2(fn1, 'all');
%% 



    time2 = [1:length(c(1).wv)].';
clear r
    for k=1:size(c,2)   
r(k).channel = c(k).title;
r(k).type    = c(k).type;
r(k).signals  =c(k).wv;
    end
% 
%     r(6).channel = r(5).channel;
%   r(5).channel = r(4).channel;
%    r(6).signals = r(5).signals;
%        r(5).signals = r(4).signals;

    queryIntra        = find(contains({r.channel}, 'Intra'));
    queryCM            = find(contains({r.channel}, 'CM')); 
    
    %%   % Filter for EPSP and spikes
  disp ('Correcting Vm to spike threshold...')

r(5).EPSP.filtered    = filtfilt (EPSPfil.Numerator,1, r(5).signals);
r(5).EPSP.derivative  = diff(r(5).EPSP.filtered);
r(5).EPSP.derivative  = [r(5).EPSP.derivative; r(5).EPSP.derivative(1)];

threshold_spike       = mean (r(5).EPSP.derivative) + 3*std (r(5).EPSP.derivative); 

[r(5).EPSP.spike_pks,r(5).EPSP.spike_locs,...
r(5).EPSP.spike_widths, r(5).EPSP.spike_proms]...
                            = findpeaks(r(5).EPSP.derivative,'MinPeakDistance',100, 'MinPeakHeight', threshold_spike); %find spike peaks

r(5).EPSP.spike_locs (:,2) = r(5).EPSP.spike_locs/Fs;
                        

r(5).EPSP.spike_threshold_locs = r(5).EPSP.spike_locs (:,1) - round (r(5).EPSP.spike_widths);
r(5).EPSP.spike_threshold_vals = r(5).signals (r(5).EPSP.spike_threshold_locs);
r(5).EPSP.correction_val       = -57-mean(r(5).EPSP.spike_threshold_vals);
r(5).signals                   = r(5).signals + r(5).EPSP.correction_val;

for k = 1:length (r(5).EPSP.spike_locs)
    idx  = find(time2 == r(5).EPSP.spike_locs(k,1)); %peak of gamma
 if idx>500 & idx<length(time2)-500
   r(5).EPSP.spikewaves(1:1001,k) = r(5).signals(idx-500:idx+500);
 end
end


disp ('Done.')    %% 
    
    
    b=diff(r(6).signals);
    b = [b; b(end)];
    %% 
    cha = 0.1;
    findpeaks (b, 'MinPeakHeight', cha,'MinPeakDistance', 0.1*Fs);
    %% 
    
    
 clear pksplu locspls pksminus locsminus   
[pksplus locspls] = findpeaks (b, 'MinPeakHeight',cha,'MinPeakDistance', 0.3*Fs);
[pksminus locsminus] = findpeaks (-b, 'MinPeakHeight',cha,'MinPeakDistance', 0.3*Fs);

if size (locspls,1) > size (locsminus, 1)
    locspls= locspls(1:end-1, :); 
    pksplus = pksplus (1:end-1,:);
end

if size (locspls,1) < size (locsminus, 1)
    locsminus = locsminus (1:end-1,:);
    pksminus = pksminus (1:end-1,:);
end

locs = [locspls locsminus];
locs (:,3) = locs(:,2) - locs(:,1);

%plot (r(queryCM).signals)

%r(6).IO.locs = locs;
%r(6).IO.signals = r;

idx  = find (locs(:,3)>0);
idx2 = find (locs(:,3)<0);
f={};
% Get the times (in sample points) between 

for k = 1:size(idx)
    f{1,k} =locs(idx(k),1):locs(idx(k),2);
end
 j=size (f,2);
for k = 1:size (idx2)  
f{1,j+k} =locs(idx2(k),2):locs(idx2(k),1);

end

for k = 1:size (f,2); 
  f{2,k}= r(6).signals(f{1,k});  % CM
  f{3,k}= r(5).signals (f{1,k}); % Intra
  f{4,k} = mean (f{2,k});
  f{5,k}= std (f{2,k});
  f{6,k} = mean (f{3,k});
  f{7,k}=std (f{3,k});
  
  f{8,k}= (f{1,k}(1,1)-3000):(f{1,k}(1,end)+3000);  % CM for plotting
  f{9,k}= r(6).signals (f{8,k});  % CM for plotting
  f{10,k}=r(5).signals (f{8,k}); % Intra for plotting
  
end

s(6).IO.segments = f;

% SaveIO