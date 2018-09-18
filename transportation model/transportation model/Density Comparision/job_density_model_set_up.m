function [people, job, zone] = job_density_model_set_up(num_ppl, num_job, zone_size, job_density, skill_level)
% 
% job_density 1 for normal density, 2 for double, 3 for triple...
% skill_level refers to which skill_level job that will be influenced by
% the density

TQ2TC = 1;
% Travel Quality: 1 for walking, 2 for bus, 3 for drive
for i = 1:1:num_ppl
    people(i).workstatus = randi([0,1]);
    people(i).skill_level = randi(3);
    
    high_skill_region = zone_size/3;
    middle_skill_region = 2*zone_size/3;
    switch people(i).skill_level
        case 3
            people(i).hhpos = random_xy_pos(0, high_skill_region/2);
        case 2
            people(i).hhpos = random_xy_pos(high_skill_region/2, middle_skill_region/2);
        case 1
            people(i).hhpos = random_xy_pos(middle_skill_region/2, zone_size/2);
    end    
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end    

clear high_skill_region middle_skill_region
%     high_skill_region = zone_size/4 + (zone_size/3 - zone_size/4) * rand();
%     middle_skill_region = high_skill_region + zone_size/4 + (zone_size/3 - zone_size/4) * rand();
high_skill_region = zone_size/3;
middle_skill_region = 2*zone_size/3;
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
if job_density ~= 1
    for i = num_job:1:(num_job + num_job/3 * job_density)
        job(i).skill_level = skill_level;
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

for i = 1:1:size(job,2)
    zone(fix(job(i).pos(1) + zone_size/2)+1, fix(job(i).pos(2) + zone_size/2)+1).job = zone(fix(job(i).pos(1) + zone_size/2)+1, fix(job(i).pos(2) + zone_size/2)+1).job + 1;
end

