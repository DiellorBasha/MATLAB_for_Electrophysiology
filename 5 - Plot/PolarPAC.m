addpath (genpath ('C:\Users\admin\OneDrive - Université Laval\6. Code'))
d=getspike2('C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\6 - Data\AmandeDay4S2-120.smr')
[2 1 17 18 19 20 21]

d(2).wv = smooth (d(2).wv, 1200); 

Resp = d(2).wv;
Re = d(1).wv;
mPFC = d(3).wv;
Motor = d(4).wv;
Somato= d(5).wv;
Supra = d(6).wv;
Marginal = d(7).wv;

for k = 1:2
    d(k).hilbert = hilbert (d(k).wv);
    d(k).angles = angle (d(k).hilbert);
    d(k).mags = (abs(d(k).hilbert)).^2;
    
end


clear N edges bins
[N,edges,bins] = histcounts(d(2).angles,100);
clear bin_means
bin_means = zeros (1,length(N));

clear bin_means
for k = 1:2
    for n = 1:length(N)
        d(k).bin_means(:,n) = mean(d(k).mags(bins==n,:))';
  
    end
end


clf
figure (1)
subplot (211)
polar(edges(1:100), d(1).bin_means)

subplot (212)
for k = 5:6
polar (edges(1:100), d(1).bin_means)
hold on 
polar (edges(1:100), d(k).bin_means)

end

polar (edges(1:100), d(7).bin_means)
polar (edges(1:100), bin_means-bin_stds)


for k = 1:100
    
 a(:,k) = bin_means (k)*(exp(1i*edges(k)))
end
%% 


RespH = hilbert (Resp);
Phase = angle (RespH);
mPFCH = hilbert (mPFC);
Mag = abs (mPFCH);
plot (Phase, Mag, '.')

Phase = Phase (400000:end);
Mag = Mag (400000:end);

clear N edges bins
Magsq = Mag.^2;
[N,edges,bins] = histcounts(Magsq,100);
clear bin_means
bin_means = zeros (1,length(N));

clear bin_means
for n = 1:length(N)
  bin_means(:,n) = mean(Phase(bins==n,:))';
end

histData = bin_means;

clf
CircHist(histData.^2, 'dataType', 'histogram')

CircHist(histData.^2, 'dataType', 'histogram')





