time2=time;
time2(locsdiff)=[]; %empty matrix where there are locs 
EPSP2=EPSP;
EPSP2(time2)=0; % zero only where there are no locs (empty matrix)

N = length (locs_EEG);
%%Slow waves
for k=1:N
    idx=find(time==locs_EEG(k)); %peak of gamma
    if idx>15000 & idx<length(time)-15000
    mPFC_SWtrig (1:30001,k) = mPFC(idx-15000:idx+15000);
    %mPFC_SWtrig_lp (1:30001,k) = mPFC_lowpass(idx-15000:idx+15000);
    EPSP_SWtrig (1:30001,k) = EPSP(idx-15000:idx+15000);
    EPSP2_SWtrig (1:30001,k) = EPSP2(idx-15000:idx+15000);
    end
end
%% For plotting, this part replaces zeroes with NaN

EPSP3_SWtrig=EPSP2_SWtrig;
EPSP3_SWtrig(EPSP3_SWtrig==0)=NaN; % THIS VARIABLE HAS THE EPSP PEAKS AS POINTS
timeseg=-15000:1:15000;

% Get EPSP count as bar graph with time on x axis rescaled from -1.5 to
% 1.5 with bar with 500 data points (.05 seconds)

EPSP2count_SWtrig = EPSP2_SWtrig;
EPSP2count_SWtrig (EPSP2_SWtrig<0) = 1; %Replace any values smaller than 0 with 1 and keep the rest as zero
EPSP2count_SWtrig_Sum = sum (EPSP2count_SWtrig, 2); % Sum all EPSP occurences (1) along each data point for all SW-triggered trials
EPSP2count_SWtrig_Sum= EPSP2count_SWtrig_Sum (2:end); %Remove first point to make an array of 30,000 points from 30,001 points
EPSP_bar=sum(reshape(EPSP2count_SWtrig_Sum, 1000, []))'; % Sum segments of 500 points to make 60 bins

    EPSP_time = [1:30];
    EPSP_time = rescale (EPSP_time, -1.5,1.5); % Define x-axis for bar graph as time from -1.5 to 1.5 seconds around gamma peak
    
    %% 

figure (3)
 
 subplot (4,1,1)

    plot (timeseg, EPSP3_SWtrig, '.', 'MarkerSize', 12, 'Color', [0 0.6 0]);
    title ('Reuniens EPSP peak values')
    xlim ([-15000 15000]);
    ylabel ('EPSP peak (mv)')

 subplot (4,1,2)
 
    bar (EPSP_time, EPSP_bar, 'BarWidth',1 , 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none')
    
    title ('Reuniens EPSP count')
    ylabel ('EPSP count')
    
 subplot (4,1,3)
  shadedErrorBar(timeseg,EEG_SWtrig.',{@mean,@std},'lineprops', 'k'); 

    subplot (4,1,4)
    shadedErrorBar(timeseg,EEG_SW_gamma.',{@mean,@std},'lineprops', 'k'); 
    
        %% Make figure showing mPFC gamma modulation detected by EEG gamma peaks  
        
        figure (2)
 
    CA1_gamma=filtfilt(gamfil.Numerator,1,CA1); %run 100-300 Hz bandpass on mPFC signal here called CA1_gamma to confuse myself
    CA1_gamma=(CA1_gamma.*CA1_gamma)*100; %square and amplify
    N=length (locs_mPFC);
for k=1:N
idx=find(time==locs_mPFC(k));
if idx>15000 && idx<length(time)-15000
CA1_gamma_SWtrig (1:30001, k)= CA1_gamma(idx-15000:idx+15000); CA1_gamma_mean=mean(CA1_gamma_SWtrig,2);

end
end
    
    
    
    figure (2)
 subplot (3,1,1);
    plot (timeseg, CA1_gamma_SWtrig,'r')
    title ('mPFC gamma (40-120 Hz)')
    xlim ([-15000 15000]);
    ylabel ('mV')

 subplot (3,1,2)

    plot (timeseg, EPSP3_SWtrig, '.', 'MarkerSize', 8, 'Color', [0 0.6 0]);
    title ('Reuniens EPSP peak values')
    xlim ([-15000 15000]);
    ylabel ('EPSP peak (mv)')

 subplot (3,1,3)
 
    bar (EPSP_time, EPSP_bar, 'BarWidth',1 , 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5])
    ylim ([0 110])
    title ('Reuniens EPSP count')
    ylabel ('EPSP count')


%% 

%%Ripples and EPSP relationship

for k=1:length(locs_CA1);
    idx=find(time==locs_CA1(k));
    if idx>15000 & idx<length(time)-15000
        CA1_riptrig (1:30001,k) = CA1(idx-15000:idx+15000);
        CA1_riptrig_hp (1:30001,k) = CA1_ripplefiltered(idx-15000:idx+15000);
        EPSP_riptrig (1:30001,k) = EPSP(idx-15000:idx+15000);
    EPSP2_riptrig (1:30001,k) = EPSP2(idx-15000:idx+15000);
    end
end



EPSP3_riptrig=EPSP2_riptrig;
EPSP3_riptrig(EPSP3_riptrig==0)=NaN; % THIS VARIABLE HAS THE EPSP PEAKS AS POINTS
timeseg=-15000:1:15000;

% Get EPSP count as bar graph with time on x axis rescaled from -1.5 to
% 1.5 with bar with 500 data points (.05 seconds)

EPSP2count_riptrig = EPSP2_riptrig;
EPSP2count_riptrig (EPSP2_riptrig<0) = 1; %Replace any values smaller than 0 with 1 and keep the rest as zero
EPSP2count_riptrig_Sum = sum (EPSP2count_riptrig, 2); % Sum all EPSP occurences (1) along each data point for all SW-triggered trials
EPSP2count_riptrig_Sum= EPSP2count_riptrig_Sum (2:end); %Remove first point to make an array of 30,000 points from 30,001 points
EPSP_bar_rip=sum(reshape(EPSP2count_riptrig_Sum, 1000, []))'; % Sum segments of 500 points to make 60 bins

    EPSP_time = [1:30];
    EPSP_time = rescale (EPSP_time, -1.5,1.5); % Define x-axis for bar graph as time from -1.5 to 1.5 seconds around gamma peak
    %% 

figure (3)
 subplot (3,1,1);
    plot (timeseg, CA1_riptrig,'b')
    title ('CA1 ripples')
    xlim ([-15000 15000]);
    ylabel ('mV')

 subplot (3,1,2)

    plot (timeseg, EPSP3_riptrig, '.', 'MarkerSize', 8, 'Color', [0 0.6 0]);
    title ('Reuniens EPSP peak values')
    xlim ([-15000 15000]);
    ylabel ('EPSP peak (mv)')

 subplot (3,1,3)
 
    bar (EPSP_time, EPSP_bar_rip, 'BarWidth',1 , 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', [0.5 0.5 0.5])
    
    title ('Reuniens EPSP count')
    ylabel ('EPSP count')
    
    
%% 
Spike3_riptrig=Spike2_riptrig;
Spike3_riptrig(Spike3_riptrig==0)=NaN;
x=[1:60];
x=rescale(x,-1.5,1.5);
y2=sum(Result2~=0,2);
%timeseg=-15000:1:15000;
figure (1)
subplot (3,1,1);
title ('CA1')
xlim ([-15000 15000]);
plot (timeseg, CA1_riptrig,'b')
subplot (3,1,2)

plot (timeseg, Spike3_riptrig, 'x', 'Color', [0 0.6 0]);
title ('Intra Reuniens')
xlim ([-15000 15000]);
ylabel ('EPSP peak (mv)')

subplot (3,1,3)
bar(x,y2,1,'k');
