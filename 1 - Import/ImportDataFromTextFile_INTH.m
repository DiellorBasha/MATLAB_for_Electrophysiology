MyFolderInfo = dir ('E:\2. Analysis\1. Titefille');
delimiter = '\t';
startRow = 2;

%Read columns of data as strings:
formatSpec = '%q%q%[^\n\r]';



%% 
nfiles = 8;

for k = 3:nfiles
    f = fullfile ('E:\2. Analysis\1. Titefille', MyFolderInfo(k).name, 'GammaWakeINTH.txt' );
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

        Gammas{1,k} = cell2mat(raw); %% Create output variable

clearvars dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;
end


%% Split into Wake, NREM, REM

Gammas{1,1} = 'All';
Gammas{2,1} = 'Wake';
Gammas{3,1} = 'NREM';
Gammas{4,1} = 'REM';
        
for k = 3:nfiles
    [row, col] = find(isnan(Gammas{1,k}(1:end,1)));
        Gammas{2,k} = Gammas{1,k}(1:row(1),2);
        Gammas{3,k} = Gammas{1,k}(row(1):row(2),2);
        Gammas{4,k} = Gammas{1,k}(row(2):end,2);
    clear row col
end

WakeCell = Gammas(2,3:nfiles); WakeCell = reshape(WakeCell, [nfiles-2, 1]); Wake_Gamma = cell2mat (WakeCell);
NREMCell = Gammas(3,3:nfiles); NREMCell = reshape(NREMCell, [nfiles-2, 1]); NREM_Gamma = cell2mat (NREMCell);
REMCell = Gammas(4,3:nfiles);  REMCell = reshape(REMCell, [nfiles-2, 1]); REM_Gamma = cell2mat (REMCell);

%Remove zeros
Wake_Gamma( all(~Wake_Gamma,2), : ) = [];
NREM_Gamma( all(~NREM_Gamma,2), : ) = [];
REM_Gamma( all(~REM_Gamma,2), : ) = [];


%% 


lngth = size(teti, 1)/3;
wake = teti (1:lngth, :);
nrem = teti (lngth+1:lngth*2, :);
rem  = teti (lngth*2+1:lngth*3, :);

frequency = 0:0.1953:50;
frequency = frequency (1:256);
figure (1)
shadedErrorBar(frequency,wake.',{@mean,@std}); 
set(gca, 'YScale', 'log')
figure (2)
shadedErrorBar(frequency,nrem.',{@mean,@std}); 
set(gca, 'YScale', 'log')
figure (3)
shadedErrorBar(frequency,rem.',{@mean,@std}); 
set(gca, 'YScale', 'log')