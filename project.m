%创建5个敌人，包含坐标信息与价值信息
Em1 = [0.1,0.1,0.1];
Em2 = [-0.1,0.1,0.2];
Em3 = [-0.1,-0.1,0.1];
Em4 = [0.1,-0.1,0.2];
Em5 = [0,0,0.3];
enemy = [Em1;Em2;Em3;Em4;Em5];
Em1_pos = enemy(1,1:2);
Em2_pos = enemy(2,1:2);
Em3_pos = enemy(3,1:2);
Em4_pos = enemy(4,1:2);
Em5_pos = enemy(5,1:2);

% 创建五个友军变量，每个变量包含两个随机数字位置信息
ally = rand(5, 2);

% 为每个变量分配一个名字
al1 = ally(1, :);
al2 = ally(2, :);
al3 = ally(3, :);
al4 = ally(4, :);
al5 = ally(5, :);

%距离dis1 = norm(al1-Em1_pos);
%distance = [1,2,3,4,5];
for a=1:5
    emCurrent = enemy(a,1:2);
    for i=1:5
    distance(a,i)=norm(ally(i,:)-emCurrent);
    %%disp(distance);
    [M,N] = min(distance(a,:));
    cost1(a,1)=M;
    cost1(a,2)=N;
    disp(cost1);
    end
    cost1(a,1) = cost1(a,1) - enemy(a,3);
end
disp(cost1);

function [bestX, bestF] = wolf_pack_algorithm(lb, ub, dim, max_gen, pop_size, alpha, beta, delta)
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
    pop = create_population(lb, ub, dim, pop_size);
    % 计算适应度
    fitness = evaluate_fitness(pop, pop_size);
    % 寻找最优解
    [bestF, bestIdx] = min(fitness);
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
                    fitness_X1 = evaluate_fitness( X1, 1);
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
                        r3 = rand;
                        if r3 < beta
                            X2 = pop(j, :) + delta * (rand(1, dim) - 0.5);
                            fitness_X2 = evaluate_fitness( X2, 1);
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
function pop = create_population(lb, ub, dim, pop_size)
    pop = repmat(lb, pop_size, 1) + rand(pop_size, dim) .* repmat((ub - lb), pop_size, 1);
end
% 计算适应度
function fitness = evaluate_fitness( pop, pop_size)
    fitness = zeros(pop_size, 1);
    for i = 1:pop_size
        fitness(i) = norm(pop(i, :));
        %distance(i)=norm(pop(i,:));

    end
end

function cost = A_star(start,goal,obmap)
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
    cost = Grids(goal(1),goal(2),3)+Grids(goal(1),goal(2),4);
end
