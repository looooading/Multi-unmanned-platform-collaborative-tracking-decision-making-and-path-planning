function plotfn(xlim, ylim,ally,enemy)
    % plotting function
    figure;
    [ptsx, ptsy] = meshgrid(linspace(xlim(1),xlim(2),100), linspace(ylim(1),ylim(2),100));
    %disp(ptsx);disp(ptsy);
    ptsx1 = zeros(100,1);
    %ptsx(1,51:99) = 0;disp(ptsx(1,:));
    for a = 1:100
        ptsx1(:,a) = caesar(ptsx(1,:),a-1);
        %ptsx1(i,1) = ptsx(1,i+a-1);
        fn_vals(:,a) = booth(ptsx1(:,a),ptsy(:,1),ally,enemy);
    end
    
    %disp(ptsx1);
    
    [min_val] = min(fn_vals,[], "all");
    [max_val] = max(fn_vals,[], "all");
    %disp(fn_vals);
    mesh(ptsx ,ptsy, fn_vals);
    colormap default; colorbar
    hold on
    plot3(ptsx(fn_vals == min_val),ptsy(fn_vals == min_val), fn_vals(fn_vals == min_val), "xr");
    plot3(ptsx(fn_vals == max_val),ptsy(fn_vals == max_val), fn_vals(fn_vals == max_val), "xg");
    title("f(x)");
    xlabel("x","FontWeight", "bold"); ylabel("y", "FontWeight", "bold"); zlabel("f(x)", "FontWeight", "bold");
    legend("function", "Min value", "Max value", "Location", "best");
end