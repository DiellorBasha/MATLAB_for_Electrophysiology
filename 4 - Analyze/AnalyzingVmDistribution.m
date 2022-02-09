    %% %% Analyze Vm distribution
disp('Analyzing Vm distribution...')
s(5).Vm.smooth.signal        = smooth (s(5).signals, 5000);
s(5).Vm.smooth.edges         =  -100:0.2:50;
s(5).Vm.smooth.histcounts    = histcounts(s(5).signals, s(5).Vm.smooth.edges);
[s(5).Vm.smooth.pks,...
    s(5).Vm.smooth.locs]     = findpeaks (s(5).Vm.smooth.histcounts,...
                                'MinPeakHeight', max(s(5).Vm.smooth.histcounts)/2,...
                                'MinPeakDistance', 15);
threshold                    = min (s(5).Vm.smooth.edges(s(5).Vm.smooth.locs));
                            
[s(5).Vm.smooth.pks,...
    s(5).Vm.smooth.locs]     = findpeaks (s(5).Vm.smooth.histcounts,...
                                'MinPeakHeight', max(s(5).Vm.smooth.histcounts)/2,...
                                'MinPeakDistance', 15);
                            
s(5).Vm.edges         =  -100:0.2:50;
s(5).Vm.histcounts    = histcounts(s(5).signals, s(5).Vm.edges);
s(5).Vm.prominent_Vm  = s(5).Vm.edges(s(5).Vm.smooth.locs);

[s(5).Vm.pks,...
    s(5).Vm.locs]     = findpeaks (s(5).Vm.smooth.signal,...
                                'MinPeakHeight', threshold,...
                                'MinPeakDistance', 0.5*Fs);
                            
s(5).Vm.smooth.GammaON = s(5).Vm.smooth.signal (s(1).Gamma.ONtimes);
s(5).Vm.smooth.GammaOFF = s(5).Vm.smooth.signal (s(1).Gamma.OFFtimes);

%s(5).Vm.smooth.phasetimes  = s(5).Vm.smooth.signal (s(1).Phase.phasetimes);
%s(5).Vm.EEGphasetimes         = s(5).signals (s(1).Phase.phasetimes);

clear k pks locs
%for k=1:size(s(5).Vm.smooth.GammaON, 2)
  % [s(5).Vm.peakVgamma_pks (k) s(5).Vm.peakVgamma_locs (k)]=...
  %     findpeak (s(5).Vm.smooth.GammaON
%end

clear threshold
disp('Done.')  