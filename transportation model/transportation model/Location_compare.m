clear; clc;
num_ppl = 1000;
perc_center = 0.8;
num_job = 800;
zone_size = 10;
CBD_size = 4;


TQ2TC = 1;
% Travel Quality: 1 for walking, 2 for bus, 3 for drive
for i = 1:1:num_ppl*perc_center
    people(i).workstatus = randi([0,1]);
    people(i).skill_level = randi(3);
    people(i).hhpos = random_xy_pos(0, CBD_size/2);
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end

for i = num_ppl*perc_center:1:num_ppl
    people(i).workstatus = randi([0,1]);
    people(i).skill_level = randi(3);
    people(i).hhpos = random_xy_pos(CBD_size/2, zone_size/2);
    people(i).TQ = randi(3);
    people(i).TC = TQ2TC*people(i).TQ;
end
    
for i = 1:1:num_job*perc_center
    job(i).pos = random_xy_pos(0, CBD_size/2);
    job(i).skill_level = randi(3); 
end

for i = num_job*perc_center:1:num_job
    job(i).pos = random_xy_pos(CBD_size/2, zone_size/2);
    job(i).skill_level = randi(3);
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

%% Gravity type
% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
            A_e(i,1) = A_e(i,1) + Wj * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
        end
    end
end

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

%% Plot
for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

figure(); plot(home_posx, home_posy, '.');
figure(); plot(job_posx, job_posy, '.');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_e,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based gravity exponential measure');
[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_cnl,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based cumulative opportunity negative linear measure');
