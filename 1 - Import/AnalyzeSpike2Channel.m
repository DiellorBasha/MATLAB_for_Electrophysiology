% Add path address

cedpath = 'C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\1 - Import\CEDMATLAB\CEDS64ML';
addpath( cedpath );
CEDS64LoadLib( cedpath );


% Open a file
fhand1 = CEDS64Open( 'I:\1. Recordings\Examples\Cat\Cocotte Day9S1a.smrx',1);
if (fhand1 <= 0); unloadlibrary ceds64int; return; end

% get waveform data from channel ch
ch=24;
maxTimeTicks = CEDS64ChanMaxTime( fhand1, ch )+1; % +1 so the read gets the last point as reads up to

[ fRead, fVals4] = CEDS64ReadMarkers( fhand1, ch, 200000000, 0, -1);

[ fRead, fVals4, fTime ] = CEDS64ReadWaveF( fhand1, ch, 200000000, 0, maxTimeTicks );


Blue = downsample (fVals4, 200);
time = 1:length (mPFC);
Fs=100;


mPFC = double (mPFC);
spinfil = BanpassSpindle;
a = filtfilt (spinfil.Numerator,1,mPFC);

[hi,lo]        = envelope(a,30, 'rms');
difference = hi-lo;
Z=zscore (difference);

Len = 100;
movRMS = dsp.MovingRMS(Len);
y = movRMS(a);

Thresh = Z(Z>=1.96);


Logical    = zeros(length(Z),1);
Logical((Z>1.5)) = 1;
Derivative = diff(Logical);
Derivative = [Derivative; Derivative(1)];

ON         = find (Derivative==1);
ON (:,2)   = ON/Fs;
OFF         = find (Derivative==-1);
OFF (:,2)   = OFF/Fs;
for j = 1:size(ON, 1)
    idx=find(time==ON(j,1));
 if idx>150 && idx<length(time)-150
    ONtimes (1:301,j) = time(idx-150:idx+150);
 end
end

mPFCSpindles = mPFC (ONtimes);
mPFC2 = mPFC;
for k = 1:size (ON, 1)
    mPFC2 (ON(k,1):OFF(k,1)) = NaN;
end


b = filtfilt (SWfil.Numerator,1,mPFC);
bz = zscore (b);

for k = 1:size (ON, 1)
    b (ON(k,1):OFF(k,1)) = NaN;
end



LogicalSW    = zeros(length(bz),1);
LogicalSW((bz>1.96)) = 1;
DerivativeSW = difference(LogicalSW);
DerivativeSW = [DerivativeSW; DerivativeSW(1)];
ONSW         = find (DerivativeSW==1);
OFFSW         = find (DerivativeSW==-1);
DiffONOFF = OFFSW-ONSW;
idxdiff = find (DiffONOFF>8); ONSW = ONSW(idxdiff); OFFSW=OFFSW(idxdiff);

for j = 1:size(ONSW, 1)
    idx=find(time==ONSW(j,1));
 if idx>150 && idx<length(time)-150
    ONSWtimes (1:301,j) = time(idx-150:idx+150);
 end
end

mPFCSW = mPFC (ONSWtimes);

ONSW = ONSW/Fs; OFFSW=OFFSW/Fs;

%% 

% create a new file
fhand2 = CEDS64Create( 'C:\Users\Diellor\Desktop\CCTTE\ExampleFilter.smrx', 32, 2 );
if (fhand2 <= 0); unloadlibrary ceds64int; return; end

tbase = CEDS64TimeBase( fhand1 );
CEDS64TimeBase( fhand1, tbase );

% set the chan divide and ideal rates to be the same as the original file
chandiv = CEDS64ChanDiv( fhand1, 1 );
rate = CEDS64IdealRate( fhand1, 1 );

% create a new real wave channel
CEDS64SetWaveChan( fhand2, 1, chandiv, 9, rate );
[iOk] = CEDS64SetEventChan( fhand1, 39, 2, 3);


% write filtered data to new channel
CEDS64WriteWave( fhand2, 1, fVals, 0 );

ONSWsecs = ONSW/Fs;
[ vi64Tick ] = CEDS64SecsToTicks( fhand2, ONSWsecs );
[iOk] = CEDS64WriteEvents( fhand1, 39, vi64Tick );

CEDS64CloseAll(); % close all the files
unloadlibrary ceds64int; % unload ceds64int.dll



