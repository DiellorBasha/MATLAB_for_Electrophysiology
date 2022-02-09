deltaBand = [1 4];
thetaBand = [5 8];

FsDS = s(1).downsample.Fs;
numbwind=floor(length(s(1).downsample.signal)/FsDS)-4;
deltapower(1:numbwind+4,1:2)=nan; 
thetapower(1:numbwind+4,1:2)=nan; 

ydata = s(1).downsample.signal;
 ch=1
    xtemp(:,1)=ydata(:,ch);
 
    for w=1:numbwind
        xwind(:,1)=xtemp((w-1)*FsDS+1:(w+4)*FsDS,1);
    deltapower(w+2,ch)=bandpower(xwind, FsDS, deltaBand);
   
    clear xwind
    end
   
    clear xtemp ydata
    
    ydata = s(1).downsample.signal; numbwind=floor(length(s(3).downsample.signal)/FsDS)-4;
    
ch=1;
    xtemp(:,1)=ydata(:,ch);
 
    for w=1:numbwind
        xwind(:,1)=xtemp((w-1)*FsDS+1:(w+4)*FsDS,1);
   thetapower(w+2,ch)=bandpower(xwind, FsDS, thetaBand);
   
    clear xwind
    end
    
    figure (1)
    subplot (211)
    plot (thetapower, 'b', 'Linewidth', 2)
    hold on
    plot (deltapower+0.01, 'r', 'Linewidth', 2)
    subplot (212)
    plot (deltapower./thetapower, 'k');
  
    
    a=deltapower.^2;
    plot (a)
    
    a(isnan(a))=[];
    [hi, lo] = envelope (a, 10, 'rms');
    plot (hi);
    
    
    
    
    %% 
    
    threshold                   = mean (s(k).Gamma.envelope)+std(s(k).Gamma.envelope);
    s(k).Gamma.logical    = zeros(length(s(k).Gamma.envelope),1);
    s(k).Gamma.logical((s(k).Gamma.envelope>threshold)) = 1;
    s(k).Gamma.derivative = diff(s(k).Gamma.logical);
    s(k).Gamma.derivative = [s(k).Gamma.derivative; s(k).Gamma.derivative(1)];

    s(k).Gamma.ON         = find (s(k).Gamma.derivative==1);
    s(k).Gamma.ON (:,2)   = s(k).Gamma.ON/Fs;
    
    
    
    
    
    
     % Get bandpower
 disp('Filtering for gamma...') 
    for k=1:3
s(k).Gamma.signal     = 'Bandpassed signal (30-100 Hz)';
s(k).Gamma.filtered   =  filtfilt (gamfil.Numerator,1,s(k).signals);
s(k).Gamma.squared    = (s(k).Gamma.filtered).^2; 
[s(k).Gamma.hi,...
s(k).Gamma.lo]        = envelope(s(k).Gamma.squared,1200, 'rms');
s(k).Gamma.envelope   = s(k).Gamma.hi-s(k).Gamma.lo;
 
threshold                   = mean (s(k).Gamma.envelope)+std(s(k).Gamma.envelope);
[s(k).Gamma.pks ,...
s(k).Gamma.locs]      = findpeaks(s(k).Gamma.envelope,'MinPeakDistance',0.3*Fs, 'MinPeakHeight', threshold ); 
 
s(k).Gamma.logical    = zeros(length(s(k).Gamma.envelope),1);
s(k).Gamma.logical((s(k).Gamma.envelope>threshold)) = 1;
s(k).Gamma.derivative = diff(s(k).Gamma.logical);
s(k).Gamma.derivative = [s(k).Gamma.derivative; s(k).Gamma.derivative(1)];

s(k).Gamma.ON         = find (s(k).Gamma.derivative==1);
s(k).Gamma.ON (:,2)   = s(k).Gamma.ON/Fs;

for j = 1:size(s(k).Gamma.ON, 1)
    idx=find(time==s(k).Gamma.ON(j,1));
 if idx>15000 && idx<length(time)-15000
    s(k).Gamma.ONtimes (1:30001,j) = time(idx-15000:idx+15000);
 end
end

s(k).Gamma.ONtimes=s(k).Gamma.ONtimes (:,find(sum(s(k).Gamma.ONtimes,1)));

s(k).Gamma.OFF        = find (s(k).Gamma.derivative==-1); 
s(k).Gamma.OFF (:,2)  = s(k).Gamma.OFF/Fs;

for j = 1:size(s(k).Gamma.OFF, 1)
    idx=find(time==s(k).Gamma.OFF(j,1));
 if idx>15000 && idx<length(time)-15000
    s(k).Gamma.OFFtimes (1:30001,j) = time(idx-15000:idx+15000);
 end
end

 s(k).Gamma.OFFtimes=s(k).Gamma.OFFtimes (:,find(sum(s(k).Gamma.OFFtimes,1)));

    end