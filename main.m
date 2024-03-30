function main()
    %创建5个敌人，包含坐标信息与价值信息
    Em1 = [0.1,0.1,0.1];
    Em2 = [-0.1,0.1,0.2];
    Em3 = [-0.1,-0.1,0.1];
    Em4 = [0.1,-0.1,0.2];
    Em5 = [0,0,0.3];
    enemy = [Em1;Em2;Em3;Em4;Em5];%上述生成的敌人信息竖直叠放
    %Em1_pos = enemy(1,1:2);%enemy1的坐标信息是第一行前两个，之后依次为第二行前两个
    %Em2_pos = enemy(2,1:2);
    %Em3_pos = enemy(3,1:2);
    %Em4_pos = enemy(4,1:2);
    %Em5_pos = enemy(5,1:2);

    % 创建五个友军变量，每个变量包含两个随机数字位置信息。坐标范围是a、b之间。
    %公式 r = a + (b-a).*rand(N,1) 生成区间 (a,b) 内的 N 个随机数。
    ally = -1+(1-(-1)).*rand(5, 2);
    %disp(ally);%调试用
    % 为每个友军分配一个名字
    %al1 = ally(1, :);
    %al2 = ally(2, :);
    %al3 = ally(3, :);
    %al4 = ally(4, :);
    %al5 = ally(5, :);

    [X,F] = WPA(ally,enemy,100,0.1,0.2,0.3);
    disp(X);
    disp(F);
end
