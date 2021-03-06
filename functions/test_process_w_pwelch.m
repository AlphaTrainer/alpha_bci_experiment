

function test_process_w_pwelch()

  % Test of pwelch processing by processing a known (constructed) signal


  %-----------------------------------------------------------------------
  % This part of the script verifies that our fast fourier transformation
  % and calculation of power bands is correct. The strategy is to create
  % a signal from known frequencies (sine waves) and check whether we see
  % these frequencies when calculating power bands.
  %-----------------------------------------------------------------------

  plot_figure_number = 1;

  D = 10.0; %1.2; %signal duration
  S = 1000; % sampling rate, i.e. N points pt sec used to represent sine wave
  F = [30 40 100 200]; % 4 frequencies in Hz
  w = 2*pi*F; % convert frequencies to radians
  P = [0 .5 .25 .3]; % 4 corresponding phases
  A = [1 .5 .3 .2]; % corresponding amplitudes
  T = 1/S; % sampling period, i.e. for this e.g. points at 1 ms intervals
  t = [T:T:D]; % time vector %NB this has been corrected from previous version
  mysig=zeros(1,length(t)); %initialise mysig
  myphi=2*pi*P; % compute phase angle
  nfreqs=length(F); % N frequencies in the complex
  % Add all sine waves together to give composite
  for thisfreq=1:nfreqs
  mysig = mysig+A(thisfreq)*(sin(w(thisfreq)*t + myphi(thisfreq)));
  end

  mysig = mysig';

  figure(plot_figure_number=plot_figure_number+1);
  plot(t,mysig);
  title('Test signal - 30, 40, 100 and 200 Hz');
  xlabel('Time (seconds)');
  ylabel('Amplitude');
  %-----------------------------------------------------------------------


  % Plot test data in Frequency Domain
  N = length(mysig);
  Fs = S; % samplerate
  window_size = Fs; % * 10;
  fq = ([ 0 : N - 1] / N) * Fs; % prepare frequency for plot

  % NIECETOHAVE: maybe wrap pwelch call in separate function to keep arguments in sync

  % pwelch(data1, window=window_size, overlap=0.5, Nfft=window_size, range=Fs);
  [spectra, freq] = pwelch(mysig, window=window_size, overlap=0.5, Nfft=window_size, range=Fs);


  % higher values for window gives higher resolution - still we see peaks at expected frequencies

  figure(plot_figure_number=plot_figure_number+1);
  plot(freq, spectra); 
  title('Frequency Response of test signal - 30, 40, 100 and 200 Hz');
  xlim([0 220]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 500]); % 
  xlabel('Frequency (Hz)');
  ylabel('Amplitude (?)');


  % keyboard;

  % Get a few power bands. We expect to see a high value at 30, 40 and 100 Hz

  for i = 10:10:220
    alpha_peak = i
    power = trapz(spectra(i-1:alpha_peak+1, :))
  end

% some outputs (hard to get it into asserts (niecetohave) ):

% alpha_peak =  30
% power =  0.25000
% alpha_peak =  40
% power =  0.062500

% alpha_peak =  200
% power =  0.0100000

% octave:7> 0.25/0.0625
% ans =  4
% octave:8> 0.25/0.01
% ans =  25

% difference in input amplitude is squared! 1:0.5 -> 4; 1:0.2 -> 25


end

