function [alpha1, alpha2, total1, total2, result1, result2, peak] = \
	 process_w_pwelch(data=0,file_name_path="None", Fs=512, \
		       headset_name="NoHeadsetName", \
		       plot_figure_number=1, remove_dc_offset=false, plot_settings, \
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

  % NIECETOHAVE: 
  % something is wrong we need data or file_name_path - make that
  % clear with an assert
  %assert((data=0) && strcmp(file_name_path, "None"))

  % some sanity checks
  data_length = length(data);
  assert(data_length > (Fs*2));

  % this should not have an effect frequency analysis - it just moves the raw data vertically so that mean(data) = 0
  if remove_dc_offset
    % remove DC offset
    data = data - mean(data);
  end

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

  
  % Note(s):
  %
  % - from "test" in test_process_w_pwelch.m we know that we get expected results
  %   when setting parameters window, Nfft and range to Fs (samplerate)
  
  % show 
  show_in_db = false;

    % higher values for window gives higher resolution, from test_process_w_pwelch.m
    % we know that the returned frequencies still are Hz as expected
  window_size = Fs * 10; % Fs/2;

  
  try
    [spectra1, freq1] = pwelch(data1, window=window_size, overlap=0.5, ...
			       Nfft=window_size, range=Fs);

    [spectra2, freq2] = pwelch(data2, window=window_size, overlap=0.5, ...
			      Nfft=window_size, range=Fs);
  catch
    printf ("Unable to call pwelch method - remember to load signal \
library - simply do octave> libs_install_and_load - error: %s\n", lasterr)
  end

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

  %% plot ?
  if getfield(plot_settings, "makeplots")
    
    % show plot ?
    if getfield(plot_settings, "printplots")
       figure(plot_figure_number,'visible','on');  
    else
      figure(plot_figure_number,'visible','off');
    end

    % various plot
    if show_in_db
       plot( ...
      freq1,10*log10(spectra1),"r;eyes open;", ...
      freq2,10*log10(spectra2),"k;eyes closed;");
    else
      plot( ...
      freq1,spectra1,"r;eyes open;", ...
      freq2,spectra2,"k;eyes closed;");
    end

    title(strcat(headset_name, ' - results: ', file_name_path));
    if show_in_db
      xlabel('Hz'); ylabel('dB - 10*log10?');
      xlim([1 30]);
    else
      xlabel('Hz'); ylabel('power/amplitude?');
      xlim([1 30]);
    end 

    % set ylim from 0 to double the alpha peak power (so the alpha peak will always be in the middle of the y axis)
    ylim_max = spectra2(alpha_2_peak_sample) * 2;
    ylim([0 ylim_max]);

    root_dir = pwd;
    print(strcat(root_dir, '/results/', headset_name, '/', headset_name, '_result_', num2str(plot_figure_number),'.png'), '-dpng')

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
