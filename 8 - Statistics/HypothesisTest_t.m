% 'T.State=nominal(T.State);


[h,sig,ci] = ttest2(T.Gamma_power(T.State=='Wake'),T.Gamma_power(T.State=='NREM'))


if h==1
    disp('Null hypothesis is rejected')
else
    disp ('Null hypothesis is accepted')
end



boxplot(T.Gamma_power(T.State=='Wake'),T.Gamma_power(T.State=='NREM'))
h = gca;
h.XTick = [1 2];
h.XTickLabel = {'January','February'};
xlabel('Month')
ylabel('Prices ($0.01)')


[p,t,stats] = anova1(MPG,Origin,'off');
[p,t,stats] =anova1(T.Gamma_power, T.State);

