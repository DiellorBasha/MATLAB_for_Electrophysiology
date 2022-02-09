

EEG = s(1).signals;
mPFC = s(2).signals;
CA1 = s(3).signals;
Intra = s(5).signals;
time = [1:length(EEG)].';

ripON=s(3).downsample.ON.included(:,2); ripOFF = s(3).downsample.OFF.included(:,2);
ripON = round (ripON*Fs); ripOFF = round (ripOFF*Fs);
if size (ripON,1)>size (ripOFF,1)
   ripON = ripON (1:end-1);
elseif size (ripOFF,1)>size (ripON,1)
    ripOFF = ripOFF (1:end-1);
end


ripON=[ripON ripOFF];
rippleBand = [100 300];

ripples = {};
for k=1:size(ripON, 1);
idxON  = find(time == ripON (k, 1)); %peak of gamma
idxOFF = find(time == ripON (k, 2));
  ripples {1,k} = idxON:idxOFF; 
  ripples {2,k} = CA1 (ripples {1,k});
  ripples {3,k} = bandpower (ripples {2,k}, Fs, rippleBand);
  ripples {4,k} = mean (Intra (ripples{1,k}));
  ripples {5,k}=downsample (ripples{2,k}, 20);
  [ripples{6,k},ripples{7,k}] = cwt(ripples{2,k}, Fs);
  ripples {8,k} = mean (abs(ripples{6,k}),2);
 [ripples{9,k},ripples{10,k}] = findpeaks(ripples{8,k}, 'MinPeakDistance',50, 'MinPeakHeight',0.03);
  %[ripples{9,k}, ripples{10,k}] = max  (ripples{8,k}(ripples{9,k}));
 % ripples {11,k} = ripples{7,k}(ripples{10,k});
 % ripples {12,k} = Intra (ripples{1,k});
end

%% 

a1=subplot (3,1,1:2);
plot (time/Fs, Intra, 'Color', [0 0.5 0]);
hold on
%plot (time(IntraSpike)/Fs, a-65, 'o')
ylabel ('mV') 

a2=subplot (313);
hold on
plot (time/Fs, EEG, 'r', 'LineWidth', 2)

plot (time/Fs, CA1+1, 'b');
for k = 1:size (ripples, 2)
plot (time(ripples{1,k})/Fs, ripples {2,k} + 1, 'k-')
end

total_ripple_count=size(ripON,1);
    title(['CA1: Ripples detected = ', num2str(total_ripple_count)])
    ylabel('Amplitude (mV)') % y-axis label
    
plot (time/Fs, mPFC + 2, 'Color', [0.5 0 0])
ylabel ('mV')

xlabel ('Time (s)')

linkaxes ([a1 a2], 'x')
xlim ([1 10])