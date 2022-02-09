
time_spike = (-size (s(5).EPSP.spikewaves,1)/2:1:(size (s(5).EPSP.spikewaves,1)/2)-1).';

subplot (4,2,[1,3,5,7]);
spikemean = mean (s(5).EPSP.spikewaves, 2);

    p2 =shadedErrorBar ((time_spike/Fs)*1000, s(5).EPSP.spikewaves.',{@mean,@std});
        hold on
    findpeaks (spikemean,(time_spike/Fs)*1000, ...
    'MinPeakDistance',(500/Fs)*1000, 'MinPeakHeight', -35, 'annotate', 'extents');
    %set(gca,'ydir','reverse')
    plot ((time_spike/Fs)*1000,spikemean, 'k', 'LineWidth', 1.5)
        grid off
        hold off
        xlim ([-2 8])
    ylim ([min(spikemean)-5  max(spikemean)+5])
    ylabel ('mV')
    xlabel ('ms')
    txt1 = '# spikes detected = ';
    spikecount =  num2str(size (s(5).EPSP.spikewaves, 2));
    text(4,-15,strcat (txt1,spikecount))
    txt2 = '# AHPs detected = ';
    AHPcount =  num2str(size (s(5).EPSP.AHP.prom, 2));
    text(4,-17,strcat (txt2,AHPcount))

%% 

subplot (422);
histogram (s(5).EPSP.spike_widths1/Fs*1000, 'normalization', 'probability', ...
    'orientation', 'horizontal', 'FaceColor', [0.1 0.1 0.1], 'FaceAlpha', 0.6,...
    'EdgeColor', 'none')
ylabel ('ms')
title ('Spike half-width')
subplot (424);
histogram (s(5).EPSP.EPSP_proms, 'normalization', 'probability', ...
    'orientation', 'horizontal', 'FaceColor', [0.1 0.1 0.1], 'FaceAlpha', 0.6,...
    'EdgeColor', 'none')
ylabel ('mV')
title ('Spike amplitude')
subplot (426);
histogram (s(5).EPSP.AHP.width/Fs*1000, 'normalization', 'probability', ...
    'orientation', 'horizontal', 'FaceColor', [0.1 0.1 0.1], 'FaceAlpha', 0.6,...
    'EdgeColor', 'none')
ylabel ('ms')
title ('AHP half-width')
subplot (428);
histogram (s(5).EPSP.AHP.prom, 'normalization', 'probability', ...
    'orientation', 'horizontal', 'FaceColor', [0.1 0.1 0.1], 'FaceAlpha', 0.6,...
    'EdgeColor', 'none')
ylabel ('mV')
xlabel ('Normalized count')
title ('AHP amplitude')


