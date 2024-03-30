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

%计算适应度，cost1每行记录的是对于第a个敌人，我方最小距离及对应的我单位索引
%距离dis1 = norm(al1-Em1_pos);
%distance = [1,2,3,4,5];
function cost1 = findCost(ally,enemy)
    distance = zeros(5,5);%变量似乎要更改每个循环迭代的大小。请考虑对速度进行预分配。
    cost1 = zeros(5,2);
    for a=1:5
        em_a = enemy(a,1:2);%即Em_pos
        for i=1:5
            al_i = ally(i,:);
            distance(a,i)=norm(al_i-em_a);
            %disp(distance);%调试用
            [M,N] = min(distance(a,:));%M和N分别对应着最小距离和对应的我单位索引，分别存入cost1的第1、2列
            cost1(a,1)=M;
            cost1(a,2)=N;
            %disp(cost1);%调试用
        end
        cost1(a,1) = cost1(a,1) - enemy(a,3);
        %disp(cost1);%调试用
    end
    %disp(cost1);%调试用
end

function [bestX, bestF] = WPA(ally,enemy,max_gen,alpha, beta, delta)
% fitness_func - 适应度函数
% lb - 自变量下界
% ub - 自变量上界
% dim - 自变量维度
% max_gen - 最大迭代次数
% pop_size - 种群大小
% alpha - 狼群更新常数
% beta - 狼群更新常数
% delta - 狼群更新常数
    % 初始化种群
    pop = ally;
    pop_size = size(ally,1);%pop_size = 5
    dim = 2;
    %%pop = create_population(lb, ub, dim, pop_size);
    % 计算适应度
    %%fitness = evaluate_fitness(pop, pop_size);
    fitness = findCost(ally,enemy);
    % 寻找最优解
    %%[bestF, bestIdx] = min(fitness);
    best = min(cost);
    bestF = best(1,1);
    bestIdx = best(1,2);
    bestX = pop(bestIdx, :);
    % 迭代优化
    for gen = 1:max_gen
        % 更新狼群位置
        for i = 1:pop_size
            % 计算狼群中每个狼的适应度
            fitness_i = fitness(i);
            for j = 1:pop_size
                if fitness(j) < fitness_i
                    r1 = rand(1, dim);
                    r2 = rand(1, dim);
                    A = alpha * (2 * r1 - 1);
                    C = 2 * r2;
                    D = abs(C .* bestX - pop(i, :));
                    X1 = bestX - A .* D;
                    fitness_X1 = evaluate_fitness( X1, 1);%！存疑
                    % 更新最优解
                    if fitness_X1 < bestF
                        bestF = fitness_X1;
                        bestX = X1;
                    end
                    % 更新狼群位置
                    if fitness_X1 < fitness_i
                        pop(i, :) = X1;
                        fitness_i = fitness_X1;
                    else
                        r3 = rand;%！存疑 为什么要用一个随机的值和beta作比较？有什么意义呢？
                        if r3 < beta
                            X2 = pop(j, :) + delta * (rand(1, dim) - 0.5);
                            fitness_X2 = evaluate_fitness( X2, 1);%！存疑
                            % 更新最优解
                            if fitness_X2 < bestF
                                bestF = fitness_X2;
                                bestX = X2;
                            end
                            % 更新狼群位置
                            if fitness_X2 < fitness_i
                                pop(i, :) = X2;
                                fitness_i = fitness_X2;
                            end
                        end
                    end
                end
            end
        end
    end
end

% 初始化种群
%function pop = create_population(lb, ub, dim, pop_size)
%    pop = repmat(lb, pop_size, 1) + rand(pop_size, dim) .* repmat((ub - lb), pop_size, 1);
%end

% 计算适应度
function fitness = evaluate_fitness( pop, pop_size)
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        fitness(i) = norm(pop(i, :));
        %distance(i)=norm(pop(i,:));
    end
end

function cost_A = A_star(start,goal,obmap)
    dim = size(obmap);
    % Grids(i,j,1) - x of parent pos; 2 - y of parent pos; 3 - precost; 4 -
    % postcost
    Grids = zeros(dim(1),dim(2),4);
    for i = 1:dim(1)
        for j = 1:dim(2)
            Grids(i,j,1) = i; % 父节点的所在行
            Grids(i,j,2) = j; % 父节点的所在列
            Grids(i,j,3) = norm(([i,j]-goal)); % 启发值h
            Grids(i,j,4) = inf; % g值
        end
    end
    Open = start;
    Grids(start(1),start(2),4) = 0;
    Close = [];
    while ~isempty(Open)
        [wknode,Open] = PopOpen(Open,Grids);
        [Grids,Open,Close] = Update(wknode,goal,obmap,Grids,Open,Close);
        Close(end+1,:) = wknode;
    end
    cost_A = Grids(goal(1),goal(2),3)+Grids(goal(1),goal(2),4);
end

end%main_end
