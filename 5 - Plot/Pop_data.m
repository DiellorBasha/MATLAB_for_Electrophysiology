
myFolder = 'C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\7 - Results\Intra';
%filePattern = fullfile(myFolder, '*.smr'); % Change to whatever pattern you need.
theFiles2 = dir(myFolder);

for k=3:56
recording = erase(theFiles2(k).name,'.smr');
 fn = fullfile(theFiles2(k).folder, theFiles2(k).name, strcat(recording, '.mat'))
 a(k).recording = recording;     
 a(k).PACs = load (fn) ;  
end

for  ii = [1:3,5]
    pop_data(ii).channel = a(3).PACs.PACs(ii).channel;
end

for  ii = [1:3,5]
for k = [3:33,35:55]
pop_data(ii).respiration(k).recording = a(k).recording
pop_data(ii).respiration(k).respiration = a(k).PACs.PACs(ii).PAC.respiration;
pop_data(ii).SO(k).recording = a(k).recording
pop_data(ii).SO(k).SO = a(k).PACs.PACs(ii).PAC.SO;
 end
end
for  ii = [1:3,5]
pop_data(ii).respiration(1:2) = [];
pop_data(ii).SO(1:2) = [];
end
pop_data(4) = [];
for  ii = 1:4
for k = 1:length(pop_data(1).respiration)
pop_data(ii).resp_means(:,k) = pop_data(ii).respiration(k).respiration.mean.';
pop_data(ii).SO_means(:,k) = pop_data(ii).SO(k).SO.mean.';
pop_data(ii).resp_z(:,k) = zscore (pop_data(ii).resp_means(:,k));
pop_data(ii).SO_z(:,k) = zscore (pop_data(ii).SO_means(:,k));
end
end




figure (1)
clf
mEdges(:,1) = pop_data(1).SO(3).SO.edges(1:end-1).';
ylin = 1.96; xmin = min(mEdges), xmax = max(mEdges); 
for k = 1:4
subplot (4,1,k)
x=mEdges;
y=pop_data(k).resp_z;
shadedErrorBar(x,y.',{@mean,@std},'lineprops','-b','patchSaturation',0.33)
line([xmin,xmax],[ylin,ylin], 'Color','red','LineStyle','--')
title (pop_data(k).channel)
ylim([-2.5 2.5])
end






