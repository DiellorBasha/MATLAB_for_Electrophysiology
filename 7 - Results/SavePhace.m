%% Make figures and save things
for k = 1:12
 PACs(k).channel = s(k).channel;
PACs(k).PAC = s(k).PAC;
 end
 



disp ('Saving...')
newDirectory = (erase (fn, '.smr'));
newFileName  = strcat (erase (theFiles(sh).name, '.smr'), '.mat'); 
    mkdir (newDirectory);
    fnsave = fullfile (newDirectory, newFileName);
    %MakeRipples
   % s(3).Ripple.Ripples = ripples;
    save(fnsave, 's', '-v7.3')  
     save(fnsave, 'Phase', '-v7.3')  
     save(fnsave, 'PACs', '-v7.3')  
% % 


    disp ('Saving figures...')
    close all
newFigName   = strcat (erase (theFiles(sh).name, '.smr'), '.fig');
figsave= fullfile (newDirectory, newFigName);
 
 PolarRespiration;
 jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Phases.jpg'));
 figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Phases.fig'));
 savefig(h(1),figsave); 
 saveas(h(1),jpgsave)
 
try
h(2) = figure;
SpikeStats;
catch
end

jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_SpikeStats.jpg'));
figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_SpikeStats.fig'));
savefig(h(2),figsave); 
saveas(h(2),jpgsave)

h(3)= figure;
VmDistribution;
jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Vm.jpg'));
figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_Vm.fig'));
savefig(h(3),figsave); 
saveas(h(3),jpgsave)

PolarPAC2;

figsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_PAC.fig'));
jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_PAC.jpg'));
savefig(h(4),figsave);
saveas(h(4),jpgsave)


close (h)


disp(theFiles(sh).name)
disp ('Donedidley')

ClearVariables