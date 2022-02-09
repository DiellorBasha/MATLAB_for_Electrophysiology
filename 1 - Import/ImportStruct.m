myFolder = 'F:\1 DATA\Matlab scripts\6 -Data'; % Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myFolder)
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder);

  uiwait(warndlg(errorMessage));
  return;
end

% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myFolder, '*.smr'); % Change to whatever pattern you need.
theFiles = dir(filePattern); clear filePattern; 
prompt = 'What is file row number?';
sh = input (prompt)

% prompt = 'What is IO file row number?';
% sh1=input(prompt);
% if isempty(sh1)
%     clear sh1;
% end


%% 
tic
fn = fullfile(theFiles(sh).folder, theFiles(sh).name);
CheckFilters; d=getspike2 (fn, 'all'); %import data from Spike2 

    Fs=d(1).Fs;
    time = [1:length(d(1).wv)].';

    for k=1:size(d,2)   
s(k).channel = d(k).title;
s(k).signals  =d(k).wv;
    end
    
  clear d a 
  
  
%   s(10).channel = s(3).channel;
% s(10).signals = s(3).signals;
% s(3).channel = s(4).channel;
% s(3).signals = s(4).signals;
% s(4).channel = s(5).channel;
% s(4).signals = s(5).signals;