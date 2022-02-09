
myFolder = 'C:\Users\admin\OneDrive - Université Laval\6. Code\MATLAB_for_Electrophysiology\6 - Data\New folder';

% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);

  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.smr'); % Change to whatever pattern you need.
theFiles = dir(filePattern);

%fn1= fullfile (theFiles(18).folder, theFiles(18).name);

for sh=1:length(theFiles)

    fn = fullfile(theFiles(sh).folder, theFiles(sh).name);
        d=getspike2 (fn, 'all'); %import data from Spike2 

BatchFilterMASTER


  newDirectory = (erase (fn, '.smr'));
  newFileName  = strcat (erase (theFiles(18).name, '.smr'), '.mat');

  mkdir (newDirectory);

  fnsave = fullfile (newDirectory, newFileName);

  save(fnsave, 's')

end


