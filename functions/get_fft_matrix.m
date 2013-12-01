function [ result ] = get_fft_matrix( data, Fs, bin_size, headset_name )

  timeslots = 121;
  window_size = Fs * bin_size;
  overlap = 4;
  % timeslots = length(data) / (Fs * bin_size); % number of time bins where we have collected data
  result = zeros(timeslots, Fs * bin_size / 2);
  % result = zeros(timeslots, Fs * bin_size); %after change in get_fft (half data points...)

  % noise_threshold = 9 * std(data); % we have removed DC offset thus we know mean is 0 and do not need to do mean +- threshold
  noise_threshold = 0; % we have removed DC offset thus we know mean is 0 and do not need to do mean +- threshold

  if strcmp(headset_name, 'mindwave')
    noise_threshold = 600;
  elseif strcmp(headset_name, 'epoc')
    noise_threshold = 300;
  elseif strcmp(headset_name, 'opi')
    noise_threshold = 30;
  elseif strcmp(headset_name, 'test')
    noise_threshold = 100000;
    timeslots = 5;
  end
  

  current_sample = 1; % keep track of which samples have been analyzed
  discarded_bins = 0;
  accepted_bins = 0;

  for i=1 : length(data) / window_size * overlap
  % i = 1;
  % while (i <= timeslots)

    if current_sample + window_size <= length(data) && accepted_bins < timeslots

      data_bin = data(current_sample:current_sample + window_size - 1,:);

      if max(data_bin) > noise_threshold || min(data_bin) < -noise_threshold

        % max(data_bin)
        % min(data_bin)

        discarded_bins++;
        % disp('DISCARTING BIN ')
        % disp(i);
        % result(i,:) = zeros(1, Fs * bin_size) - 1;

      else

        y_fft = get_fft(data_bin);
        % result(i,:) = y_fft';
        result(++accepted_bins,:) = y_fft';
        % accepted_bins++;
        i++;

      end

     current_sample += (window_size / overlap);

      end
    
  end

  assert(accepted_bins == timeslots)

  disp(strcat('Discarded bins: ', num2str(discarded_bins)));



end
