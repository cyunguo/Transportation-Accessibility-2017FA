clear; clc; close all

num_ppl = 1000;
num_job = 800;
zone_size = 10;
city_scale = 2;
CBD_region_size = 3;
mode = 1;
trans_improve = 0;

[people job zone] = model_set_up(num_ppl, num_job, zone_size, city_scale, CBD_region_size, mode, trans_improve);
% [people job zone] = model_set_up(1000,800,10,2,3);

en_nobus = 0;
band_in_radi = 3;
band_out_radi = 4;

%% Gravity type

% inverse power model
alpha = 0.8; %0.8, 1.0, 1.5, 2.0
for i = 1:1:num_ppl
    A_ip(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
            A_ip(i,1) = A_ip(i,1) + Wj * travel_dist(people(i).hhpos, job(j).pos)^(-alpha);
        end
    end
end

% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
            A_e(i,1) = A_e(i,1) + Wj * exp(-beta*travel_dist(people(i).hhpos, job(j).pos));
        end
    end
end

% Gaussian
mu = 10; %10, 40, 100, 180
for i = 1:1:num_ppl
    A_g(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
            A_g(i,1) = A_g(i,1) + Wj * exp(-1/mu*travel_dist(people(i).hhpos, job(j).pos)^2);
        end
    end
end

%% Cumulative sum
T = 4; %20, 30, 40
for i = 1:1:num_ppl
    % Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cr(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            if travel_dist(people(i).hhpos, job(j).pos) <= T
               A_cr(i,1) = A_cr(i,1) + 1/num_job;%Wj;
            end
        end
    end
end

T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
        if people(i).skill_level >= job(j).skill_level
            travel_time_temp = travel_dist(people(i).hhpos, job(j).pos);
            if travel_time_temp <= T
               A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
            end
        end
    end
end

%% plot

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

figure(); plot(job_posx_skill3, job_posy_skill3, '.'); hold on;
plot(job_posx_skill2, job_posy_skill2, 'o'); plot(job_posx_skill1, job_posy_skill1, '*'); 
legend('skill level 3', 'skill level 2', 'skill level 1');
title('Job Position');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_ip,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based gravity inverse power measure');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_e,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based gravity exponential measure');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_g,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based gravity gaussian measure');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_cr,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based cumulative opportunity rectangular measure');

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_cnl,xx,yy);
figure();
surf(xx,yy,zz); title('Place-based cumulative opportunity negative linear measure');
