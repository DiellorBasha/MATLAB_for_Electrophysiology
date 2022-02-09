MyFolderInfo = dir ('E:\2. Analysis\0. Neko');
delimiter = '\t';
startRow = 2;

%Read columns of data as strings:
formatSpec = '%q%q%[^\n\r]';



%% 
nfiles = 5;

for k = 3:nfiles
    f = fullfile ('E:\2. Analysis\0. Neko', MyFolderInfo(k).name, 'Delta.txt' );
        fid = fopen(f);
        dataArray = textscan(fid, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%  ttt{1,k} = textscan (fid, '%f %s', 'Delimiter', ' '); % works with FFTs
        fclose (fid);
% Convert the contents of columns containing numeric strings to numbers.
% Replace non-numeric strings with NaN.
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,2]
    % Converts strings in the input cell array to numbers. Replaced non-numeric
    % strings with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1);
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',');
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(thousandsRegExp, ',', 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric strings to numbers.
            if ~invalidThousandsSeparator;
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end

% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

        Deltas{1,k} = cell2mat(raw); %% Create output variable

clearvars dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
end


%% Split into Wake, NREM, REM

Deltas{1,1} = 'All';
Deltas{2,1} = 'Wake';
Deltas{3,1} = 'NREM';
Deltas{4,1} = 'REM';
        
for k = 3:nfiles
    [row, col] = find(isnan(Deltas{1,k}(1:end,1)));
        Deltas{2,k} = Deltas{1,k}(1:row(1),2);
        Deltas{3,k} = Deltas{1,k}(row(1):row(2),2);
        Deltas{4,k} = Deltas{1,k}(row(2):end,2);
    clear row col
end

clear WakeCell NREMCell REMCell
WakeCell = Deltas(2,3:nfiles); WakeCell = reshape(WakeCell, [nfiles-2, 1]); Wake_Delta = cell2mat (WakeCell);
NREMCell = Deltas(3,3:nfiles); NREMCell = reshape(NREMCell, [nfiles-2, 1]); NREM_Delta = cell2mat (NREMCell);
REMCell = Deltas(4,3:nfiles);  REMCell = reshape(REMCell, [nfiles-2, 1]); REM_Delta = cell2mat (REMCell);

%Remove zeros
Wake_Delta( all(~Wake_Delta,2), : ) = [];
NREM_Delta( all(~NREM_Delta,2), : ) = [];
REM_Delta( all(~REM_Delta,2), : ) = [];

clear WakeCell startRow REMCell NREMCell nfiles MyFolderInfo k formatSpec fid f delimiter
