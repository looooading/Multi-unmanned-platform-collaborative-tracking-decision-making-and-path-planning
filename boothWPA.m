function [name1,name2] = boothWPA(ally,enemy,army_size,status)
%disp(ally);
%disp(enemy);
[sizeA,~] = size(ally);
[sizeE,~] = size(enemy);
if sizeA > (army_size - 1)
    plotfn([1,sizeA],[1,sizeE],ally,enemy);
    plotfn([1,sizeA],[1,sizeE],ally,enemy);
    view(0,-90)
end

%%% Wolf pack algorithm parameters initialization
% number of wolfs
N = status(1,10);
% number of dimensions 尺寸数
D = 2;
% maximum number of iterations 最大迭代次数
kmax = 5; k=1;
% step coefficient 步长系数
S = 0.12;
% Distance determinant coefficient 距离决定因素系数
Lnear = 0.3; %0.08
% max number of  iterations in scouting behaviour 侦察行为的最大迭代次数
Tmax = 12; T=0;
% population renewing proportional constant 种群更新比例系数
beta = 2;
% steps 步长
stepa = S; stepb = 2.5*S; stepc = S/2;
% h limits
hmin = 10; hmax= 20;
% R to delete wolves from end
Rmin = N/(2*beta); Rmax = N/beta;

%%% initial position
xmin = 1;
xmax = sizeA;
X = (xmax-xmin).*rand(N,D) + xmin;
%%X = randi(xmax,N,D);
m = X(:,1); n = X(:,2);
if sizeA > (army_size - 1)
    hold on
    p = plot(m, n, "ok");
    p.XDataSource = 'm';
    p.YDataSource = 'n';
end

%%% starting iterations
while k<kmax
    step = 1; overfl=0;
    while ~overfl
        if step==1
            % finding lead
            fitness = booth(m,n,ally,enemy);
            [lead, idx_lead] = min(fitness);

            % data for plots
            [best(k), idx_best] = min(fitness);
            worst(k) = max(fitness);
            avg(k) = mean(fitness);

            step=2;
        elseif step==2
            % scouting 侦查
            brkfl = 1;
            while T<Tmax && brkfl
                for i=1:N
                    if i~=idx_lead
                        h = randi([hmin,hmax], 1);
                        movefl = 0; x1new = -6; x2new = -6; 
                        %disp(fitness);%调试用
                        fitnessnew = fitness(i);
                        for j=1:h
                            X1new = X(i,1) + (stepa * sin(2*pi*(j/h)));
                            X2new = X(i,2) + (stepa * sin(2*pi*(j/h)));
                            if booth(X1new,X2new,ally,enemy)<fitnessnew
                                x1new = X1new; x2new = X2new; 
                                fitnessnew = booth(X1new,X2new,ally,enemy);
                                movefl = 1;
                            end
                        end
                        if movefl
                            X(i:1) = x1new; X(i:2) = x2new;
                            fitness(i) = fitnessnew;
                            m = X(:,1); n = X(:,2);
                            %disp(m);disp(n);
                            if k == 1 && sizeA > (army_size - 1)
                                refreshdata(p,'caller')
                                drawnow
                                legend(p,'侦查环节的狼群位置')
                            end
                        end
                        if booth(X(i,1),X(i,2),ally,enemy)<lead
                            lead = booth(X(i,1),X(i,2),ally,enemy);
                            idx_lead = i;
                            brkfl=0;
                            break
                        end
                    end
                end
                T = T + 1;
            end
            step=3;
        elseif step==3
            % Calling 召唤
            distfl = 1;
            while distfl
                moveable_wolves = [];
                for i=1:N
                    dist(i) = sqrt((X(idx_lead,1)-X(i,1))^2 + (X(idx_lead,2)-X(i,2))^2);
                    if dist(i)>Lnear
                        moveable_wolves = [moveable_wolves; i];
                    end
                end
                if isempty(moveable_wolves)
                    disfl=0;
                    break
                end
                for i=1:length(moveable_wolves)
                    x1old = X(moveable_wolves(i),1); x2old = X(moveable_wolves(i),2);
                    x1new = X(idx_lead,1); x2new = X(idx_lead,2);
                    X(moveable_wolves(i),1) = x1old + stepb * ((x1new-x1old)/abs(x1new-x1old));%disp(X(moveable_wolves(i),1));
                    X(moveable_wolves(i),2) = x2old + stepb * ((x2new-x2old)/abs(x2new-x2old));%disp(X(moveable_wolves(i),2));
                    m = X(:,1); n = X(:,2);
                    if k == 1 && sizeA > (army_size - 1)
                        refreshdata(p,'caller')
                        drawnow
                        legend(p,'召唤环节的狼群位置')
                    end
                    if booth(X(moveable_wolves(i),1), X(moveable_wolves(i),2),ally,enemy)<lead
                        lead = booth(X(moveable_wolves(i),1), X(moveable_wolves(i),2),ally,enemy);
                        idx_lead = moveable_wolves(i);
                        step=2;
                        distfl = 0;
                        break
                    end
                end
            end
            if step==3
                step=4;
            end
        elseif step==4
            % Besieging 围攻
            for i=1:N
                if i~=idx_lead
                    x1old = X(i,1); x2old = X(i,2);
                    x1lead = X(idx_lead,1); x2lead = X(idx_lead,2);
                    x1new = x1old + (2*rand-1) * stepc * (abs(x1lead-x1old));
                    x2new = x2old + (2*rand-1) * stepc * (abs(x2lead-x2old));
                    if booth(x1new, x2new,ally,enemy)<booth(x1old, x2old,ally,enemy)
                        X(i,1) = x1new; X(i,2) = x2new;
                        m = X(:,1); n = X(:,2);
                        if k == 1 && sizeA > (army_size - 1)
                            refreshdata(p,'caller')
                            drawnow
                            legend(p,'围攻环节的狼群位置')
                        end
                        if booth(x1new, x2new,ally,enemy)<lead
                            lead = booth(x1new, x2new,ally,enemy);
                            idx_lead = i;
                        end
                    end
                end
            end
            step=5;
        elseif step==5
            % stronger surviving renewing 更强大的生存更新
            [sizeX,~] = size(X);
            for s = 1:sizeX %#1 通过重定位超出部分的狼解决索引报错问题
                %[~,xxx2] = min(booth(m,n,ally,enemy));
                if X(s,1) >= sizeA || X(s,2) >= sizeA || X(s,1) <= 1 || X(s,2) <= 1
                    X(s,:) = (xmax-xmin).*rand(1,2) + xmin;
                end
            end
            fitness = booth(X(:,1),X(:,2),ally,enemy);
            [~, idx_sorted] = sort(fitness, "descend");
            R = randi([Rmin, Rmax], 1);
            for i=1:R
                    X(idx_sorted(i),1) = X(idx_lead, 1) * (1+(0.2*rand-0.1));
                    X(idx_sorted(i),2) = X(idx_lead, 2) * (1+(0.2*rand-0.1));
                    m = X(:,1); n = X(:,2);
                    if k == 1 && sizeA > (army_size - 1)
                        refreshdata(p,'caller')
                        drawnow
                        legend(p,'种群更新环节的狼群位置')
                    end
            end
            overfl=1;
        end
    end
    k = k + 1;
    fprintf("iteration: %d\n", k)
end
%{
if sizeA > (army_size - 1)
    m = X(:,1); n = X(:,2);
    hold on
    result = plot(m, n, "^b");
    legend(result,"最终狼群位置")
    hold off
end
%}
%%% Plotting fitness over time

if sizeA > (army_size - 1)
    figure
    plot(best,'k');
    hold on
    plot(worst,'k--'); plot(avg,'k:');plot([max(worst)+1.2*army_size,max(worst)+1.2*army_size,max(worst)+1.2*army_size,max(worst)+1.2*army_size],'k-.');
    hold off
    ylim([0, 50])
    title("Best, worst and average fitness");
    xlabel("迭代次数","FontWeight", "bold"); ylabel("最优程度(越小越好)", "FontWeight", "bold");
    legend("最优", "最劣", "平均", "未优化的默认组合","Location", "best");
end


[an1,an2] = min(booth(m,n,ally,enemy));
%disp(an1);
name1 = round(X(an2,1));
name2 = round(X(an2,2));
%disp(name1);
%disp(name2);


clear sizeE sizeA N D k kmax S step stepa stepb stepc x1new x1old x2new x2old Lnear R Rmax Rmin xmin xmax T Tmax
end
