% This function outputs a value for the power of a specified frequency spectrum
% FFT is applied and then the integral under the specified frequency range is calculated and returned
function [ power ] = get_band_power( fq_min, fq_max, data, samplerate )

	% FFT (see method explained in fft_ex.m / fft_ex_eeg.m)
	N = length(data);
	Fs = samplerate; % samplerate (supposed to be 512 according to Mindwave documentation)

	fq = [ 0 : N - 1] / N;
	fq = fq * Fs;
	y_fft = get_fft(data);

	% NIECETOHAVE: also if we are going to use the whole power
	% we should discard - half of the y_fft "% Discard Half of
	% Points - why?" beacuse http://screencast.com/t/neyRoGXD

	% also POWER = mean(amplitude^2) according to the eeglab slides.	

	% Find min and max index within frequency spectrum:
	min_index = length(find(fq <= fq_min)); % Index of frequency spectrum start
	max_index = length(find(fq <= fq_max)); % Index of frequency spectrum stop

	% Calculate and output the integral within frequency spectrum
	power = trapz(y_fft(min_index:max_index,:));

end
