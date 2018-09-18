function [people, job, zone] = location_model_set_up(num_ppl, num_job, zone_size, CBD_region_size, mode)
% 
% mode: 0 for hh in the center, job on the edge
%       1 for hh on the edge, jon in the center

TQ2TC = 1;
% Travel Quality: 1 for walking, 2 for bus, 3 for drive
for i = 1:1:num_ppl
    people(i).workstatus = randi([0,1]);
    
    if mode == 0
        people(i).hhpos = [CBD_region_size/2*(-1+2*rand()), CBD_region_size/2*(-1+2*rand())];
    elseif mode == 1
        people(i).hhpos = random_xy_pos(CBD_region_size/2, zone_size/2);
    end
    
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end
    

for i = 1:1:num_job
    if mode == 0
        job(i).pos = random_xy_pos(CBD_region_size/2, zone_size/2);
    elseif mode == 1
        job(i).pos = random_xy_pos(0, CBD_region_size/2);
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

