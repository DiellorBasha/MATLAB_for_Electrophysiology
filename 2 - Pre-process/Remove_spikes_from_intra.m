Intra_nospike=filloutliers (IntraDownsample, 'linear');


timesec=seconds(time/20000);
plot (EEGTime, IntraDownsample, 'k-')
hold on
plot (EEGTime, Intra_nospike_smoothed, 'r', 'Linewidth', 2)
ylabel ('mV')
xlabel ('Time')

IntraDownsamplesmooth=downsample (Intra_nospike_smoothed, 200);
 IntraLowPass = filtfilt(filterweights.Numerator,1,double(IntraDownsamplesmooth));
 IntraLowPass=detrend(IntraLowPass);
 IntraHilbertDS=hilbert(IntraLowPass);
 IntraPhase=angle (IntraHilbertDS);
 RipplePhaseIntra = IntraPhase (idx_ripple_times);
 
 
 subplot (2,2,[1,3])
polarplot([zeros(1,N); RipplePhaseIntra],[zeros(1,N); ones(1,N)],'k')
pax = gca;
pax.ThetaAxisUnits = 'radians';
pax.ThetaLim = [-pi pi];
text(0,1.1,'UP','Fontsize', 14)
text(pi,1.4,'DOWN','Fontsize', 14)
title ('Ripple coupling to EEG phase')
 


hold on
plot (EEGTime, IntraLowPass)
hold off
plot (EEGTime, angle (IntraHilbertDS), 'r', 'Linewidth', 2)
plot (EEGTime, IntraLowPass, 'r', 'Linewidth', 2)