clear 
clc
[~, ~, raw] = xlsread('S_AttackAndSpeed.xlsx','Sheet1','A2:K23430');
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
stringVectors = string(raw(:,[2,3,4,5,7]));
stringVectors(ismissing(stringVectors)) = '';
raw = raw(:,[1,6,8,9,10,11]);

R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw);
raw(R) = {NaN};

data = reshape([raw{:}],size(raw));

SAttackAndSpeed = table;

SAttackAndSpeed.MatchID = data(:,1);
SAttackAndSpeed.TeamID = categorical(stringVectors(:,1));
SAttackAndSpeed.OriginPlayerID = categorical(stringVectors(:,2));
SAttackAndSpeed.DestinationPlayerID = cellstr(stringVectors(:,3));
SAttackAndSpeed.MatchPeriod = categorical(stringVectors(:,4));
SAttackAndSpeed.EventTime = data(:,2);
SAttackAndSpeed.EventSubType = categorical(stringVectors(:,5));
SAttackAndSpeed.EventOrigin_x = data(:,3);
SAttackAndSpeed.EventOrigin_y = data(:,4);
SAttackAndSpeed.EventDestination_x = data(:,5);
SAttackAndSpeed.EventDestination_y = data(:,6);

clearvars data raw stringVectors R;



index0 = find(SAttackAndSpeed.TeamID=={'Huskies'});
SAttackAndSpeed = SAttackAndSpeed(index0,:);
SAttackAndSpeed = sortrows(SAttackAndSpeed,[3]);
playerful = table;
playerful.ID = SAttackAndSpeed.OriginPlayerID;
playerful.Attack = SAttackAndSpeed.EventDestination_x - SAttackAndSpeed.EventOrigin_x;
playerful.strengh = sqrt((SAttackAndSpeed.EventDestination_x - SAttackAndSpeed.EventOrigin_x).^2+(SAttackAndSpeed.EventDestination_y - SAttackAndSpeed.EventOrigin_y).^2);

player = table;
player.ID = unique(playerful.ID);
index0 = find(playerful.Attack>=0);
    for num=1:size(player,1)
        index1 = find(playerful.ID == {char(player.ID(num))});
        index2 = intersect(index1,index0);    
        index3 = setdiff(index1,index2);     
        zeroup = playerful(index2,:);
        zerodown = playerful(index3,:);  
        
        player.ATK(num) = sum(zeroup.Attack)/size(index2,1);
        player.ATKnum(num) = size(index2,1);
        player.DEF(num) = -1*sum(zerodown.Attack)/size(index3,1);
        player.DEFnum(num) = size(index3,1);
        player.Strengh(num) = sum(playerful.strengh(index1,:))/size(index1,1);
        player.DEFnum(num) = size(index1,1);
    end
    
writetable(player,'.\out\S_player.csv','Delimiter',',');
    
    
    
    

