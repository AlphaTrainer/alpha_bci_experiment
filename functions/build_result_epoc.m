function [result_epoc] = build_result_epoc(sample_rate, \
					   plot_settings=false, \
					   alpha_peak_fq=0, \
					   low_cut_fq=1, \
					   high_cut_fq=60, \
					   use_pwelch = true, \
             process_noise = false, \ 
             headset_name="epoc")

  file_names = glob("epoc/*.mat");    
  number_of_files = length(file_names)

  % lets start with an empty matrix
  result_epoc = []; 
  result_index = 1;
  for ii = 1:rows(file_names)

    % either skip or show only noise recordings (prefixed 'n')
    if (length(findstr(file_names{ii}, '/n')) && ~process_noise)
      number_of_files--;
      continue;
    end

    disp(file_names{ii})
    load(file_names{ii});

    # do whatever you want to do  with file_names{ii} file 
    if use_pwelch
      [alpha1 alpha2 total1 total2 result1 result2 peak] = process_w_pwelch( ...
		     data=0,
		     file_name_path=file_names{ii}, ...
		     Fs=sample_rate, ...
		     headset_name=headset_name, ...
		     plot_figure_number=ii, ...
		     remove_dc_offset=false, ... 
		     plot_settings=plot_settings, ...
	 alpha_peak_fq_param=alpha_peak_fq, ...
	 low_cut_fq = low_cut_fq, ...
	 high_cut_fq = high_cut_fq, ...
	 closed_first = length(findstr(file_names{ii}, 'closed')), ...
	 remove_12_5_hz_opi_peak = false );

    else


      [alpha1 alpha2 total1 total2 result1 result2 peak] = signal_processing( ...
         data=0,
         file_name_path=file_names{ii}, ...
         Fs=sample_rate, ...
         headset_name=headset_name, ...
         plot_figure_number=ii, ...
         plot_settings=plot_settings, ...
   alpha_peak_fq_param=alpha_peak_fq, ...
   low_cut_fq = low_cut_fq, ...
   high_cut_fq = high_cut_fq, ...
   closed_first = length(findstr(file_names{ii}, 'closed')), ...
   remove_12_5_hz_opi_peak = false );


    end

    result_epoc(result_index++ , :) = [alpha1 alpha2 total1 total2 result1 result2 peak];
    display("-------------------------")

  endfor 


  assert(result_index-1 == number_of_files);

  result_epoc

  % store result
  save('results/result_epoc.mat', 'result_epoc');
