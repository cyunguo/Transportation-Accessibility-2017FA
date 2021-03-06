clear; clc; close all


city_scale = 1;

mode = 1;

for city_scale = 1:1:2
    for mode = 1:1:4
        
        clear people job zone
        CBD_region_size = 3;
        num_ppl = 1000;
        num_job = 800;
        zone_size = 10;
        
        [people job zone] = trans_model_set_up(num_ppl, num_job, zone_size, city_scale, CBD_region_size, mode);

        %% Gravity type
        % exponential
        beta = 0.12; %0.12, 0.15, 0.22, 0.45
        for i = 1:1:num_ppl
            A_e(i,1) = 0;
            for j = 1:1:num_job
                if people(i).skill_level >= job(j).skill_level
                    Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
                    A_e(i,1) = A_e(i,1) + 1/num_job * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
                end
            end
        end
        
        A_e_avg(city_scale, mode) = mean(A_e);

        %% Cumulative sum
        T = 30;
        % negative linear
        for i = 1:1:num_ppl
            %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
            A_cnl(i,1) = 0;
            for j = 1:1:num_job
                if people(i).skill_level >= job(j).skill_level
                    travel_time_temp = travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ;
                    if travel_time_temp <= T
                       A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
                    end
                end
            end
        end
        
        A_cnl_avg(city_scale, mode) = mean(A_cnl);

        %% plot
        
        clear home_posx home_posy
        clear home_posx_skill3 home_posy_skill3
        clear home_posx_skill2 home_posy_skill2
        clear home_posx_skill1 home_posy_skill1
        
        num_ppl_skill3 = 0;
        num_ppl_skill2 = 0;
        num_ppl_skill1 = 0;

        for i = 1:1:num_ppl
            home_posx(i) = people(i).hhpos(1);
            home_posy(i) = people(i).hhpos(2);
            switch people(i).skill_level
                case 3
                    num_ppl_skill3 = num_ppl_skill3 + 1;
                    home_posx_skill3(num_ppl_skill3) =  people(i).hhpos(1);
                    home_posy_skill3(num_ppl_skill3) =  people(i).hhpos(2);
                case 2
                    num_ppl_skill2 = num_ppl_skill2 + 1;
                    home_posx_skill2(num_ppl_skill2) =  people(i).hhpos(1);
                    home_posy_skill2(num_ppl_skill2) =  people(i).hhpos(2);
                case 1
                    num_ppl_skill1 = num_ppl_skill1 + 1;
                    home_posx_skill1(num_ppl_skill1) =  people(i).hhpos(1);
                    home_posy_skill1(num_ppl_skill1) =  people(i).hhpos(2);
            end
        end

        num_job_skill3 = 0;
        num_job_skill2 = 0;
        num_job_skill1 = 0;
        
        clear job_posx job_posy
        clear job_posx_skill3 job_posy_skill3
        clear job_posx_skill2 job_posy_skill2
        clear job_posx_skill1 job_posy_skill1

        for i = 1:1:num_job
            job_posx(i) = job(i).pos(1);
            job_posy(i) = job(i).pos(2);
            switch job(i).skill_level
                case 3
                    num_job_skill3 = num_job_skill3 + 1;
                    job_posx_skill3(num_job_skill3) = job(i).pos(1);
                    job_posy_skill3(num_job_skill3) = job(i).pos(2);
                case 2
                    num_job_skill2 = num_job_skill2 + 1;
                    job_posx_skill2(num_job_skill2) = job(i).pos(1);
                    job_posy_skill2(num_job_skill2) = job(i).pos(2);
                case 1
                    num_job_skill1 = num_job_skill1 + 1;
                    job_posx_skill1(num_job_skill1) = job(i).pos(1);
                    job_posy_skill1(num_job_skill1) = job(i).pos(2);
            end
        end

        figure(); plot(home_posx_skill3, home_posy_skill3, '.'); hold on;
        plot(home_posx_skill2, home_posy_skill2, 'o'); plot(home_posx_skill1, home_posy_skill1, '*'); 
        legend('skill level 3', 'skill level 2', 'skill level 1');
        title('House Hold Position');
        axis([-5 5 -5 5])

        figure(); plot(job_posx_skill3, job_posy_skill3, '.'); hold on;
        plot(job_posx_skill2, job_posy_skill2, 'o'); plot(job_posx_skill1, job_posy_skill1, '*'); 
        legend('skill level 3', 'skill level 2', 'skill level 1');
        title('Job Position');
        axis([-5 5 -5 5])

        [xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
        zz = griddata(home_posx,home_posy,A_e,xx,yy);
        figure();
        surf(xx,yy,zz); title('Place-based gravity exponential measure');
        axis([-5 5 -5 5 0 1])
        [xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
        zz = griddata(home_posx,home_posy,A_cnl,xx,yy);
        figure();
        surf(xx,yy,zz); title('Place-based cumulative opportunity negative linear measure');
        axis([-5 5 -5 5 0 1])
    end
end