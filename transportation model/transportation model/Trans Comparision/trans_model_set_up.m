function [people, job, zone] = trans_model_set_up(num_ppl, num_job, zone_size, city_scale, CBD_region_size, mode)

% mode: 1 for all drive; 2 for all walk; 3 for skill level 3(drive) 2(bus)
% 1(walk); 4 for skill level 3(drive) 2(drive or walk) 1(walk)

TQ2TC = 1;
% Travel Quality: 1 for walking, 2 for bus, 3 for drive
for i = 1:1:num_ppl
    people(i).workstatus = randi([0,1]);
    people(i).skill_level = randi(3);
    
        high_skill_region = zone_size/3;
        middle_skill_region = zone_size/3*2;
        switch people(i).skill_level
            case 3
                people(i).hhpos = random_xy_pos(0, high_skill_region/2);
            case 2
                people(i).hhpos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
            case 1
                people(i).hhpos = random_xy_pos(middle_skill_region/2, zone_size/2);
        end
    
    if mode == 1
        people(i).TQ = 3; 
    elseif mode == 2
        people(i).TQ = 1;
    elseif mode == 3
        switch people(i).skill_level
            case 1
                people(i).TQ = 1;
            case 2
                people(i).TQ = 2;
            case 3
                people(i).TQ = 3;
        end
    elseif mode == 4
        switch people(i).skill_level
            case 1
                people(i).TQ = 1;
            case 2
                people(i).TQ = randi(2);
                if people(i).TQ == 2
                    people(i).TQ = 3;
                end
            case 3
                people(i).TQ = 3;
        end
    end
    people(i).TC = TQ2TC*people(i).TQ;
end
    

if city_scale == 1 % 1 for small city
    clear high_skill_region middle_skill_region
    high_skill_region = CBD_region_size + (zone_size-CBD_region_size)/3;
    middle_skill_region = high_skill_region + (zone_size-CBD_region_size)/3;
    for i = 1:1:num_job
        job(i).skill_level = randi(3);
            switch job(i).skill_level
                case 3
                    job(i).pos = random_xy_pos(CBD_region_size/2, high_skill_region/2);
                case 2
                    job(i).pos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
                case 1
                    job(i).pos = random_xy_pos(middle_skill_region/2, zone_size/2);
            end
    end
elseif city_scale == 2 % 2 for large city
    clear high_skill_region middle_skill_region
    high_skill_region = CBD_region_size/3;
    middle_skill_region =  CBD_region_size/3 * 2;
    for i = 1:1:num_job
        job(i).skill_level = randi(3);
            switch job(i).skill_level
                case 3
                    job(i).pos = random_xy_pos(0, high_skill_region/2);
                case 2
                    job(i).pos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
                case 1
                    job(i).pos = random_xy_pos(middle_skill_region/2, CBD_region_size/2);
            end
    end
elseif city_scale == 0 % 0 for no special modeling for city size
    clear high_skill_region middle_skill_region
        high_skill_region = zone_size/3;
        middle_skill_region = zone_size/3*2;
    for i = 1:1:num_job
        job(i).skill_level = randi(3);
            switch job(i).skill_level
                case 3
                    job(i).pos = random_xy_pos(0, high_skill_region/2);
                case 2
                    job(i).pos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
                case 1
                    job(i).pos = random_xy_pos(middle_skill_region/2, zone_size/2);
            end
    end
end
            
            
            
for i = 1:1:zone_size
    for j = 1:1:zone_size
    zone(i,j).people = 0;
    zone(i,j).job = 0;
    end
end

for i = 1:1:size(people,2) 
    zone(fix(people(i).hhpos(1) + zone_size/2)+1, fix(people(i).hhpos(2) + zone_size/2)+1).people = zone(fix(people(i).hhpos(1) + zone_size/2)+1, fix(people(i).hhpos(2) + zone_size/2)+1).people + 1;
end

for i = 1:1:num_job
    zone(fix(job(i).pos(1) + zone_size/2)+1, fix(job(i).pos(2) + zone_size/2)+1).job = zone(fix(job(i).pos(1) + zone_size/2)+1, fix(job(i).pos(2) + zone_size/2)+1).job + 1;
end

