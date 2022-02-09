
    EPSP = Intra;
        clear diff

    EPSPfil=EPSPfilter; EPSPfiltered=filtfilt(EPSPfil.Numerator,1,EPSP); % Import EPSP filter
    EPSPdiff = diff(EPSPfiltered);EPSPdiff=[EPSPdiff EPSPdiff(1)];


[pks_spike,locs_spike, widths_spike, proms_spike] = findpeaks(EPSPdiff,'MinPeakDistance',100, 'MinPeakHeight', 0.3); %find spike peaks
[pks_EPSP1,locs_EPSP1,widths_EPSP1,proms_EPSP1] = findpeaks (EPSPdiff, 'MinPeakDistance', 150, 'MinPeakProminence', 0.075); %find EPSP peaks

locs_EPSP = setdiff(locs_EPSP1,locs_spike); % This returns the data in locs_EPSP that is not in locs_spike: i.e removes spike times
pks_EPSP=setdiff(pks_EPSP1,pks_spike);
widths_EPSP=setdiff(widths_EPSP1, widths_spike);widthsdiff=widthsdiff/10;
proms_EPSP=setdiff(proms_EPSP1, proms_spike);

clear pks_EPSP1 locs_EPSP1 widths_EPSP1 proms_EPSP1

%% Plot signals with Intra and EPSPs marked

figure (1)
a1=subplot (2,1,1);
plot (time, EPSP, time (locs_spike), pks_spike,'mo',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',6)
a2=subplot (212);
    plot (time, EPSPdiff, time (locs_EPSP), pks_EPSP,'mo',...
        'LineWidth',1,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',6)
    linkaxes([a1, a2],'x');

    %% 

   
    EPSPOverlay = zeros (151, length(locs_EPSP));
    N=length (locs_EPSP);
for k=1:N
idx=find(time==locs_EPSP(k));
if idx>100 & idx<length(time)-100
EPSPOverlay (1:151, k)= Intra(idx-50:idx+100); EPSPOverlayMean=mean(EPSPOverlay,2);
end
end

clear locs3 pks2 widths3 proms3
pks3={}; locs3={}; widths3={}; proms3={};
EPSPOverlayTrans=EPSPOverlay.'; EPSPOTMean=mean(EPSPOverlayTrans);
HeightThreshold=mean (EPSPOverlayTrans)-3*std(EPSPOverlayTrans); HeightThreshold=min (HeightThreshold);



for h=1:length(EPSPOverlayTrans)
[pks3{h}, locs3{h},widths3{h},proms3{h}] =findpeaks(EPSPOverlayTrans(h,:),'MinPeakDistance', 100, 'MinPeakHeight', HeightThreshold, 'MinPeakProminence',1); 
end

%%

pks_EPSPReal= cell2mat (pks3); proms_EPSPReal=cell2mat (proms3); widths_EPSPReal = cell2mat (widths3);
clear pks3 locs3 proms3 widths3  

%% 

EPSPTime=[1:151].';
   fig= figure (2);
    set(fig,'defaultLegendAutoUpdate','off');
     subplot(2,2,1)
        hold on
        findpeaks(EPSPOTMean,EPSPTime/Fs*1000, 'MinPeakProminence', 1, 'Annotate', 'extents')
        grid off
        shadedErrorBar(EPSPTime/Fs*1000,EPSPOverlayTrans,{@mean,@std},'lineprops', 'g');
        
        hold off
        xlabel ('ms')       
        title('EPSP Average')
        ylabel('Amplitude (mV)'); ylim([-70 -45]);
 
        
      subplot (2,2,2)
        histogram (pks_EPSPReal, 'FaceColor', 'k')
        ylabel ('Count')
        xlabel ('Peak (mV)')
        subplot (2,2,3)
        histogram (proms_EPSPReal,'FaceColor', 'k')
        ylabel ('Count')
        xlabel ('Prominence (mV)')
        subplot (2,2,4)
        histogram (widths_EPSPReal/Fs*1000,'FaceColor', 'k')
        ylabel ('Count')
        xlabel ('Width (ms)')