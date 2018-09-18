function y = travel_time(people_pos, job_pos, travel_quality, en_nobus, band_in_radi, band_out_radi)
    % travel_quality: 1 for walk, 2 for bus, 3 for drive
    % en_nobus: enable the nobus band for calculating the travel time
    % band_in_radi: inner radius of the nobus band
    % band_out_radi: outer radius of the nobus band
    if en_nobus == 0 || travel_quality == 1 || travel_quality == 3
    	y = sqrt((people_pos(1) - job_pos(1))^2 + (people_pos(2) - job_pos(2))^2) /travel_quality;
    elseif en_nobus == 1
    	coefficients = polyfit([people_pos(1),job_pos(1)], [people_pos(2),job_pos(2)], 1);
		k = coefficients (1);
		b = coefficients (2);
		[xin, yin] = linecirc(k,b,0,0,band_in_radi);
		[xout, yout] = linecirc(k,b,0,0,band_out_radi);
		
		if ~isnan(xin)
			intersec_ptsx(1) = xin(1);
			intersec_ptsx(2) = xin(2);
			intersec_ptsy(1) = yin(1);
			intersec_ptsy(2) = yin(2);
		else
			intersec_ptsx(1) = nan;
			intersec_ptsx(2) = nan;
		end

		if ~isnan(xout)
			intersec_ptsx(3) = xout(1);
			intersec_ptsx(4) = xout(2);
			intersec_ptsy(3) = yout(1);
			intersec_ptsy(4) = yout(2);
		else
			intersec_ptsx(3) = nan;
			intersec_ptsx(4) = nan;
		end

		count = 0;
		for i = 1:1:4
			if intersec_ptsx(i) > min(people_pos(1), job_pos(1)) && intersec_ptsx(i) < max(people_pos(1), job_pos(1))
				count = count + 1;
				actual_ptsx(count) = intersec_ptsx(i);
				actual_ptsy(count) = intersec_ptsy(i);
			end
		end

		switch count
			case 0
				y = sqrt((people_pos(1) - job_pos(1))^2 + (people_pos(2) - job_pos(2))^2)/travel_quality;
			case 1
				if people_pos(1)^2 + people_pos(2)^2 > band_in_radi^2 && people_pos(1)^2 + people_pos(2)^2 < band_out_radi^2 
					y = sqrt((people_pos(1) - actual_ptsx(1))^2 + (people_pos(2) - actual_ptsy(1))^2)/ 1 + sqrt((job_pos(1) - actual_ptsx(1))^2 + (job_pos(2) - actual_ptsy(1))^2)/ travel_quality;
				elseif job_pos(1)^2 + job_pos(2)^2 > band_in_radi^2 && job_pos(1)^2 + job_pos(2)^2 < band_out_radi^2 
					y = sqrt((people_pos(1) - actual_ptsx(1))^2 + (people_pos(2) - actual_ptsy(1))^2)/ travel_quality + sqrt((job_pos(1) - actual_ptsx(1))^2 + (job_pos(2) - actual_ptsy(1))^2)/ 1;
				else
					disp('count = 1: something wrong');
				end
			case 2
				if actual_ptsx(1) == actual_ptsx(2) && actual_ptsy(1) == actual_ptsy(2) % if tangent happens
					if people_pos(1)^2 + people_pos(2)^2 > band_out_radi^2 && job_pos(1)^2 + job_pos(2)^2 > band_out_radi^2
						y = sqrt((people_pos(1) - job_pos(1))^2 + (people_pos(2) - job_pos(2))^2) /travel_quality;
					else
						y = sqrt((people_pos(1) - job_pos(1))^2 + (people_pos(2) - job_pos(2))^2) / 1;
					end
				else
					if people_pos(1)^2 + people_pos(2)^2 < band_in_radi^2
						y = sqrt((people_pos(1) - actual_ptsx(1))^2 + (people_pos(2) - actual_ptsy(1))^2)/ travel_quality;
						y = y + sqrt((actual_ptsx(2) - actual_ptsx(1))^2 + (actual_ptsy(2) - actual_ptsy(1))^2)/ 1;
						y = y + sqrt((job_pos(1) - actual_ptsx(2))^2 + (job_pos(2) - actual_ptsy(2))^2)/ travel_quality;
					elseif job_pos(1)^2 + job_pos(2)^2 < band_in_radi^2
						y = sqrt((job_pos(1) - actual_ptsx(1))^2 + (job_pos(2) - actual_ptsy(1))^2)/ travel_quality;
						y = y + sqrt((actual_ptsx(2) - actual_ptsx(1))^2 + (actual_ptsy(2) - actual_ptsy(1))^2)/ 1;
						y = y + sqrt((people_pos(1) - actual_ptsx(2))^2 + (people_pos(2) - actual_ptsy(2))^2)/ travel_quality;						
					else
						y = min(sqrt((job_pos(1) - actual_ptsx(1))^2 + (job_pos(2) - actual_ptsy(1))^2)/ travel_quality, sqrt((job_pos(1) - actual_ptsx(2))^2 + (job_pos(2) - actual_ptsy(2))^2)/ travel_quality);
						y = y + sqrt((actual_ptsx(2) - actual_ptsx(1))^2 + (actual_ptsy(2) - actual_ptsy(1))^2)/ 1;
						y = y + min(sqrt((people_pos(1) - actual_ptsx(1))^2 + (people_pos(2) - actual_ptsy(1))^2)/ travel_quality, sqrt((people_pos(1) - actual_ptsx(2))^2 + (people_pos(2) - actual_ptsy(2))^2)/ travel_quality);
					end
							
				end
			case 3
				if actual_ptsx(1) == actual_ptsx(2) && actual_ptsy(1) == actual_ptsy(2) % if tangent happens
					if people_pos(1)^2 + people_pos(2)^2 < band_out_radi^2 && people_pos(1)^2 + people_pos(2)^2 > band_in_radi^2
						y = sqrt((people_pos(1) - actual_ptsx(3))^2 + (people_pos(2) - actual_ptsy(3))^2)/ 1;
						y = y + sqrt((job_pos(1) - actual_ptsx(3))^2 + (job_pos(2) - actual_ptsy(3))^2)/ travel_quality;
					elseif job_pos(1)^2 + job_pos(2)^2 < band_out_radi^2 && job_pos(1)^2 + job_pos(2)^2 > band_in_radi^2
						y = sqrt((people_pos(1) - actual_ptsx(3))^2 + (people_pos(2) - actual_ptsy(3))^2)/ travel_quality;
						y = y + sqrt((job_pos(1) - actual_ptsx(3))^2 + (job_pos(2) - actual_ptsy(3))^2)/ 1;						
					end
				elseif job_pos(1)^2 + job_pos(2)^2 < band_out_radi^2 && job_pos(1)^2 + job_pos(2)^2 > band_in_radi^2
					clear djob part1 part2 part3 part4;
					djob = sqrt((job_pos(1) - actual_ptsx(1))^2 + (job_pos(2) - actual_ptsy(1))^2);
					djob = [djob sqrt((job_pos(1) - actual_ptsx(2))^2 + (job_pos(2) - actual_ptsy(2))^2)];
					part1 = min(djob)/1;
					part2 = sqrt((actual_ptsx(1) - actual_ptsx(2))^2 + (actual_ptsy(1) - actual_ptsy(2))^2)/travel_quality;
					part3 = min(sqrt((actual_ptsx(1) - actual_ptsx(3))^2 + (actual_ptsy(1) - actual_ptsy(3))^2), sqrt((actual_ptsx(3) - actual_ptsx(2))^2 + (actual_ptsy(3) - actual_ptsy(2))^2))/1;
					part4 = sqrt((people_pos(1) - actual_ptsx(3))^2 + (people_pos(2) - actual_ptsy(3))^2)/travel_quality;
					y = part1 + part2 + part3 + part4;
					elseif people_pos(1)^2 + people_pos(2)^2 < band_out_radi^2 && people_pos(1)^2 + people_pos(2)^2 > band_in_radi^2
						clear dppl part1 part2 part3 part4;
						dppl = sqrt((people_pos(1) - actual_ptsx(1))^2 + (people_pos(2) - actual_ptsy(1))^2);
						dppl = [dppl sqrt((people_pos(1) - actual_ptsx(2))^2 + (people_pos(2) - actual_ptsy(2))^2)];
						part1 = min(dppl)/1;
						part2 = sqrt((actual_ptsx(1) - actual_ptsx(2))^2 + (actual_ptsy(1) - actual_ptsy(2))^2)/travel_quality;
						part3 = min(sqrt((actual_ptsx(1) - actual_ptsx(3))^2 + (actual_ptsy(1) - actual_ptsy(3))^2), sqrt((actual_ptsx(3) - actual_ptsx(2))^2 + (actual_ptsy(3) - actual_ptsy(2))^2))/1;
						part4 = sqrt((job_pos(1) - actual_ptsx(3))^2 + (job_pos(2) - actual_ptsy(3))^2)/travel_quality;
						y = part1 + part2 + part3 + part4;
						
				end
			case 4
				clear djob dppl;
				djob = sqrt((job_pos(1) - actual_ptsx(3))^2 + (job_pos(2) - actual_ptsy(3))^2);
				djob = [djob sqrt((job_pos(1) - actual_ptsx(4))^2 + (job_pos(2) - actual_ptsy(4))^2)];
				dppl = sqrt((people_pos(1) - actual_ptsx(3))^2 + (people_pos(2) - actual_ptsy(3))^2);
				dppl = [dppl sqrt((people_pos(1) - actual_ptsx(4))^2 + (people_pos(2) - actual_ptsy(4))^2)];

				if actual_ptsx(1) == actual_ptsx(2) && actual_ptsy(1) == actual_ptsy(2) % if tangent happens
					y = min(djob)/travel_quality + min(dppl)/travel_quality + sqrt((actual_ptsx(4) - actual_ptsx(3))^2 + (actual_ptsy(4) - actual_ptsy(3))^2)/1;
				else
					clear part1 part2 part3 part4 part5;
					part1 = min(djob)/travel_quality;
					part2 = min(sqrt((actual_ptsx(1) - actual_ptsx(3))^2 + (actual_ptsy(1) - actual_ptsy(3))^2), sqrt((actual_ptsx(3) - actual_ptsx(2))^2 + (actual_ptsy(3) - actual_ptsy(2))^2))/1;
					part3 = sqrt((actual_ptsx(1) - actual_ptsx(2))^2 + (actual_ptsy(1) - actual_ptsy(2))^2)/travel_quality;
					part4 = min(sqrt((actual_ptsx(1) - actual_ptsx(4))^2 + (actual_ptsy(1) - actual_ptsy(4))^2), sqrt((actual_ptsx(4) - actual_ptsx(2))^2 + (actual_ptsy(4) - actual_ptsy(2))^2))/1;
					part5 = min(dppl)/travel_quality;
                    y = part1 + part2 + part3 + part4 + part5;
				end
		end

     end
end