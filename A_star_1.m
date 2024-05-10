function OptimalPath = A_star_1(ally_pos,enemy_pos,MAP)
    
    %更改数量级，以适配后续执行
    ally_pos = single(ally_pos .* 10);
    enemy_pos = single(enemy_pos .* 10);
    [map_x_size, map_y_size] = size(MAP);
    %map_x_size = map_x_size * 10;
    %map_y_size = map_y_size * 10;
    %MAP = single(zeros(map_x_size,map_y_size));

    %Start Positions
    StartX=ally_pos(1,2);
    StartY=ally_pos(1,1);
    
    %Generating goal nodes, which is represented by a matrix. Several goals can be speciefied, in which case the pathfinder will find the closest goal. 
    %a cell with the value 1 represent a goal cell
    GoalRegister = single(zeros(map_x_size,map_y_size));
    GoalRegister(enemy_pos(1,1),enemy_pos(1,2))=1;
    
    %Number of Neighboors one wants to investigate from each cell. A larger
    %number of nodes means that the path can be alligned in more directions. 
    %Connecting_Distance=1-> Path can  be alligned along 8 different direction.
    %Connecting_Distance=2-> Path can be alligned along 16 different direction.
    %ETC......
    
    Connecting_Distance=1; %Avoid to high values Connecting_Distances for reasonable runtimes. 
    % Running PathFinder
    OptimalPath = ASTARPATH(StartX,StartY,MAP,GoalRegister,Connecting_Distance);
    % End. 
    %figure(10)
    if size(OptimalPath,2)>1
        disp('Path found!')
        %{
        figure(10)
        imagesc((MAP))
        colormap(flipud(gray));
        hold on
        plot(OptimalPath(1,2),OptimalPath(1,1),'o','color','k')
        plot(OptimalPath(end,2),OptimalPath(end,1),'^','color','b')
        plot(OptimalPath(:,2),OptimalPath(:,1),'r')
        legend('Goal','Start','Path')
        %}
    else 
        pause(1);
        h=msgbox('Sorry, No path exists to the Target!','warn');
        uiwait(h,5);
    end
end



function OptimalPath=ASTARPATH(StartX,StartY,MAP,GoalRegister,Connecting_Distance)
    %Version 1.0
    % By Einar Ueland 2nd of May, 2016
    
    %FINDING ASTAR PATH IN AN OCCUPANCY GRID
    
    
    %nNeighboor=3;
    % Preallocation of Matrices
    [Height,Width]=size(MAP); %Height and width of matrix
    GScore=zeros(Height,Width);           %Matrix keeping track of G-scores 
    FScore=single(inf(Height,Width));     %Matrix keeping track of F-scores (only open list) 
    Hn=single(zeros(Height,Width));       %Heuristic matrix
    OpenMAT=single(zeros(Height,Width));    %Matrix keeping of open grid cells
    ClosedMAT=single(zeros(Height,Width));  %Matrix keeping track of closed grid cells
    ClosedMAT(MAP==1)=1;                  %Adding object-cells to closed matrix
    ParentX=int16(zeros(Height,Width));   %Matrix keeping track of X position of parent
    ParentY=int16(zeros(Height,Width));   %Matrix keeping track of Y position of parent
    
    
    %%% Setting up matrices representing neighboors to be investigated
    NeighboorCheck=ones(2*Connecting_Distance+1);
    Dummy=2*Connecting_Distance+2;
    Mid=Connecting_Distance+1;
    for i=1:Connecting_Distance-1
    NeighboorCheck(i,i)=0;
    NeighboorCheck(Dummy-i,i)=0;
    NeighboorCheck(i,Dummy-i)=0;
    NeighboorCheck(Dummy-i,Dummy-i)=0;
    NeighboorCheck(Mid,i)=0;
    NeighboorCheck(Mid,Dummy-i)=0;
    NeighboorCheck(i,Mid)=0;
    NeighboorCheck(Dummy-i,Mid)=0;
    end
    NeighboorCheck(Mid,Mid)=0;
    
    [row, col]=find(NeighboorCheck==1);
    Neighboors=[row col]-(Connecting_Distance+1);
    N_Neighboors=size(col,1);
    %%% End of setting up matrices representing neighboors to be investigated
    
    
    %%%%%%%%% Creating Heuristic-matrix based on distance to nearest  goal node
    [col, row]=find(GoalRegister==1);
    RegisteredGoals=[row col];
    Nodesfound=size(RegisteredGoals,1);
    
    for k=1:size(GoalRegister,1)
        for j=1:size(GoalRegister,2)
            if MAP(k,j)==0
                Mat=RegisteredGoals-(repmat([j k],(Nodesfound),1));
                Distance=(min(sqrt(sum(abs(Mat).^2,2))));
                Hn(k,j)=Distance;
            end
        end
    end
    %End of creating Heuristic-matrix. 
    
    %Note: If Hn values is set to zero the method will reduce to the Dijkstras method.
    
    %Initializign start node with FValue and opening first node.
    FScore(StartY,StartX)=Hn(StartY,StartX);         
    OpenMAT(StartY,StartX)=1;   
    
    
    
    
    while 1==1 %Code will break when path found or when no path exist
        MINopenFSCORE=min(min(FScore));
        if MINopenFSCORE==inf
        %Failuere!
            OptimalPath=inf;
            RECONSTRUCTPATH=0;
        break
        end
        [CurrentY,CurrentX]=find(FScore==MINopenFSCORE);
        CurrentY=CurrentY(1);
        CurrentX=CurrentX(1);
    
        if GoalRegister(CurrentY,CurrentX)==1
        %GOAL!!
            RECONSTRUCTPATH=1;
            break
        end
        
        %Remobing node from OpenList to ClosedList  
        OpenMAT(CurrentY,CurrentX)=0;
        FScore(CurrentY,CurrentX)=inf;
        ClosedMAT(CurrentY,CurrentX)=1;
        for p=1:N_Neighboors
            i=Neighboors(p,1); %Y
            j=Neighboors(p,2); %X
            if CurrentY+i<1||CurrentY+i>Height||CurrentX+j<1||CurrentX+j>Width
                continue
            end
            Flag=1;
            if(ClosedMAT(CurrentY+i,CurrentX+j)==0) %Neiboor is open;
                if (abs(i)>1||abs(j)>1);   
                    % Need to check that the path does not pass an object
                    JumpCells=2*max(abs(i),abs(j))-1;
                    for K=1:JumpCells;
                        YPOS=round(K*i/JumpCells);
                        XPOS=round(K*j/JumpCells);
                
                        if (MAP(CurrentY+YPOS,CurrentX+XPOS)==1)
                            Flag=0;
                        end
                    end
                end
                %End of  checking that the path does not pass an object
    
                if Flag==1           
                    tentative_gScore = GScore(CurrentY,CurrentX) + sqrt(i^2+j^2);
                    if OpenMAT(CurrentY+i,CurrentX+j)==0
                        OpenMAT(CurrentY+i,CurrentX+j)=1;                    
                    elseif tentative_gScore >= GScore(CurrentY+i,CurrentX+j)
                        continue
                    end
                    ParentX(CurrentY+i,CurrentX+j)=CurrentX;
                    ParentY(CurrentY+i,CurrentX+j)=CurrentY;
                    GScore(CurrentY+i,CurrentX+j)=tentative_gScore;
                    FScore(CurrentY+i,CurrentX+j)= tentative_gScore+Hn(CurrentY+i,CurrentX+j);
                end
            end
        end
    end
    
    k=2;
    if RECONSTRUCTPATH
        OptimalPath(1,:)=[CurrentY CurrentX];
        while RECONSTRUCTPATH
            CurrentXDummy=ParentX(CurrentY,CurrentX);
            CurrentY=ParentY(CurrentY,CurrentX);
            CurrentX=CurrentXDummy;
            OptimalPath(k,:)=[CurrentY CurrentX];
            k=k+1;
            if (((CurrentX== StartX)) &&(CurrentY==StartY))
                break
            end
        end
    end
    
    
end
