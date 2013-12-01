function [ alpha_peak_sample, alpha_peak_fq ] = get_alpha_peak( power, fq )


	% find samples for start and end of alpha spectrum 8 - 15 Hz
	alpha_start = length(find(fq <= 8));
	alpha_end = length(find(fq <= 15));

	alpha_band = power(alpha_start:alpha_end, :);
	fq_alpha_band = fq(alpha_start:alpha_end, :);

	max_alpha = max(alpha_band);
	max_alpha_sample = find(alpha_band == max_alpha);

	alpha_peak_sample = max_alpha_sample + alpha_start - 1;
	alpha_peak_fq = fq(alpha_peak_sample);


	% NIECETOHAVE: maybe try a brute force method where the area (trapez) is actually
	% calculated for each possible alpha peak band within 8-15 Hz limits

end
