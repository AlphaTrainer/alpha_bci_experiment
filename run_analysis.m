clear all;

% Notes(s):
% read all files:
% file_names = glob("*"); 
% but then we probably rather would use: 
% [files, err, msg] = readdir (dir)
% some discussion on it here: http://goo.gl/moFkl

% Global settings:
% - we might not always like to read the edf files (true or false)
%   and or build results from the mat files and print plots ...
CONVERT_EDF_FILES=false;
BUILD_RESULT_FILES=true;
PLOT_SETTINGS=struct("makeplots", true, "printplots", false);
REMOVE_OPI_12_5_HZ_OFFSET=true;
ALPHA_PEAK_FQ=0; % any value != 0 disables the individually finding of alpha peaks
LOW_CUT_FQ = 5;
HIGH_CUT_FQ = 25;
USE_PWELCH = false;

OPI_SAMPLE_RATE=512;
MINDWAVE_SAMPLE_RATE=512;
EPOC_SAMPLE_RATE=128;
PROCESS_NOISE=false;

root_dir = pwd;

% load function and edfread
addpath(strcat(root_dir, '/functions'));
addpath(strcat(root_dir, '/edfread'));

%%
%% Mindwave:
%%

if CONVERT_EDF_FILES
   % well its not an edf file but lets assume we want the matlab
   % friendly files on the same go.
   convert_mat_files_to_matlab_mindwave();
   display("-------------------------");
end

if BUILD_RESULT_FILES
  [result_mindwave] = \
  build_result_mindwave(sample_rate=MINDWAVE_SAMPLE_RATE, \
			plot_settings=PLOT_SETTINGS, \
			alpha_peak_fq=ALPHA_PEAK_FQ, \
			low_cut_fq=LOW_CUT_FQ, \
			high_cut_fq=HIGH_CUT_FQ, \
		  use_pwelch=USE_PWELCH, \
      process_noise=PROCESS_NOISE);
end


%%
%% Epoc
%%

if CONVERT_EDF_FILES
  [data] = convert_edf_files_epoc(sample_rate = EPOC_SAMPLE_RATE);
end

if BUILD_RESULT_FILES
  [result_epoc] = build_result_epoc(sample_rate=EPOC_SAMPLE_RATE, \
				    plot_settings=PLOT_SETTINGS, \
				    alpha_peak_fq=ALPHA_PEAK_FQ, \
				    low_cut_fq=LOW_CUT_FQ, \
				    high_cut_fq=HIGH_CUT_FQ, \
				    use_pwelch=USE_PWELCH, \
            process_noise=PROCESS_NOISE);
end


%%
%% OPI
%%

if CONVERT_EDF_FILES
  [data] = convert_edf_files_opi(sample_rate=OPI_SAMPLE_RATE);
end

if BUILD_RESULT_FILES
  [result_opi] = build_result_opi(sample_rate=EPOC_SAMPLE_RATE, \
				  plot_settings=PLOT_SETTINGS, \
				  alpha_peak_fq=ALPHA_PEAK_FQ, \
				  low_cut_fq=LOW_CUT_FQ, \
				  high_cut_fq=HIGH_CUT_FQ, \
				  REMOVE_OPI_12_5_HZ_OFFSET, \
				  use_pwelch=USE_PWELCH, \
          process_noise=PROCESS_NOISE);
end




%%
%% Visualize results
%%
%% - we keep it here so fare (if it groves seperate out in functions etc).
%%

if (!BUILD_RESULT_FILES)
  load(strcat(root_dir, '/results/result_opi.mat'));
  load(strcat(root_dir, '/results/result_epoc.mat'));
  load(strcat(root_dir, '/results/result_mindwave.mat'));
end

figure(1000, 'visible', getfield(PLOT_SETTINGS, "printplots"))

x_lim_result = 16

% set(f, 'visible', 'off')
subplot(3, 1, 1);
plot(result_epoc(:, 5), "@;absolute;", result_epoc(:, 6), \
     "@;relative;");
title('EPOC results');
xlim([0 x_lim_result])

subplot(3, 1, 2)
plot(result_mindwave(:, 5), '@;absolute;', result_mindwave(:, 6), '@;relative;');
title('MindWave results');
xlim([0 x_lim_result])

subplot(3, 1, 3)
plot(result_opi(:, 5), '@;absolute;', result_opi(:, 6), '@;relative;');
title('OPI results');
xlim([0 x_lim_result])

print(strcat(root_dir, '/results/result.png'), '-dpng')

# 5 = absolute / 6 = relative
mean_epoc = mean(result_epoc(: , 5:6))
mean_mindwave = mean(result_mindwave(: , 5:6))
mean_opi = mean(result_opi(: , 5:6))

std_dev_epoc = std(result_epoc(: , 5:6))
std_dev_mindwave = std(result_mindwave(: , 5:6))
std_dev_opi = std(result_opi(: , 5:6))


fprintf('\n============ result start ================\n');

fprintf('\nMeasure  EPOC  MindWave  TrueSense Kit (OPI)\n');
fprintf('\nAbsolute alpha  %0.2f ±%0.2f  %0.2f ±%0.2f  %0.2f ±%0.2f\n', mean_epoc(1:1), std_dev_epoc(1:1), mean_mindwave(1:1), std_dev_mindwave(1:1), mean_opi(1:1), std_dev_opi(1:1));
fprintf('\nRelative alpha  %0.2f ±%0.2f  %0.2f ±%0.2f  %0.2f ±%0.2f\n', mean_epoc(2:2), std_dev_epoc(2:2), mean_mindwave(2:2), std_dev_mindwave(2:2), mean_opi(2:2), std_dev_opi(2:2));

fprintf('\n============ result end ================\n');
