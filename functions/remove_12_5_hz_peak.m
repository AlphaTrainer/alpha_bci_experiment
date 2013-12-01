function [ data ] = remove_12_5_hz_peak( spectra, freq )

% remove the peak at 12.5 Hz which appears when inside ITU both when recording to MM and over radio

    fill_mean_start = length(find(freq <= 6));
    fill_mean_end = length(find(freq <= 11));
    fill_band = spectra(fill_mean_start:fill_mean_end, :);

    outliers_search_band_start = length(find(freq <= 11));
    outliers_search_band_end = length(find(freq <= 14));

    fill_value = mean(fill_band);
    % fill_value = 2000;

    outliers = find(spectra > 5 * fill_value); % mean(fill_band))
    % outliers = find(outliers > outliers_search_band_start)


    % Iterate through all outliers
    for i=1 : length(outliers)
    	if outliers(i) > outliers_search_band_start
        	spectra(outliers(i)) = fill_value;
        end
    end

    data = spectra;

end