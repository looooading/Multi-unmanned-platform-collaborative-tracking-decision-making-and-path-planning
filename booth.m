function result = booth(x1,x2,ally,enemy)
    bilixishu = 10;
    [b,~] = size(x1);
    result = zeros(b,1);
    for a = 1:b
        x11 = x1(a,1);
        x22 = x2(a,1);
        i = round(x11);%取整，也是取巧了，限制了WPA的作用
        j = round(x22);
        %disp(a);
        %disp(i);
        %disp(j);
        %disp(x1);
        %disp(x2);
        result(a,1) = norm(ally(i,1:2) - enemy(j,1:2)) - bilixishu*(ally(i,3) - enemy(j,3));
    end
    clear x11 x22 bilixishu
end