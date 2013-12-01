function [root_dir] = get_root_dir()

  current_dir = pwd;
  cd ..
  root_dir = pwd;
  cd (current_dir);
