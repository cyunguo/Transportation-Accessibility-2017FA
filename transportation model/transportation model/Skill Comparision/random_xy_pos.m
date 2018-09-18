function pos = random_xy_pos(inner, outer)
        flag_temp = randi([1,4]);
        if flag_temp == 1
            pos = [inner + (outer-inner)*rand(), -inner + (outer+inner)*rand()];
        elseif flag_temp == 2 
            pos = [-outer + (outer+inner)*rand(), inner + (outer-inner)*rand()];
        elseif flag_temp == 3
            pos = [-(inner + (outer-inner)*rand()), inner + (-outer-inner)*rand()];
        elseif flag_temp == 4
            pos = [-inner + (outer+inner)*rand(), -(inner + (outer-inner)*rand())];
        end