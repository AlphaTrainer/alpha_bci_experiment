function [alpha1, alpha2, total1, total2, result1, result2, peak] = \
	 signal_processing(data=0,file_name_path="None", Fs=512, \
		       headset_name="NoHeadsetName", \
		       plot_figure_number=1, plot_settings, \
           alpha_peak_fq_param=0, low_cut_fq=1, high_cut_fq=60, closed_first=0, remove_12_5_hz_opi_peak=false)


  find_alpha_peak = true;

  % if an alpha peak value was given when this method was called
  if alpha_peak_fq_param != 0
    find_alpha_peak = false;
  end

  % default
  alpha1 = 0;
  alpha2 = 0;
  result1 = 0;
  result2 = 0;


  if !strcmp(file_name_path, "None")
    % load some data from file
    load(file_name_path);
  end

  % if mindwave headset, we convert values to volt
  % [ rawValue * (1.8/4096) ] / 2000 - source: http://support.neurosky.com/kb/science/how-to-convert-raw-values-to-voltage
  % well epoc doesn't seem to give volt values either, so we don't convert values to volt anyway..
  % if strcmp(headset_name, 'mindwave')
  %   data = data * (1.8 / 4096) / 2000;
  %   disp("miw");
  % end

  % NIECETOHAVE: 
  % if something is wrong we need data or file_name_path - make that clear
  %assert((data=0) && strcmp(file_name_path, "None"))

  % some sanity checks
  data_length = length(data);
  assert(data_length > (Fs*2));


  % always remove DC offset
  data = data - mean(data); 

  if mod(data_length, 2) !=0
    data_length= data_length-1;
  end

  data_length_half = data_length/2;

  data1 = data(1:data_length_half ,:);
  data2 = data(data_length_half+1:data_length ,:);

  % closed_first_param = closed_first
  if closed_first == 1
    disp('CLOSED EYES FIRST, SWAPPING DATA')
    temp = data1;
    data1 = data2;
    data2 = temp;
  else
    disp('OPEN EYES FIRST')
  end



  % % Plot data in Frequency Domain
  % N = length(data1)
  % % Fs = 512; % samplerate
  % fq = ([ 0 : N - 1] / N) * Fs; % prepare frequency for plot
  % % y_fft = get_fft(data);

  % y_fft_open = get_fft(data1);
  % y_fft_closed = get_fft(data2);

  % n_samp=512*1;
  % y_fft_sec_1 = get_fft(data(1:n_samp,:));
  % fq_1_sec = ([ 0 : n_samp - 1] / n_samp) * Fs; % prepare frequency for plot

  % y_fft_sec_2 = get_fft(data(n_samp+1:n_samp*2,:));
  % fq_1_sec = ([ 0 : n_samp - 1] / n_samp) * Fs; % prepare frequency for plot

  % figure(999);
  % plot(fq, y_fft_open); 
  % title('OPEN');
  % xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 80000]); % ylim([0 5e+05]); 
  % xlabel('Frequency (Hz)');
  % ylabel('Amplitude'); 

  % figure(1000);
  % plot(fq, y_fft_closed); 
  % title('CLOSED');
  % xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 80000]); % ylim([0 5e+05]); 
  % xlabel('Frequency (Hz)');
  % ylabel('Amplitude'); 

  % figure(1001);
  % plot(fq_1_sec, y_fft_sec_1); 
  % title('sec 1');
  % xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 20000]); % ylim([0 5e+05]); 
  % xlabel('Frequency (Hz)');
  % ylabel('Amplitude'); 

  % figure(1002);
  % plot(fq_1_sec, y_fft_sec_2); 
  % title('sec 2');
  % xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 20000]); % ylim([0 5e+05]); 
  % xlabel('Frequency (Hz)');
  % ylabel('Amplitude'); 

  % figure(1003);
  % plot(fq_1_sec, (y_fft_sec_1^2 + y_fft_sec_2^2)/2); 
  % title('sec 1+2');
  % xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
  % ylim([0 20000]); % ylim([0 5e+05]); 
  % xlabel('Frequency (Hz)');
  % ylabel('Amplitude'); 


  % keyboard


      ## [spectra1, freq1] = pwelch(data1, window=window_size, overlap=0.5, ...
      ## 				 Nfft=window_size, range=Fs);

      ## [spectra2, freq2] = pwelch(data2, window=window_size, overlap=0.5, ...
      ## 				Nfft=window_size, range=Fs);

  % use old approach (adjusted)

  % TODO: make bin_size adjustable form run_analysis

  % size of bin (seconds) used when calculating the powers later
  bin_size = 2;

  % Prepare vectors holding development in alpha and total powerspectrum (or at least wide)
  

  % % Plot data in Frequency Domain
  % N = length(data1)
  % % Fs = 512; % samplerate
  % fq = ([ 0 : N - 1] / N) * Fs; % prepare frequency for plot
  % % y_fft = get_fft(data);

result_open = get_fft_matrix( data1, Fs, bin_size, headset_name );
result_closed = get_fft_matrix( data2, Fs, bin_size, headset_name );

N = Fs * bin_size;
fq = ([ 0 : N/2 - 1] / N) * Fs; % prepare frequency for plot
% fq = ([ 0 : N - 1] / N) * Fs; % prepare frequency for plot % after change in get_fft (half data points...)


result_open_power = result_open.^2;
spectra1 = (mean(result_open_power))';
freq1 = fq';
result_closed_power = result_closed.^2;
spectra2 = (mean(result_closed_power))';
freq2 = fq';





 % figure(999);
 %  plot(freq2, spectra2); 
 %  title('TEST');
 %  xlim([0 25]); % higher frequency then e.g. do xlim([0 60])
 %  % ylim([0 80000]); % ylim([0 5e+05]); 
 %  xlabel('Frequency (Hz)');
 %  ylabel('Amplitude'); 


  alpha_peak_start_sample = 0;
  alpha_peak_end_sample = 0;



  % remove opi peak at 12.5 Hz
  if remove_12_5_hz_opi_peak % if strcmp(headset_name, 'opi')
    spectra1 = remove_12_5_hz_peak( spectra1, freq1 );
    spectra2 = remove_12_5_hz_peak( spectra2, freq2 );
  end



  if find_alpha_peak
    % find alpha peak from both open and closed eyes recording part
    [ alpha_1_peak_sample, alpha_1_peak_fq ] = get_alpha_peak( spectra1, freq1 );
    [ alpha_2_peak_sample, alpha_2_peak_fq ] = get_alpha_peak( spectra2, freq2 );


    % ensures alpha_2_peak_fq is a scalar - at some point we had a vector which broke execution
    assert(length(alpha_2_peak_fq) == 1);
    
    % find samples for start and end of alpha peak spectrum - 1Hz to each side
    alpha_peak_start_sample = length(find(freq2 <= alpha_2_peak_fq - 1))
    alpha_peak_end_sample = length(find(freq2 <= alpha_2_peak_fq + 1))

  else
    % find samples for start and end of alpha peak spectrum - 1Hz to each side
    alpha_peak_start_sample = length(find(freq2 <= alpha_peak_fq_param - 1))
    alpha_peak_end_sample = length(find(freq2 <= alpha_peak_fq_param + 1))
  end

  % NIECETOHAVE: should we show in log db_
  show_in_db = 0;

  %% plot ?
  if getfield(plot_settings, "makeplots")
    
    % show plot ?
    if getfield(plot_settings, "printplots")
       figure(plot_figure_number,'visible','on');  
    else
      figure(plot_figure_number, 'visible','off');
    end

    %% various plot - all alpha
    if show_in_db
       spectra1_power = 10*log10(spectra1);
       spectra2_power = 10*log10(spectra2);
    else
       spectra1_power = spectra1;
       spectra2_power = spectra2;
    end 

    plot( ...
    freq1,spectra1_power,"r;eyes open;", ...
    freq2,spectra2_power,"k;eyes closed;");

    % set ylim from 0 to double the alpha peak power (so the alpha peak will always be in the middle of the y axis)
    ylim_max = spectra2_power(alpha_2_peak_sample) * 2;
    ylim([0 ylim_max]);

    % NIECETOHAVE: verify this with an assert etc.
    %xlim([0 25]);
    xlim([low_cut_fq high_cut_fq]);

    root_dir = pwd;
    print(strcat(root_dir, '/results/', headset_name, '/', headset_name, '_result_', num2str(plot_figure_number),'.png'), '-dpng')


    %%
    %% plot raw signal 
    %% - we keep plot_figure_number tweak for now 
    %%
    if getfield(plot_settings, "printplots")
       figure(plot_figure_number+1000,'visible','on');  
    else
      figure(plot_figure_number+1000, 'visible','off');
    end

    plot(data,"b;raw signal;");
    print(strcat(root_dir, '/results/', headset_name, '/', headset_name, '_result_', num2str(plot_figure_number),'_raw_','.png'), '-dpng')



    %%
    %% plot alpha process for each bin 
    %% - we keep plot_figure_number tweak for now 
    %%
    if getfield(plot_settings, "printplots")
       figure(plot_figure_number+10000,'visible','on');  
    else
      figure(plot_figure_number+10000, 'visible','off');
    end

    % get alpha values 
    % - could probably be combined in one loop
    %   but requires bin numbers to be the same ?
    % NIECETOHAVE: could probably also be done without loop? more
    % linear algebra friendly ?
    alpha_progress_closed = [];
    for i=1 : rows(result_closed_power)
      tmp = result_closed_power(i,:)';
      alpha_progress_closed(i, :) = trapz(tmp(alpha_peak_start_sample:alpha_peak_end_sample, :));
    end

    alpha_progress_open = [];
    for i=1 : rows(result_open_power)
      tmp = result_open_power(i,:)';
      alpha_progress_open(i, :) = trapz(tmp(alpha_peak_start_sample:alpha_peak_end_sample, :));
    end

    figure_text_closed = strcat('k;eyes closed alpha peak: ', \
				num2str(alpha_2_peak_fq),';');
    figure_text_open = strcat('r;eyes open alpha peak: ', \
			      num2str(alpha_1_peak_fq),';');

    if show_in_db
      alpha_progress_open_power = 10*log10(alpha_progress_open);
      alpha_progress_closed_power = 10*log10(alpha_progress_closed);
    else
      alpha_progress_open_power = alpha_progress_open;
      alpha_progress_closed_power = alpha_progress_closed;
    end 

    plot(...
    alpha_progress_open_power, figure_text_open, ...
    alpha_progress_closed_power, figure_text_closed);

    print(strcat(root_dir, '/results/', headset_name, '/', headset_name, '_result_', num2str(plot_figure_number),'_alpha_progress_','.png'), '-dpng')

  end

  % the orginal said 60 but the length of spectra1 for epoc is only 33
  % - this was probably due to the "window = Fs/2" when calling pwelch function

  % NIECETOHAVE: is this right and can we veryfi the trapez and
  % negative values ect... lets start up with an assert:
  assert(high_cut_fq > low_cut_fq)

  total_power_start_sample = length(find(freq2 <= low_cut_fq)) % 1;
  total_power_end_sample = length(find(freq2 <= high_cut_fq)) % 60;


  % eyes open
  alpha1 = trapz(spectra1(alpha_peak_start_sample:alpha_peak_end_sample, :))
  
  % eyes closed
  alpha2 = trapz(spectra2(alpha_peak_start_sample:alpha_peak_end_sample, :))

  % eyes open
  total1 = trapz(spectra1(total_power_start_sample:total_power_end_sample, :))
  
  % eyes closed
  total2 = trapz(spectra2(total_power_start_sample:total_power_end_sample, :))

  % blue 
  result1 = alpha2/alpha1

  % green 
  result2 = (alpha2/total2) / (alpha1/total1)

  % peak is taken from recording where eyes are closed or from parameter given to this method (if any)
  if find_alpha_peak
    peak = alpha_2_peak_fq
  else
    peak = alpha_peak_fq_param
  end
