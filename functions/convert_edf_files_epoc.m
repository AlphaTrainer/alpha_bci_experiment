function [data] = convert_edf_files_epoc(sample_rate = 128)

  dir_name = "epoc";

  % clean up old mat files
  file_names = glob(strcat(dir_name, "/*.mat"));    
  ii = 0;
  for ii = 1:rows(file_names) 
    unlink(file_names{ii})
  endfor

  % lets go and convert the edf files to mat
  file_names = glob(strcat(dir_name, "/*.edf"));

  ii = 0;
  for ii = 1:rows(file_names) 
    disp(file_names{ii})

    header = edfread(file_names{ii},'AssignToVariables',true);

    % ensure we are using the right sample rate for our analysis
    % change to 10 if we are switching to O2
    assert(sample_rate == getfield(header, "samples")(9));

    % or O2'
    data = cut_out_data(O1', sample_rate);

    % NIECETOHAVE: at some point we might want to look into some of the
    % channels that are closer to the front head - which don't
    % provides the same alpha peaks
    % data = cut_out_data(F3', sample_rate);

    % save data to mat file:
    % file_names{ii} hast the form: epoc/<filename>.edf
    % we want: epoc/<filename>
    file_name = substr(file_names{ii}, 1, -4);
    save(strcat(file_name, '.mat'), 'data');

  endfor 
