clear; clc; close all;
num_ppl = 1000;
num_job = 800;
zone_size = 10;
CBD_region_size = 3;

[people job zone] = location_model_upper_bound(num_ppl, num_job, zone_size, CBD_region_size);
% Gravity type
% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_e(i,1) = A_e(i,1) + 1/num_job * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
    end
end

A_e_upper_bound = mean(A_e);

% Cumulative sum
T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
            travel_time_temp = travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ;
            if travel_time_temp <= T
               A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
            end
    end
end

A_cnl_upper_bound = mean(A_cnl);

% Plot
clear home_posx home_posy job_posx job_posy
num_ppl_skill3 = 0;
num_ppl_skill2 = 0;
num_ppl_skill1 = 0;

for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

figure(); plot(home_posx, home_posy, '.');
title('House Hold Position (Upper Bound)');
axis([-5 5 -5 5])

figure(); plot(job_posx, job_posy, '.'); 
title('Job Position (Upper Bound)');
axis([-5 5 -5 5])

% 
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

%%
clc; clear A_e A_cnl

[people job zone] = location_model_lower_bound(num_ppl, num_job, zone_size, CBD_region_size);
% Gravity type
% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_e(i,1) = A_e(i,1) + 1/num_job * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
    end
end

A_e_lower_bound = mean(A_e);

% Cumulative sum
T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
            travel_time_temp = travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ;
            if travel_time_temp <= T
               A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
            end
    end
end

A_cnl_lower_bound = mean(A_cnl);

%
clear home_posx home_posy job_posx job_posy
num_ppl_skill3 = 0;
num_ppl_skill2 = 0;
num_ppl_skill1 = 0;

for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

figure(); plot(home_posx, home_posy, '.');
title('House Hold Position (Lower Bound)');
axis([-5 5 -5 5])

figure(); plot(job_posx, job_posy, '.'); 
title('Job Position (Lower Bound)');
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


%% 

clc; clear A_e A_cnl
mode = 0;

[people job zone] = location_model_set_up(num_ppl, num_job, zone_size, CBD_region_size, mode);
% Gravity type
% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_e(i,1) = A_e(i,1) + 1/num_job * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
    end
end

A_e_mode1 = mean(A_e);

% Cumulative sum
T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
            travel_time_temp = travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ;
            if travel_time_temp <= T
               A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
            end
    end
end

A_cnl_mode1 = mean(A_cnl);

clear home_posx home_posy job_posx job_posy
num_ppl_skill3 = 0;
num_ppl_skill2 = 0;
num_ppl_skill1 = 0;

for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

figure(); plot(home_posx, home_posy, '.');
title('House Hold Position (Mode 1)');
axis([-5 5 -5 5])

figure(); plot(job_posx, job_posy, '.'); 
title('Job Position (Mode 1)');
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


%%
clc; clear A_e A_cnl
mode = 1;

[people job zone] = location_model_set_up(num_ppl, num_job, zone_size, CBD_region_size, mode);
% Gravity type
% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_e(i,1) = A_e(i,1) + 1/num_job * exp(-beta*travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ);
    end
end

A_e_mode2 = mean(A_e);

% Cumulative sum
T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
            travel_time_temp = travel_dist(people(i).hhpos, job(j).pos)/people(i).TQ;
            if travel_time_temp <= T
               A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
            end
    end
end

A_cnl_mode2 = mean(A_cnl);

clear home_posx home_posy job_posx job_posy
num_ppl_skill3 = 0;
num_ppl_skill2 = 0;
num_ppl_skill1 = 0;

for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

figure(); plot(home_posx, home_posy, '.');
title('House Hold Position (Mode 2)');
axis([-5 5 -5 5])

figure(); plot(job_posx, job_posy, '.'); 
title('Job Position (Mode 2)');
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