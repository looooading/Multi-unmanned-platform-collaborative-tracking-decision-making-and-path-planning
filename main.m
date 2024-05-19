function [map1, OptimalPath, Path_size] = main(status)
%%% 相关参数初始化

    %YB = {};
    disp(fileread('Marx_Engels_Lenin_ASCIIBanner.txt'));
    map = single(zeros(100,100));

    map(1:100,1:2) = 1;%边框
    map(1:100,99:100) = 1;
    map(1:2,1:100) = 1;
    map(99:100,1:100) = 1;

    map(10:70,48:52) = 1;%中心主干
    map(48:52,10:70) = 1;

    map(75:95,49:51) = 1;
    map(49:51,75:95) = 1;

    map(16:20,34:74) = 1;
    map(34:74,16:20) = 1;

    map(30:34,70:100) = 1;
    map(70:100,30:34) = 1;

    map(40:42,50:90) = 1;
    map(50:90,40:42) = 1;

    map(26:28,60:90) = 1;
    map(60:90,26:28) = 1;

    map(26:36,60:62) = 1;
    map(60:62,26:36) = 1;

    map(36:38,60:82) = 1;
    map(60:82,36:38) = 1;

    map(36:41,80:82) = 1;
    map(80:82,36:41) = 1;


    map1 = single(zeros(100,100));
    
    map1(1:100,1:2) = 1;%边框
    map1(1:100,99:100) = 1;
    map1(1:2,1:100) = 1;
    map1(99:100,1:100) = 1;

    map1(36:64,36:37) = 1;
    map1(36:37,36:64) = 1;

    map1(63:64,36:64) = 1;
    map1(36:64,63:64) = 1;

    map1(40:60,5:6) = 1;
    map1(5:6,40:60) = 1;

    map1(40:41,5:30) = 1;
    map1(5:30,40:41) = 1;

    map1(40:60,29:30) = 1;
    map1(29:30,40:60) = 1;

    map1(59:60,5:30) = 1;
    map1(5:30,59:60) = 1;

    map1(4:32,63:64) = 1;
    map1(63:64,4:32) = 1;

    map1(4:5,63:95) = 1;
    map1(63:95,4:5) = 1;

    map1(4:32,94:95) = 1;
    map1(94:95,4:32) = 1;

    map1(31:32,63:95) = 1;
    map1(63:95,31:32) = 1;

    map1(63:100,40:41) = 1;
    map1(40:41,63:100) = 1;

    map1(63:100,59:60) = 1;
    map1(59:60,63:100) = 1;

    map1(40,30:36) = 1;
    map1(30:36,40) = 1;

    map1(44,20:28) = 1;
    map1(20:28,44) = 1;

    map1(44,11:17) = 1;
    map1(11:17,44) = 1;

    map1(44,7:8) = 1;
    map1(7:8,44) = 1;

    map1(48,18:28) = 1;
    map1(18:28,48) = 1;

    map1(48,6:14) = 1;
    map1(6:14,48) = 1;

    map1(53,10:25) = 1;
    map1(10:25,53) = 1;

    map1(60:63,27) = 1;
    map1(27,60:63) = 1;

    map1(60:63,8) = 1;
    map1(8,60:63) = 1;

    map1(65:86,28) = 1;
    map1(28,65:86) = 1;

    map1(65:73,20) = 1;
    map1(20,65:73) = 1;

    map1(69:90,12:13) = 1;
    map1(12:13,69:90) = 1;

    map1(69:94,24) = 1;
    map1(24,69:94) = 1;

    map1(67:80,16) = 1;
    map1(16,67:80) = 1;

    map1(83:95,16) = 1;
    map1(16,83:95) = 1;

    map1(44:46,38:40) = 1;
    map1(38:40,44:46) = 1;

    map1(52:53,44:45) = 1;
    map1(44:45,52:53) = 1;

    map1(58:59,40:41) = 1;
    map1(40:41,58:59) = 1;

    map1(58,44:54) = 1;
    map1(44:54,58) = 1;

    map1(69,44:60) = 1;
    map1(44:60,69) = 1;

    map1(69:99,48) = 1;
    map1(48,69:99) = 1;

    map1(75,48:60) = 1;
    map1(48:60,75) = 1;

    map1(85,48:60) = 1;
    map1(48:60,85) = 1;

    map1(90,48:60) = 1;
    map1(48:60,90) = 1;

    map1(95,48:60) = 1;
    map1(48:60,95) = 1;

    map1(78:82,54) = 1;
    map1(54,78:82) = 1;

    map1(45:55,45:55) = 1;

    map1(39:41,39:41) = 1;

    map1(58:60,58:60) = 1;


    map1(49:51,36:37) = 0;
    map1(36:37,49:51) = 0;

    map1(40:41,15) = 0;
    map1(15,40:41) = 0;

    map1(40:41,26) = 0;
    map1(26,40:41) = 0;

    map1(40:41,9) = 0;
    map1(9,40:41) = 0;

    map1(59:64,23) = 0;
    map1(23,59:64) = 0;

    map1(59:64,10) = 0;
    map1(10,59:64) = 0;

    map1(70:71,30:32) = 0;
    map1(30:32,70:71) = 0;

    map1(63:64,50:51) = 0;
    map1(50:51,63:64) = 0;

    map1(80:81,59:61) = 0;
    map1(59:61,80:81) = 0;

    map1(70,48) = 0;
    map1(48,70) = 0;

    map1(76,48) = 0;
    map1(48,76) = 0;

    map1(74,59:60) = 0;
    map1(59:60,74) = 0;

    map1(86,48) = 0;
    map1(48,86) = 0;

    map1(89,59:60) = 0;
    map1(59:60,89) = 0;

    map1(91,48) = 0;
    map1(48,91) = 0;

    map1(94,59:60) = 0;
    map1(59:60,94) = 0;

    map1(96,48) = 0;
    map1(48,96) = 0;

    map1(98,59:60) = 0;
    map1(59:60,98) = 0;

    army_size = status(1,9);%对称对抗，双方army_size相同
    decimal = 1;

%%% 创建五个友军变量，每个变量包含两个随机数字位置信息。坐标范围是a、b之间。
    %公式 r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数。
    %不再使用随机生成方案 ally = 20 + (40-20).*rand(army_size, 3);
    ally_x = status(1,2) * 0.1 + (status(1,1) * 0.1 - status(1,2) * 0.1).*rand(army_size,1);
    ally_y = status(1,4) * 0.1 + (status(1,3) * 0.1 - status(1,4) * 0.1).*rand(army_size,1);
    ally = [ally_x ally_y];
    ally(:,3) = zeros(army_size,1);%友军同等价值
    ally = single(round(ally * 10^decimal)/10^decimal);%一位小数
    ally_backup = ally;
    %disp(ally);%调试用
    % 为每个友军分配一个名字
    %al1 = ally(1, :);

    %创建5个敌人，包含坐标信息与价值信息
    enemy_x = status(1,6) * 0.1 + (status(1,5) * 0.1 - status(1,6) * 0.1).*rand(army_size,1);
    enemy_y = status(1,8) * 0.1 + (status(1,7) * 0.1 - status(1,8) * 0.1).*rand(army_size,1);
    enemy = [enemy_x enemy_y];
    enemy(:,3) = rand(army_size,1);
    enemy = single(round(enemy * 10^decimal)/10^decimal);
    enemy_backup = enemy;

%%% 执行环节

    %初始化结果策略表格chart
    chart = zeros(army_size,2);
    OptimalPath = zeros(0,2);
    for i = 1:army_size
        %调用WPA
        [name1,name2] = boothWPA(ally,enemy,army_size,status);
        posA = single(ally(name1,1:2));disp(posA);
        posE = single(enemy(name2,1:2));disp(posE);

        %记录策略写入chart中
        row_a = find(all(ally_backup(:,1:2) == posA(1,:),2));
        row_e = find(all(enemy_backup(:,1:2) == posE(1,:),2));
        chart(i,1) = row_a;
        chart(i,2) = row_e;

        %路径规划部分
        Path = A_star_1(posA,posE,map1);
        Path_size(i,:) = size(Path);
        OptimalPath = [OptimalPath;Path;];

        ally(name1,:) = [];
        enemy(name2,:) = [];
        clear name1 name2 posA posE row_a row_e Path;
    end

%%%展示环节

    disp(chart);
    %OptimalPath = OptimalPath.*0.1;
    %map = map.*0.1;
    figure
    hold on;
    imagesc((map1))
    colormap(flipud(gray))
    ytick = linspace(0.5,99.5,100);%绘制网格图
    xtick = linspace(0.5,99.5,100);
    [x,y] = meshgrid(xtick,ytick);
    plot(x,y,'k',y,x,'k')
    start = 1;
    for j = 1:army_size
        p1 = plot(OptimalPath(start,1),OptimalPath(start,2),'x','color',[(1/army_size)*j,0.1*j,0.1*j]);
        p2 = plot(OptimalPath((start - 1) + Path_size(j,1),1),OptimalPath((start - 1) + Path_size(j,1),2),'^','color',[0.1*j,(1/army_size)*j,0.1*j]);
        p3 = plot(OptimalPath(start:(start - 1) + Path_size(j,1),1),OptimalPath(start:(start - 1) + Path_size(j,1),2),'color',[0.1*j,0.1*j,(1/army_size)*j]);
        legend([p1 p2 p3],{'目标','起点','路径'})
        start = Path_size(j,1) + start;
    end
    title('由暗到亮依次为不同路径')
end
