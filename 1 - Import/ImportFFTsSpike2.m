MyFolderInfo = dir ('E:\1. Recordings\3. Garfille\1. Spike2');
delimiter = '\t';
startRow = 2;

%Read columns of data as strings:
formatSpec = '%q%q%[^\n\r]';



%% 


for k = 3:26
f = fullfile ('E:\1. Recordings\3. Garfille\1. Spike2', MyFolderInfo(k).name, 'Gamma.txt' );
fid = fopen(f);
dataArray = textscan(fid, formatSpec, 'Delimiter', delimiter, 'HeaderLines' ,startRow-1, 'ReturnOnError', false);
%  ttt{1,k} = textscan (fid, '%f %s', 'Delimiter', ' '); % works with FFTs
 fclose (fid);
 ttt{1,k} = importdata(f);
end

%% %% Convert the contents of columns containing numeric strings to numbers.
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

%% %% Replace non-numeric cells with NaN
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells

%% Create output variable
Gamma = cell2mat(raw);
%% 



for k=3:26
    tet {1,k} = ttt {1,k}{1,1};
    teti (1:size(tet{1,3}, 1),k-2) = tet{1,k};
end


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