[row col] = find (Delta=>0.2


x = Delta'; 
y = Gamma';
myfit = fittype('a + b*(log(x))','Robust', 'LAR',...
'dependent',{'y'},'independent',{'x'},...
'coefficients',{'a','b'});
curvefit = fit(x',y',myfit);
plot (curvefit, x, y)

clf
xint = linspace(min(Gamma),max(Gamma),2*length(Gamma));
CIF = predint(GammaSigmaFit,xint,0.95,'Functional');
CIO = predint(GammaSigmaFit,xint,0.95,'obs');
h1 = plot(GammaSigmaFit)
set (h1, 'LineWidth', 2)
h1.Color = 'k'
hold on
h = gscatter (T.Gamma_power (T.Cat=='Titefille'), T.Spindle_power(T.Cat=='Titefille'), T.State(T.Cat=='Titefille'), 'rgb')
uistack (h(2),'top')
h(2).Color = [0 1 1];
h(1).Color = [0 1 0];
h(3).Color = [0 0 1];
%plot(xint,CIF,':b', 'LineWidth', 1)
plot(xint,CIO,':g', 'LineWidth', 1)