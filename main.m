function main()
%%% 相关参数初始化
    disp(fileread('Marx_Engels_Lenin_ASCIIBanner.txt'));
    map = single(zeros(50,50));
    army_size = 10;

%%% 创建五个友军变量，每个变量包含两个随机数字位置信息。坐标范围是a、b之间。
    %公式 r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数。
    ally = 20 + (40-20).*rand(army_size, 3);
    ally(:,3) = zeros(army_size,1);%友军同等价值
    decimal = 1;
    ally = single(round(ally * 10^decimal)/10^decimal);
    ally_backup = ally;
    %disp(ally);%调试用
    % 为每个友军分配一个名字
    %al1 = ally(1, :);
    %al2 = ally(2, :);

    %创建5个敌人，包含坐标信息与价值信息
    %Em1 = [0.1,0.1,0.1];Em2 = [-0.1,0.1,0.2];Em3 = [-0.1,-0.1,0.1];Em4 = [0.1,-0.1,0.2];Em5 = [0,0,0.3];
    %enemy = [Em1;Em2;Em3;Em4;Em5];%上述生成的敌人信息竖直叠放
    %Em1_pos = enemy(1,1:2);%enemy1的坐标信息是第一行前两个，之后依次为第二行前两个
    enemy = 10 + (49-10).*rand(army_size,3);enemy(:,3) = rand(army_size,1);
    enemy = single(round(enemy * 10^decimal)/10^decimal);
    enemy_backup = enemy;

%%% 执行环节

    %初始化结果策略表格chart
    chart = zeros(army_size,2);

    for i = 1:army_size
        %调用WPA
        [name1,name2] = boothWPA(ally,enemy);
        posA = single(ally(name1,1:2));%disp(posA);
        posE = single(enemy(name2,1:2));%disp(posE);

        %记录策略写入chart中
        [row_a,~] = find(ally_backup == posA(1,1));
        [row_e,~] = find(enemy_backup == posE(1,1));
        chart(i,1) = row_a;
        chart(i,2) = row_e;

        %路径规划部分
        A_star_1(posA,posE,map);
        %disp(cost_A);
        ally(name1,:) = [];
        enemy(name2,:) = [];
        clear name1 name2 posA posE row_a row_e;
    end
    disp(chart);
end
