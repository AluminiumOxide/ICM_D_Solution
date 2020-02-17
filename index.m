clear 
clc

while 1
    disp('welcome to our team');
    disp('input 1:run pagerank model');
    disp('input 2:run All      Team event statistics');
    disp('input 3:run Separate Team event statistics');
    disp('input 4:run player route tracing');
    disp('input 5:Processing player data');
    disp('input 6:run pass event time stream');
    disp('input 9:quit program');
    num = input('please choose model you want to run:');
    
    if num==1
        run('F_pageRank.m');
        disp('    player data has print to .\out\F_pageRank_out.csv');
        disp('    because after we analy player in other software');
        disp('    These data is not the final reference data');
    elseif num==2
        run('F_map.m');
    elseif num==3
        run('F_mapAuto.m');
    elseif num==4
        run('S_playerRoute.m');
    elseif num==5
        run('S_AttackAndSpeed.m');
        disp('    player data has print to .\out\S_player.csv');
        disp('    because after we analy player in other software');
        disp('    These data is not the final reference data');
    elseif num==6
        run('T_timepass.m');
    elseif num==9
        break
    end
end
disp('Thanks viewing our team program');
clear