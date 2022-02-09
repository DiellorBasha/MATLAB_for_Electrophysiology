
% State_GammaFR aggregates data from .txt files containing gamma power and firing
% rate data, categorized according to wake, NREM and REM states. Gamma power,firing rate and
% states are computed in Spike2 and saved in .txt files. The routine
% plots a scatterplot of gamma power versus firing rates, color-coded
% according to state and applies linear fitting according to state. 
% Required: gamma power, firing rate and states in .txt
            % file, computed in Spike2, 
%Subroutines: importfile

myPath = 'G:\2. Analysis\2. Cocotte';
MyFolderInfo = dir (myPath);

nfiles = [1:18];
clear Gammas
for k = nfiles
    f = fullfile (myPath,MyFolderInfo(k).name, 'Gamma_FR.txt' );%MyFolderInfo(k).name, 
%     f1 = fullfile (myPath,MyFolderInfo(k).name, 'GammaFR_NREM.txt' );   %MyFolderInfo(k).name,
%     f2 = fullfile (myPath, MyFolderInfo(k).name,'GammaFR_REM.txt' ); %MyFolderInfo(k).name, 
% 
Gammas{1,k-2}=importfile (f);
% Gammas{2,k-8}=importfile (f1);
% Gammas{3,k-8}=importfile (f2);

end
% 
nfiles = size (Gammas, 2);
for k = 4:5
    SpG (:,k) = Gammas {1,k}(:,2);
end
WakeCell = Gammas(1,1:nfiles); WakeCell = reshape(WakeCell, [nfiles, 1]); Wake = cell2mat (WakeCell);
NREMCell = Gammas(2,1:nfiles); NREMCell = reshape(NREMCell, [nfiles, 1]); NREM = cell2mat (NREMCell);
REMCell = Gammas(3,1:nfiles);  REMCell = reshape(REMCell, [nfiles, 1]); REM = cell2mat (REMCell);

clear Gamma_power

FR = [Wake(:,2); NREM(:,2); REM(:,2)];
Gamma_power = [Wake(:,1); NREM(:,1); REM(:,1)];
State = [repmat({'Wake'}, size(Wake,1),1); repmat({'NREM'}, size(NREM,1),1); repmat({'REM'}, size(REM,1),1)];
T = table (State, Gamma_power, FR);


%% 

c_wake1 = polyfit(Wake1(:,1),Wake1(:,2),1);y_wake1 = polyval(c_wake1,Wake1(:,1));
c_NREM1 = polyfit(NREM1(:,1),NREM1(:,2),1);y_NREM1 = polyval(c_NREM1,NREM1(:,1));
c_REM1 = polyfit(REM1(:,1),REM1(:,2),1);y_REM1 = polyval(c_REM1,REM1(:,1));

figure (1)
    clf
    h=gscatter (Tcc.Gamma_power, Tcc.FR, Tcc.State, 'rgb','x*o')
        NREMhandle = h(1); NREMhandle.Color = [0 1 0];
        REMhandle = h(2); REMhandle.Color = [0 1 1];
        wakehandle = h(3); wakehandle.Color = [0 0 1];
uistack(h(2),'top');
hold on
    plot (Wake1(:,1),y_wake1, 'b--', 'LineWidth', 2)
    plot (NREM1(:,1),y_NREM1, 'g--', 'LineWidth', 2)
    plot (REM1(:,1),y_REM1, 'Color',[0 1 1], 'LineWidth', 2)

Wake1 = [Tcc.Gamma_power(Tcc.State=='Wake') Tcc.FR(Tcc.State=='Wake')];
NREM1 = [Tcc.Gamma_power(Tcc.State=='NREM') Tcc.FR(Tcc.State=='NREM')];
REM1 = [Tcc.Gamma_power(Tcc.State=='REM') Tcc.FR(Tcc.State=='REM')];
clf
clear f
f = fit(NREMc(:,1),NREMc(:,2),'linear');
plot(f,NREMc(:,1), NREMc(:,2))
