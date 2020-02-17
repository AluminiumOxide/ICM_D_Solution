
filename = 'T_timepass.csv';
delimiter = ',';
startRow = 2;

formatSpec = '%q%q%q%q%q%q%q%q%q%q%q%[^\n\r]';

fileID = fopen(filename,'r');

dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');

fclose(fileID);

raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = mat2cell(dataArray{col}, ones(length(dataArray{col}), 1));
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));

for col=[1,5,6,8,9,10,11]
    % ������Ԫ�������е��ı�ת��Ϊ��ֵ���ѽ�����ֵ�ı��滻Ϊ NaN��
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % ����������ʽ�Լ�Ⲣɾ������ֵǰ׺�ͺ�׺��
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData(row), regexstr, 'names');
            numbers = result.numbers;
            
            % �ڷ�ǧλλ���м�⵽���š�
            invalidThousandsSeparator = false;
            if numbers.contains(',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'))
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % ����ֵ�ı�ת��Ϊ��ֵ��
            if ~invalidThousandsSeparator
                numbers = textscan(char(strrep(numbers, ',', '')), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch
            raw{row, col} = rawData{row};
        end
    end
end

rawNumericColumns = raw(:, [1,5,6,8,9,10,11]);
rawStringColumns = string(raw(:, [2,3,4,7]));

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); 
rawNumericColumns(R) = {NaN}; 

for catIdx = [1,2,3,4]
    idx = (rawStringColumns(:, catIdx) == "<undefined>");
    rawStringColumns(idx, catIdx) = "";
end

Ttimepass = table;
Ttimepass.MatchID = cell2mat(rawNumericColumns(:, 1));
Ttimepass.TeamID = categorical(rawStringColumns(:, 1));
Ttimepass.OriginPlayerID = categorical(rawStringColumns(:, 2));
Ttimepass.DestinationPlayerID = categorical(rawStringColumns(:, 3));
Ttimepass.MatchPeriod = cell2mat(rawNumericColumns(:, 2));
Ttimepass.EventTime = cell2mat(rawNumericColumns(:, 3));
Ttimepass.EventSubType = categorical(rawStringColumns(:, 4));
Ttimepass.EventOrigin_x = cell2mat(rawNumericColumns(:, 4));
Ttimepass.EventOrigin_y = cell2mat(rawNumericColumns(:, 5));
Ttimepass.EventDestination_x = cell2mat(rawNumericColumns(:, 6));
Ttimepass.EventDestination_y = cell2mat(rawNumericColumns(:, 7));

clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp rawNumericColumns rawStringColumns R catIdx idx;