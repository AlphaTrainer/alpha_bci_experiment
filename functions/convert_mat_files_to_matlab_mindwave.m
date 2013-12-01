function [] = convert_mat_files_to_matlab_mindwave()

  file_names = glob("mindwave/*.mat");    

  for ii = 1:rows(file_names) 

    % file_names{ii} has the form: mindwave/<filename>.mat
    file_name = substr(file_names{ii}, 1, -4);

    % lest load it
    load(file_name);

    % now we just want <filename>
    file_name = substr(file_name, 10);
    
    disp(file_name)
    
    % now save file as matlab friendly
    file_name = strcat('mindwave/matlab/', file_name, '_mat_binary.mat');
    save('-mat-binary', file_name, 'data');

  endfor 







