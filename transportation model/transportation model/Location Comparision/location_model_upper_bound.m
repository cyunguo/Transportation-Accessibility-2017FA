function [people, job, zone] = location_model_upper_bound(num_ppl, num_job, zone_size, CBD_region_size)
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
    people(i).hhpos = [CBD_region_size/2*(-1+2*rand()), CBD_region_size/2*(-1+2*rand())];
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end
    

for i = 1:1:num_job
    job(i).pos = random_xy_pos(0, CBD_region_size/2);
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

