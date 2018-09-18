clear; clc;

num_ppl = 1000;
num_job = 800;
zone_size = 10;
city_scale = 1;
CBD_region_size = 3;
mode = 0;
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
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_ip(i,1) = A_ip(i,1) + Wj * travel_dist(people(i).hhpos, job(j).pos)^(-alpha);
    end
end

% exponential
beta = 0.12; %0.12, 0.15, 0.22, 0.45
for i = 1:1:num_ppl
    A_e(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_e(i,1) = A_e(i,1) + Wj * exp(-beta*travel_dist(people(i).hhpos, job(j).pos));
    end
end

% Gaussian
mu = 10; %10, 40, 100, 180
for i = 1:1:num_ppl
    A_g(i,1) = 0;
    for j = 1:1:num_job
        Wj = zone(fix(job(j).pos(1) + zone_size/2)+1, fix(job(j).pos(2) + zone_size/2)+1).job/num_job;
        A_g(i,1) = A_g(i,1) + Wj * exp(-1/mu*travel_dist(people(i).hhpos, job(j).pos)^2);
    end
end

%% Cumulative sum
T = 4; %20, 30, 40
for i = 1:1:num_ppl
    % Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cr(i,1) = 0;
    for j = 1:1:num_job
        if travel_dist(people(i).hhpos, job(j).pos) <= T
           A_cr(i,1) = A_cr(i,1) + 1/num_job;%Wj;
        end
    end
end

T = 30;
% negative linear
for i = 1:1:num_ppl
    %Wj = zone(fix(people(i).job_posx/10)+1, fix(people(i).job_posy/10)+1).job/tot_job;
    A_cnl(i,1) = 0;
    for j = 1:1:num_job
        travel_time_temp = travel_dist(people(i).hhpos, job(j).pos);
        if travel_time_temp <= T
           A_cnl(i,1) = A_cnl(i,1) + 1/num_job * (1-travel_time_temp/T); %Wj * (1-travel_time_temp/T);
        end
    end
end


%% Log sum

clear travel_time_temp A_lse;
for i = 1:1:num_ppl
    A_lse(i,1) = 0;
    for j = 1:1:num_job
        travel_time_temp = travel_dist(people(i).hhpos, job(j).pos);
        A_lse(i,1) = A_lse(i,1) + exp(travel_time_temp);
    end
    A_lse(i,1) = log(A_lse(i,1));
end

%% Time space measure

for i = 1:1:100
    activity(i).pos = [-zone_size/2 + zone_size*rand(), -zone_size/2 + zone_size*rand()];
end

num_act = 5; %number of activity per day
spd_time_factor = 5; % correlate speed with time
TQ2spd_factor = 5;
for i = 1:1:num_ppl %Iterate every person
    clear temp_act avg_spd;
    avg_spd = 1/people(i).TQ * TQ2spd_factor;
    A_time_space(i) = 0;
    temp_act(1).pos = people(i).hhpos;
    temp_act(1).ti = 0;
    temp_act(1).tj = 0;
    for j = 2:1:num_act+1 %Generate pos & ti & tj
        temp_act(j).pos = [-zone_size/2 + zone_size*rand(), -zone_size/2 + zone_size*rand()];
        % temp_act(j).pos = activity(randi([1,100])).pos;
        temp_act(j).ti = spd_time_factor*rand();
        temp_act(j).tj = temp_act(j-1).ti + spd_time_factor*rand();
    end
    temp_act(num_act+2).pos = people(i).hhpos;
    temp_act(num_act+2).ti = 0;
    temp_act(num_act+2).tj = temp_act(num_act+1).ti + spd_time_factor*rand();
    
    for j = 1:1:size(activity,2)
        flag_time_space = 0;
        for k = 1:1:size(temp_act, 2)-1
            if PPS(temp_act(k).pos, temp_act(k).ti, temp_act(k+1).pos, temp_act(k+1).tj, activity(j).pos, avg_spd)
                flag_time_space = 1;
                break;
            end
        end
        if flag_time_space == 1
            A_time_space(i) = A_time_space(i) + 1/size(activity,2);
        end
    end
end
 

%% plot

for i = 1:1:num_ppl
    home_posx(i) = people(i).hhpos(1);
    home_posy(i) = people(i).hhpos(2);
end

for i = 1:1:num_job
    job_posx(i) = job(i).pos(1);
    job_posy(i) = job(i).pos(2);
end

[xx,yy]=meshgrid(-100:0.1:100,-100:0.1:100);
zz = griddata(home_posx,home_posy,A_time_space,xx,yy);
figure();
surf(xx,yy,zz); title('Individual-based time space measure');

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

[xx,yy]=meshgrid(-100:0.5:100,-100:0.5:100);
zz = griddata(home_posx,home_posy,A_lse,xx,yy);
figure();
surf(xx,yy,zz); title('Individual-based logsum measure');