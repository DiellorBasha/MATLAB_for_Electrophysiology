
%equalize sample sizes in W, N, and R
Wake_Spindle = Wake_Spindle (1:length(Wake_Gamma));
NREM_Spindle = NREM_Spindle (1:length(NREM_Gamma));
REM_Spindle = NREM_Spindle (1:length(NREM_Gamma));

%remove outliers




Gamma_power = [Wake_Gamma;NREM_Gamma;REM_Gamma];
Delta_power = [Wake_Delta;NREM_Delta;REM_Delta];
Spindle_power = [Wake_Spindle;NREM_Spindle;REM_Spindle];
State = [repmat({'Wake'}, numel(Wake_Gamma),1); repmat({'NREM'}, numel(NREM_Gamma),1); repmat({'REM'}, numel(REM_Gamma),1)];
Cat = repmat ({'Neko'}, numel(State),1);



T = table (Cat, State, Gamma_power, Delta_power, Spindle_power);
Tclean = rmoutliers(T, 'DataVariable', 'Gamma_power');

figure (1)
subplot (2,1,1)
gscatter(T.Delta_power,T.Gamma_power,T.State)
subplot (2,1,2)
gscatter(T.Spindle_power,T.Gamma_power,T.State)