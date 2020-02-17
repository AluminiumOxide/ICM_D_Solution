clear
clc
[~, ~, raw] = xlsread('F_mapAutoFull.xlsx','Sheet1','A2:L59272');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[2,3,4,5,7,8]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,6,9,10,11,12]);

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); 
raw(R) = {NaN}; 

data = reshape([raw{:}],size(raw));

FmapAuto = table;

FmapAuto.MatchID = data(:,1);
FmapAuto.TeamID = categorical(stringVectors(:,1));
FmapAuto.OriginPlayerID = categorical(stringVectors(:,2));
FmapAuto.DestinationPlayerID = cellstr(stringVectors(:,3));
FmapAuto.MatchPeriod = categorical(stringVectors(:,4));
FmapAuto.EventTime = data(:,2);
FmapAuto.EventType = categorical(stringVectors(:,5));
FmapAuto.EventSubType = categorical(stringVectors(:,6));
FmapAuto.EventOrigin_x = data(:,3);
FmapAuto.EventOrigin_y = data(:,4);
FmapAuto.EventDestination_x = data(:,5);
FmapAuto.EventDestination_y = data(:,6);

clearvars data raw stringVectors R;

FmapAuto = sortrows(FmapAuto,[7,8]); 
index0 = find(FmapAuto.TeamID=={'Huskies'});
FmapAuto = FmapAuto(index0,:);
FmapAuto = FmapAuto(FmapAuto.EventType~={'Substitution'} ,:);  % out Substitution,event without position
FmapAutoSize = size(FmapAuto);
EventType = FmapAuto.EventType;
EventTU = unique(EventType);
EventTUSize = size(EventTU);
EventTypeCount = tabulate(EventType); 
EventTypeCount = cell2table(EventTypeCount);
CountNum = EventTypeCount.EventTypeCount2;


figure('NumberTitle', 'off', 'Name', 'Separate Team event statistics');
for num=1:EventTUSize(1)
    index = find(FmapAuto.EventType==EventTU(num));
    playerAction = FmapAuto(index,:);
    figureMap = ones(101);
    
    for num2 = 1:(CountNum(num)-1)
     if figureMap(playerAction.EventOrigin_x(num2)+1,playerAction.EventOrigin_y(num2)+1)<=10
        figureMap(playerAction.EventOrigin_x(num2)+1,playerAction.EventOrigin_y(num2)+1)=figureMap(playerAction.EventOrigin_x(num2)+1,playerAction.EventOrigin_y(num2)+1)+1;
     end

    end
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
    sub1 = floor(sqrt(EventTUSize(1)));
    sub2 = ceil(sqrt(EventTUSize(1)));
    sub3 = num;
    hold on
    subplot(sub1,sub2,sub3),pcolor(figureMap);
   
    
    name = char(EventTU(num));
    subplot(sub1,sub2,sub3),title(name);
    set(gca,'xlim',[0,100])
    xlabel('<left <<< Huskies >>>right>');
    clearvars figureMap
    
end

EventOrigin_x = FmapAuto.EventOrigin_x;
EventOrigin_y = FmapAuto.EventOrigin_y;







