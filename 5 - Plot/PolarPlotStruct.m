
RipplePhase = s(3).ds200.ripplephase.ON.phases(:,1);

polarhistogram (s(3).ds200.ripplephase.ON.phases(:,1),...
    30, 'Normalization', 'probability', 'FaceColor', [0 0 1],...
    'FaceAlpha', 0.2, 'EdgeColor', 'none')
 
hold on

 r = circ_r(RipplePhase);
 phi = circ_mean(RipplePhase);
polarplot ([0 phi],[0 r], 'r', 'LineWidth', 2)

legend('CA1 Ripple Probability')
pax=gca;
pax.ThetaAxisUnits='radians'
pax.GridLineStyle= '--'
pax.ThetaLim = [-pi pi]
pax.ThetaZeroLocation = 'top'
text(0,0.1,'UP','Fontsize', 14)
text(pi,0.1,'DOWN','Fontsize', 14)
 total_ripple_count=numel(RipplePhase);

title ('CA1 ripple probability versus EEG phase (radians)')


