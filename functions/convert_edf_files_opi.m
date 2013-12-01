function [data] = convert_edf_files_opi(sample_rate = 512)

  dir_name = "opi";

  % clean up old mat files
  file_names = glob(strcat(dir_name, "/*.mat"));    
  ii = 0;
  for ii = 1:rows(file_names) 
    unlink(file_names{ii})
  endfor

  % lets go and convert the edf files to mat
  file_names = glob(strcat(dir_name, "/*.edf"));

  for ii = 1:rows(file_names) 
    disp(file_names{ii})

    header = edfread(file_names{ii},'AssignToVariables',true);
    
    % note:
    % ensure we are using the right sample rate for our analysis
    % we devide with 8 based on the explanation from the opi people
    % "that field is not SampleRate, that's number of samples per
    % record (and each record consists of 8 seconds)"
    assert(sample_rate == (getfield(header, "samples")(1)/8));

    data = cut_out_data(ADC', sample_rate);

    % save data to mat file:
    % file_names{ii} hast the form: opi/<filename>.edf
    % we want: opi/<filename>
    file_name = substr(file_names{ii}, 1, -4);
    save(strcat(file_name, '.mat'), 'data');

  endfor 
