
myPath = 'E:\2. Analysis\0. Neko';
MyFolderInfo = dir (myPath);


nfiles = [3:8];
clear Gammas
for k = nfiles
    f = fullfile (myPath,MyFolderInfo(k).name, 'GammaSD_wake.txt' );%MyFolderInfo(k).name, 
    f1 = fullfile (myPath,MyFolderInfo(k).name, 'GammaSD_NREM.txt' );   %MyFolderInfo(k).name,
    f2 = fullfile (myPath, MyFolderInfo(k).name,'GammaSD_REM.txt' ); %MyFolderInfo(k).name, 
% 
Gammas{1,k}=importfile (f);
Gammas{2,k}=importfile (f1);
Gammas{3,k}=importfile (f2);

end


Gammas{1,1} = 'Wake';
Gammas{2,1} = 'NREM';
Gammas{3,1} = 'REM';
        Gammas1 = Gammas;
       
clear WakeCell NREMCell REMCell Wake_Gamma NREM_Gamma REM_Gamma
WakeCell = Gammas(1,nfiles); 
columns = size(WakeCell,2);
WakeCell = reshape(WakeCell, [columns, 1]); Wake_Gamma = cell2mat (WakeCell);

NREMCell = Gammas(2,nfiles);
columns = size(NREMCell,2); NREMCell = reshape(NREMCell, [columns, 1]); NREM_Gamma = cell2mat (NREMCell);

REMCell = Gammas(3,nfiles);
columns = size(REMCell,2);  REMCell = reshape(REMCell, [columns, 1]); REM_Gamma = cell2mat (REMCell);

Wake_Gamma = Wake_Gamma(:,2); NREM_Gamma = NREM_Gamma(:,2); REM_Gamma = REM_Gamma(:,2); 
%Table prep
Gamma_SD = [Wake_Gamma;NREM_Gamma;REM_Gamma];

clear State Cat
State = [repmat({'Wake'}, numel(Wake_Gamma),1); repmat({'NREM'}, numel(NREM_Gamma),1); repmat({'REM'}, numel(REM_Gamma),1)];
Cat = repmat ({'Neko'}, numel(State),1);


clear T
T = table (Cat, State, Gamma_SD);
% Tclean = rmoutliers(T, 'DataVariable', 'Gamma_power');
anova1 (T.Gamma_SD,  T.State)