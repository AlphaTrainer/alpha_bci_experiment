% This function outputs the fast fourier transformation
function [ y_fft ] = get_fft( data )

	Nsamps = length(data);					% Number of samples

	transformed = fft(data);
	y_fft = abs(transformed);       		% Retain Magnitude - what does this mean?
	y_fft = y_fft(1:Nsamps/2) * 2;      	% Discard Half of Points - why?
	% fq = samplerate*(0:Nsamps/2-1)/Nsamps;  % Prepare freq data for plot 

	%{
	old...

	N = length(data);
	y_fft = fft( data , N); % take N point FFT.
	y_fft = abs(y_fft);
	%}

end
