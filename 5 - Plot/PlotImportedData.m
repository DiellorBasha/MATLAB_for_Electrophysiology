
f=figure (1);
EEG = s(1).signals;
mPFC = s(2).signals;
CA1 = s(3).signals;
Intra = s(5).signals;


a1=subplot (211);
plot (time/Fs, Intra, 'Color', [0 0.5 0]);
hold on
%plot (time(IntraSpike)/Fs, a-65, 'o')
ylabel ('mV') 
xlim ([1 10])
a2=subplot (212);
plot (time/Fs, EEG, 'r')
hold on
plot (time/Fs, CA1+0.5, 'b')
plot (time/Fs, mPFC + 2, 'Color', [0.5 0 0])
%plot (time/Fs, EEGPhase+3, 'r')

xlim ([1 10])
xlabel ('Time (s)')
ylabel ('mV')
linkaxes ([a1 a2], 'x')