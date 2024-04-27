function main()
%%% 相关参数初始化
    disp(fileread('Marx_Engels_Lenin_ASCIIBanner.txt'));
    map = single(zeros(500,500));
    map(100:200,240:260) = 1;
    map(300:400,240:260) = 1;
    map(240:260,100:200) = 1;
    map(240:260,300:400) = 1;
    map(245:255,245:255) = 1;
    army_size = 3;%对称对抗，双方army_size相同
    decimal = 1;

%%% 创建五个友军变量，每个变量包含两个随机数字位置信息。坐标范围是a、b之间。
    %公式 r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数。
    %不再使用随机生成方案 ally = 20 + (40-20).*rand(army_size, 3);
    ally_x = 10 + (20 - 10).*rand(army_size,1);
    ally_y = 5 + (20 - 5).*rand(army_size,1);
    ally = [ally_x ally_y];
    ally(:,3) = zeros(army_size,1);%友军同等价值
    ally = single(round(ally * 10^decimal)/10^decimal);%一位小数
    ally_backup = ally;
    %disp(ally);%调试用
    % 为每个友军分配一个名字
    %al1 = ally(1, :);

    %创建5个敌人，包含坐标信息与价值信息
    %Em1 = [0.1,0.1,0.1];Em2 = [-0.1,0.1,0.2];Em3 = [-0.1,-0.1,0.1];Em4 = [0.1,-0.1,0.2];Em5 = [0,0,0.3];
    %enemy = [Em1;Em2;Em3;Em4;Em5];%上述生成的敌人信息竖直叠放
    %Em1_pos = enemy(1,1:2);%enemy1的坐标信息是第一行前两个，之后依次为第二行前两个
    %不再使用随机生成方案 enemy = 10 + (49-10).*rand(army_size,3);
    enemy_x = 30 + (40 - 30).*rand(army_size,1);
    enemy_y = 35 + (45 - 35).*rand(army_size,1);
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
        [name1,name2] = boothWPA(ally,enemy);
        posA = single(ally(name1,1:2));disp(posA);
        posE = single(enemy(name2,1:2));disp(posE);

        %记录策略写入chart中
        row_a = find(all(ally_backup(:,1:2) == posA(1,:),2));
        row_e = find(all(enemy_backup(:,1:2) == posE(1,:),2));
        chart(i,1) = row_a;
        chart(i,2) = row_e;

        %路径规划部分
        Path = A_star_1(posA,posE,map);
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
    imagesc((map))
    colormap(flipud(gray))
    start = 1;
    for j = 1:army_size
        plot(OptimalPath(start,1),OptimalPath(start,2),'o','color','k')
        plot(OptimalPath((start - 1) + Path_size(j,1),1),OptimalPath((start - 1) + Path_size(j,1),2),'^','color','b')
        plot(OptimalPath(start:(start - 1) + Path_size(j,1),1),OptimalPath(start:(start - 1) + Path_size(j,1),2),'r')
        legend('Goal','Start','Path')
        start = Path_size(j,1) + start;
    end
end
