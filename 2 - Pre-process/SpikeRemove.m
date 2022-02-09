Spike=detrend(Intra);

[pks_spike,locs_spike] = findpeaks(Spike,'MinPeakDistance',100, 'MinPeakHeight', 40); %find peaks
figure(1)
plot (time, Spike, time (locs_spike), pks_spike,'mo',...
       'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',6)




%% 


clear Intra1
IntraSpike=locs_spike; % Define a new vector with the index of spike times
for k=1:length(IntraSpike) % Create a matrix with indices of spiketime + 55 and - 15 data points
    Intra1 (k,:)=IntraSpike(k)-20:IntraSpike(k)+130;
end


IntraSpikeless=Intra; %Define new vector from Intra recording. We will remove spikes from this vector
IntraSpikeless(Intra1)=NaN; %Remove spiketimes +- 55/15 data points from IntraSpikeless and fill it NaN
 plot(IntraSpikeless, '.') % Plot 
 
 