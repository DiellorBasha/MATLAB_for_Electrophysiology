
g = figure('units','normalized','outerposition',[0 0 1 1]);
PlotIO
jpgsave   = fullfile (newDirectory,strcat (erase (theFiles(sh).name, '.smr'),'_IO.jpg'));
saveas(g,jpgsave)
close
clear g
g= figure('units','normalized','outerposition',[0 0 1 1]);
PlotIO
newFigName   = strcat (erase (theFiles(sh).name, '.smr'), '_IO.fig');
figsave= fullfile (newDirectory, newFigName);
savefig (g, figsave);
close
clear g