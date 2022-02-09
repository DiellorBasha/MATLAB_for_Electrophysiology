
edges = [-pi:pi/16:pi];
[N, edges1, bin] = histcounts (s(1).Phase.phase,edges);
 boxplot (s(5).signals, bin,...
     'Widths', 0.8,...
      'Symbol', '.')

 
 

a=unique (bin);
idx={};
for k = 1:size (a,1)
    idx {k} = find (bin==a(k));
end

for k = 1:size (idx,2)
  idx{2,k} = s(5).signals (idx{1,k});
  idx{3,k} = mean (idx{2,k});
  idx{4,k}= std (idx{2,4});
end
hold on
PhaseVm = cell2mat (idx(3,:)); stdPhaseVm = cell2mat (idx(4,:));
plot (unique(bin), PhaseVm, 'k', 'LineWidth', 2)

%plot (edges(1:end-1), PhaseVm + stdPhaseVm, 'k--')
%plot (edges(1:end-1), PhaseVm - stdPhaseVm, 'k--')
xlabel ('EEG Phase (radians)')
ylabel ('Vm')
labels = unique (bin); 
xticks([labels(1) labels(end/2) labels(end)])
xticklabels({'-pi','0','pi'})

txt = ('ON');
txt2 = ('OFF');

text (labels(1), max(PhaseVm)+10, txt2);
text (labels(end/2), max(PhaseVm)+10, txt);
text (labels(end), max(PhaseVm)+10, txt2);
title ('EEG Phase versus Vm')
