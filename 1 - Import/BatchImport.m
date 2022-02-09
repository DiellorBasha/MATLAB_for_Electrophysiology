%ripfil=ripplefilter; gamfil=gammafilter;
clearvars -except ripfil gamfil
d=getspike2('C:\Users\Diellor\Desktop\Matlab scripts\Intra\Data\19', [1 2 3 5 6])
EEG=d(1).wv.'; 
        EEG_gamma=filtfilt(gamfil.Numerator,1,EEG); %run 40-120 Hz bandpass
        EEG_gamma=(EEG_gamma.*EEG_gamma)*100;
            [hi_EEG,lo_EEG] = envelope(EEG_gamma,2000,'rms'); 
            difference_EEG=hi_EEG-lo_EEG; 
            threshold=mean(difference_EEG)+std(difference_EEG);
mPFC=d(2).wv.';
CA1=d(3).wv.';
       CA1_ripplefiltered=filtfilt(ripfil.Numerator,1,CA1); %run 100-300 Hz bandpass
       CA1_ripplefiltered=(CA1_ripplefiltered.*CA1_ripplefiltered)*100; %square and amplif
            [hi_CA1,lo_CA1] = envelope(CA1_ripplefiltered,1200,'rms'); 
            difference_CA1=hi_CA1-lo_CA1; 
    threshold_CA1=mean(difference_CA1)+std(difference_CA1);
Intra=d(4).wv.';
CM=d(5).wv.';
time=([1:length(EEG)]);
Fs=d(1).Fs;
save ('19.mat')

 
    
     