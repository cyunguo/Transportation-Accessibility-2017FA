function y = travel_dist(people_pos, job_pos)
    y = sqrt((people_pos(1) - job_pos(1))^2 + (people_pos(2) - job_pos(2))^2);
end