function [bestAlly_p, bestCost] = WPA(ally,enemy,max_gen,alpha, beta, delta)
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
    %%[bestCost, bestAlly_i] = min(fitness);
    best = min(fitness);
    bestCost = best(1,1);
    bestAlly_i = best(1,2);
    bestAlly_p = pop(bestAlly_i,:);
    % 迭代优化
    for gen = 1:max_gen
        % 更新狼群位置
        for i = 1:pop_size
            % 计算狼群中每个狼的适应度
            fitness_i = fitness(i);
            for j = 1:pop_size
                if fitness(j) < fitness_i
                    r1 = rand(1,dim);
                    r2 = rand(1,dim);
                    A = alpha * (2 * r1 - 1);
                    C = 2 * r2;
                    D = abs(C .* bestAlly_p - pop(i, :));
                    X1 = bestAlly_p - A .* D;
                    fitness_X1 = findCost(X1,enemy);%！存疑
                    % 更新最优解
                    if fitness_X1 < bestCost
                        bestCost = fitness_X1;
                        bestAlly_p = X1;
                    end
                    % 更新狼群位置
                    if fitness_X1 < fitness_i
                        pop(i,:) = X1;
                        fitness_i = fitness_X1;
                    else
                        r3 = rand;%！存疑 为什么要用一个随机的值和beta作比较？有什么意义呢？
                        if r3 < beta
                            X2 = pop(j,:) + delta * (rand(1,dim) - 0.5);
                            fitness_X2 = findCost(X2,enemy);%！存疑
                            % 更新最优解
                            if fitness_X2 < bestCost
                                bestCost = fitness_X2;
                                bestAlly_p = X2;
                            end
                            % 更新狼群位置
                            if fitness_X2 < fitness_i
                                pop(i,:) = X2;
                                fitness_i = fitness_X2;
                            end
                        end
                    end
                end
            end
        end
    end
end

%计算适应度，cost1每行记录的是对于第a个敌人，我方最小距离及对应的我单位索引
%距离dis1 = norm(al1-Em1_pos);
%distance = [1,2,3,4,5];
function cost1 = findCost(ally,enemy)
    [m,~] = size(ally);
    [n,~] = size(enemy);
    distance = zeros(n,m);%变量似乎要更改每个循环迭代的大小。请考虑对速度进行预分配。
    cost1 = zeros(n,2);
    for a=1:n
        em_a = enemy(a,1:2);%即Em_pos
        for i=1:m
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
    disp(cost1);  %调试用
end

% 计算适应度
%function fitness = evaluate_fitness( pop, pop_size)
%    fitness = zeros(pop_size, 1);
%    for i = 1:pop_size
%        fitness(i) = norm(pop(i, :));
%        distance(i)=norm(pop(i,:));
%    end
%end
