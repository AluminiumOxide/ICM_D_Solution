clear
clc
Interval = 15;    
timetick = 1:Interval:3600;
timetick = timetick';
run('T_timepass_impot.m')

Ttimepass = sortrows(Ttimepass,[2,5,6]);
index0 = find(Ttimepass.TeamID=={'Huskies'});
Ttimepass = Ttimepass(index0,:);
clearvars index0
Tround1 = Ttimepass(Ttimepass.MatchPeriod==1 ,:);  
Tround2 = Ttimepass(Ttimepass.MatchPeriod==2 ,:);  

Taction =  unique(Ttimepass.EventSubType);  
Teventnum1=[];
for num1 = 1:3600/Interval
    Tcollect = Tround1((Tround1.EventTime<num1&Tround1.EventTime>=num1-Interval),:);
    for num2 = 1:size(Taction,1)
        Teventnum1(num1,num2) = size(find(Tcollect.EventSubType==Taction(num2)),1);
    end
end
Teventnum1sum = sum(Teventnum1,2);

figure('NumberTitle', 'off', 'Name', 'count time stream');
plot(1:Interval:3600,Teventnum1sum ,'LineWidth',2);
hold on

Teventnum2=[];
for num1 = 1:3600/Interval
    Tcollect = Tround2((Tround2.EventTime<num1&Tround2.EventTime>=num1-Interval),:);
    for num2 = 1:size(Taction,1)
        Teventnum2(num1,num2) = size(find(Tcollect.EventSubType==Taction(num2)),1);
    end
end
Teventnum2sum = sum(Teventnum2,2);
plot(1:Interval:3600,Teventnum2sum,'LineWidth',2);
legend('count1','count2')

xlabel('time');
ylabel('Action count');
xlim([0,3600])
ylim([0,60])
xticks(0:600:3600); 
yticks(0:10:60); 

Teventall = (Teventnum1+Teventnum2)./2;
Teventallsum = (Teventnum1sum+Teventnum2sum)./2;
figure('NumberTitle', 'off', 'Name', 'action separate time stream');
plot(timetick,Teventall,'DisplayName','Teventall','LineWidth',2);
legend(char(Taction(:)))


