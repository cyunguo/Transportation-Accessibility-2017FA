function [people, job, zone] = model_set_up_1(num_ppl, num_job, zone_size, city_scale, CBD_region_size, mode, trans_improve)
% 
% num_ppl refers to the number of people living in the city.
% num_job refers to the number of job available in the city.
% zone_size is the number of zones in the city (zone_size * zone_size)
% city_scale will determine how the model is setup
% CBD_region_size refer to the size of zones of CBD for large city(or
% living neighbourhood for small city) (CBD_region_size * CBD_region_size)
% in the center of the city
% mode refers to the mode of the model. 0 for HH pos random distributed, 1
% for HH pos group by skill level.
% trans_improve refers to the improvement of transportation. 0 for no
% improvement. For small city, with no transportation improvement, we do
% not have the bus. For large city, with transporation improvement, the
% bus covers a larger area.

TQ2TC = 1;
% Travel Quality: 1 for walking, 2 for bus, 3 for drive
for i = 1:1:num_ppl
    people(i).workstatus = randi([0,1]);
    people(i).skill_level = randi(3);
    
    if mode == 0
        people(i).hhpos = [zone_size/2*(-1+2*rand()), zone_size/2*(-1+2*rand())];
    elseif mode == 1
        high_skill_region = zone_size/4 + (zone_size/3 - zone_size/4) * rand();
        middle_skill_region = high_skill_region + zone_size/4 + (zone_size/3 - zone_size/4) * rand();
        switch people(i).skill_level
            case 3
                people(i).hhpos = random_xy_pos(0, high_skill_region/2);
            case 2
                people(i).hhpos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
            case 1
                people(i).hhpos = random_xy_pos(middle_skill_region/2, zone_size/2);
        end
    end
    
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end

if (trans_improve == 0 && city_scale == 1)
    for i = 1:1:num_ppl
        if people(i).TQ == 2
            people(i).TQ = 1;
            people(i).TC = TQ2TC*people(i).TQ;
        end
    end
end

if (trans_improve == 0 && city_scale == 2)
    for i = 1:1:num_ppl
        if (people(i).hhpos(1) > zone_size/2 || people(i).hhpos(2) > zone_size/2)
            if people(i).TQ == 2
                people(i).TQ = 1;
                people(i).TC = TQ2TC*people(i).TQ;
            end
        end
    end
end
    

if city_scale == 1 % 1 for small city
    clear high_skill_region middle_skill_region
    high_skill_region = CBD_region_size + (zone_size-CBD_region_size)/4 + ((zone_size-CBD_region_size)/3 - (zone_size-CBD_region_size)/4) * rand();
    middle_skill_region = high_skill_region + (zone_size-CBD_region_size)/4 + ((zone_size-CBD_region_size)/3 - (zone_size-CBD_region_size)/4) * rand();
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
    high_skill_region = CBD_region_size/4 + (CBD_region_size/3 - CBD_region_size/4) * rand();
    middle_skill_region = high_skill_region + CBD_region_size/4 + (CBD_region_size/3 - CBD_region_size/4) * rand();
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
    high_skill_region = zone_size/4 + (zone_size/3 - zone_size/4) * rand();
    middle_skill_region = high_skill_region + zone_size/4 + (zone_size/3 - zone_size/4) * rand();
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

