%%
Phase(1).name = 'EPSP - Resp';
Phase(2).name = 'EPSP - SO';


Phase(3).name = 'Spike - Resp';
Phase(4).name = 'Spike - SO';

Phase(5).name = 'SWR - Resp';
Phase(6).name = 'SWR - SO';


Phase(1).phases = rad2deg(s(5).EPSP.EPSP_phase.Respiration); 
Phase(2).phases = rad2deg(s(5).EPSP.EPSP_phase.SO); 

Phase(3).phases = rad2deg(s(5).EPSP.Spike_phase.Respiration);  
Phase(4).phases = rad2deg(s(5).EPSP.Spike_phase.SO);  

Phase(5).phases = rad2deg(s(3).downsample.ON.phase.SO);  
Phase(6).phases = rad2deg(s(3).downsample.ON.phase.respiration);  



%% 

nBins2 = 360; % Use different number of bins, resulting in 20 deg bins
h(1) = figure ('Name', 'EPSP/Spikes on SO and Respiration phase', 'units','normalized','outerposition',[0.2 0.2 0.8 0.8]);

clf
for k = 1:6
Phase(k).subAx = subplot(3, 2, k, polaraxes);
Phase(k).obj = CircHist(Phase(k).phases, nBins2, 'parent', Phase(k).subAx);

     %adjust appearance
     
     Phase(k).obj.colorBar = 'k';  % change color of bars
Phase(k).obj.avgAngH.LineStyle = '--'; % make average-angle line dashed
Phase(k).obj.avgAngH.LineWidth = 1; % make average-angle line thinner
Phase(k).obj.colorAvgAng = [.5 .5 .5]; % change average-angle line color
% remove offset between bars and plot-center
rl = rlim; % get current limits
Phase(k).obj.setRLim([0, rl(2)]); % set lower limit to 0
% draw circle at r == 0.5 (where r == 1 would be the outer plot edge)
rl = rlim;
Phase(k).obj.drawCirc((rl(2) - rl(1)) /2, '--b', 'LineWidth', 2)
Phase(k).obj.scaleBarSide = 'right'; % draw rho-axis on the right side of the plot
Phase(k).obj.polarAxs.ThetaZeroLocation = 'right'; % rotate the plot to have 0° on the right side
Phase(k).obj.setThetaLabel(Phase(k).name, 'bottomleft'); % add label
% draw resultant vector r as arrow
delete(Phase(k).obj.rH)
Phase(k).obj.drawArrow(Phase(k).obj.avgAng, Phase(k).obj.r * range(rl), 'HeadWidth', 10, 'LineWidth', 2, 'Color', 'r')
% Change theta- and rho-axis ticks
Phase(k).obj.polarAxs.ThetaAxis.MinorTickValues = []; % remove dotted tick-lines
thetaticks(0:90:360); % change major ticks
rticks(0:4:20); % change rho-axis tick-steps
Phase(k).obj.drawScale; % update scale bar    

end
