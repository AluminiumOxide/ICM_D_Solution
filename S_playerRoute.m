clear
clc
[~, ~, raw] = xlsread('S_playerRoute.xlsx','1H','A2:L736');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[2,3,4,5,7,8]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,6,9,10,11,12]);

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw);
raw(R) = {NaN};

data = reshape([raw{:}],size(raw));

SplayerRoute = table;

SplayerRoute.MatchID = data(:,1);
SplayerRoute.TeamID = categorical(stringVectors(:,1));
SplayerRoute.OriginPlayerID = categorical(stringVectors(:,2));
SplayerRoute.DestinationPlayerID = cellstr(stringVectors(:,3));
SplayerRoute.MatchPeriod = categorical(stringVectors(:,4));
SplayerRoute.EventTime = data(:,2);
SplayerRoute.EventType = categorical(stringVectors(:,5));
SplayerRoute.EventSubType = categorical(stringVectors(:,6));
SplayerRoute.EventOrigin_x = data(:,3);
SplayerRoute.EventOrigin_y = data(:,4);
SplayerRoute.EventDestination_x = data(:,5);
SplayerRoute.EventDestination_y = data(:,6);

clearvars data raw stringVectors R;

time = [0 3600];
sortRoute = sortrows(SplayerRoute,[3,6]);
player = sortRoute.OriginPlayerID;
player = unique(player);
number = size(player);
indexsum = 0;

figure('NumberTitle', 'off', 'Name', 'player route tracing');
for num=1:number(1)
   index = find(sortRoute.OriginPlayerID==player(num));
    playerAction = sortRoute(index,:);
    if num>=1&&num<=4
        plotcolor = 'mo';
    elseif num>=5&&num<=7
        plotcolor = 'bo';
    elseif num>=8&&num<=8
        plotcolor = 'ko';
    elseif num>=9&&num<=11
        plotcolor = 'go';
    else
        plotcolor = 'ro';
    end

    sub1 = ceil(sqrt(number(1)));
    sub2 = ceil(sqrt(number(1)));
    sub3 = num;
    subplot(sub1,sub2,sub3),plot(playerAction.EventOrigin_x,playerAction.EventOrigin_y,plotcolor);
    hold on
    subplot(sub1,sub2,sub3),plot(playerAction.EventOrigin_x,playerAction.EventOrigin_y,'k-');
    set(gca,'xtick',[],'xticklabel',[])
    set(gca,'ytick',[],'yticklabel',[])
    xlabel('<Huskies<<<  -  >>>Opposite>');
    ylabel('|left| - |right| ');
    set(gca,'fontsize',12);
    name = char(player(num));
    name = strrep(name,'_','-');
    subplot(sub1,sub2,sub3),title(name);
    
    

    hold on;
end

