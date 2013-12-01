function [data] = cut_out_data(input_data=0, Fs=512)

	% 15 seconds:
	to_be_discarted = 15*Fs;
	half_recording_time = 2*60*Fs; % two minutes
	% recording_length = 2*2*60*Fs;
	input_data_length = length(input_data)

	midpoint = 0;

	if mod(input_data_length, 2) != 0
		midpoint = (input_data_length - 1) / 2;
	else
		midpoint = input_data_length / 2;
	end

	% make sure recording is long enough (longer than 4,5 minutes)
    assert(input_data_length > 2 * half_recording_time + 2 * to_be_discarted)

    data_first_half = input_data((midpoint-to_be_discarted-half_recording_time):(midpoint-to_be_discarted-1));
    data_second_half = input_data((midpoint+to_be_discarted):(midpoint+to_be_discarted+half_recording_time-1));

    assert(length(data_first_half) + length(data_second_half) == 2 * half_recording_time)

    % keyboard

    data = [data_first_half; data_second_half];

