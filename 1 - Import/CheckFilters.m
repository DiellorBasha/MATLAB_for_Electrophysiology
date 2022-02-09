if exist ('lpfil', 'var') ==0
    disp ('Loading filters...')
 lpfil=lowpass; % Import high pass filter >500 Hz
else 
     disp('Lowpass filter 3 Hz already loaded...')
 
end 
    
if exist ('ripfil', 'var') ==0
  disp ('Loading filters...')
 ripfil=ripplefilter; % Import ripplefilter >500 Hz
else 
     disp('Ripple filter 100-300 Hz already loaded...')
end

if exist ('gamfil', 'var') ==0
  disp ('Loading filters...')
 gamfil=gammafilter; % Import ripplefilter >500 Hz
else 
     disp('Gamma filter 60-100 Hz already loaded...')
end


if exist ('EPSPfil', 'var') ==0
  disp ('Loading filters...')
 EPSPfil=EPSPfilter; % Import ripplefilter >500 Hz
else 
     disp('EPSP filter already loaded...')
end


if exist ('ripfilter1k', 'var') ==0
  disp ('Loading filters...')
ripfilter1k=ripfil1k; % Import ripplefilter >500 Hz
else 
     disp('Ripple filter for Fs = 1000 Hz filter already loaded...')
end


if exist ('filterweights', 'var') ==0
  disp ('Loading filters...')
filterweights=lowpass_EEG; % Import ripplefilter >500 Hz
else 
     disp('Lowpass 100 Hz already loaded...')
end


if exist ('gamfil1k', 'var') ==0
  disp ('Loading filters...')
gamfil1k=gammafilter1k;; % Import ripplefilter >500 Hz
else 
     disp('Gamma filter for Fs = 1000 Hz already loaded...')
end



if exist ('gamfil1k', 'var') ==0
  disp ('Loading filters...')
gamfil1k=gammafilter1k-2; % Import ripplefilter >500 Hz
else 
     disp('Gamma filter for Fs = 1000 Hz already loaded...')
end



if exist ('gamfil500', 'var') ==0
  disp ('Loading filters...')
gamfil500=gammafilter500Hz; % Import ripplefilter >500 Hz
else 
     disp('Gamma filter for Fs = 1000 Hz already loaded...')
end

