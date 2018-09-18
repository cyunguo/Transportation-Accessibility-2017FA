function y = PPS(ipos, ti, jpos, tj, kpos, avg_spd)
    tmax = tj - sqrt((jpos(1)-kpos(1))^2 + (jpos(2)-kpos(2))^2)/avg_spd;
    tmin = ti + sqrt((ipos(1)-kpos(1))^2 + (ipos(2)-kpos(2))^2)/avg_spd;
    if tmax >= tmin
        y = true;
    else
        y = false;
    end
    