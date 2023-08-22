clear all; close all; clc;

% Read Airveda data from CSV file
T = readtable('Airveda devices 9 devices _5-23 April.csv');
vars = T.Properties.VariableNames;
sensor_ids = vars(1, 2:3:size(vars, 2))';
x = cell2mat(sensor_ids);
sensor_names = cellstr(x(:,13:15));
final_names = ['BAM1020'; sensor_names];
full_names = x(:,6:15);

% Read and process Airveda data
[airveda_data, airveda_date] = xlsread('Airveda devices 9 devices _5-23 April.csv');
dim = size(airveda_data);
s_date = size(airveda_date(:,1));
dates = airveda_date(2:s_date(1), 1);
date_nums = datenum(dates);
formatted_dates = datestr(date_nums, 'dd-mm-yyyy HH:MM:SS');

pm_data = airveda_data(:, 1:3:dim(2));
temperature_data = airveda_data(:, 2:3:dim(2));
rh_data = airveda_data(:, 3:3:dim(2));
pm_data(pm_data == 0) = NaN;
temperature_data(temperature_data > 40) = NaN;
rh_data(rh_data > 100) = NaN;

% Read and process BAM and Vaisala data
[bam_data, bam_date] = xlsread('EBAM_CESE_raw data file_5-23 April 2023.xlsx');
[vaisala_data, vaisala_date] = xlsread('Vaisala_data_file_5-23_April 2023.csv');
processed_vaisala_data = vaisala_data;
processed_vaisala_data(processed_vaisala_data(:, 1) > 100) = NaN;
vaisala_rh = processed_vaisala_data(:, 1);
vaisala_temperature = processed_vaisala_data(:, 2);
combined_pm_data = [bam_data, pm_data];
combined_rh_data = [vaisala_rh, rh_data];
combined_temperature_data = [vaisala_temperature, temperature_data];

% Generate correlation plots
[correlation_matrix, ~] = corrplot(combined_pm_data(:,:));
r_squared = correlation_matrix .* correlation_matrix;

% Plot heatmap of correlation matrix
heatmap_figure = heatmap(r_squared);
heatmap_figure.Colormap = hsv;
heatmap_figure.ColorLimits = [0.1 2];
heatmap_figure.CellLabelFormat = '%.2f';
heatmap_figure.CellLabelColor = 'k';
heatmap_figure.FontSize = 14;
heatmap_figure.XDisplayLabels = final_names(:, 1);
heatmap_figure.YDisplayLabels = final_names(:, 1);
heatmap_figure.XLabel = 'Sensors';
heatmap_figure.YLabel = 'Sensors';
heatmap_figure.Title = 'Correlation Heatmap of PM Sensors';
% caxis([0.2 1]);
figure;

% Generate correlation plot for subset of variables
[~, ~, correlation_axes] = corrplot(pm_data(:, 1:6), 'varNames', sensor_names(1:6, 1));
axes_array = get(correlation_axes, 'Parent');
axes_array = reshape([axes_array{:}], size(correlation_axes));
set(axes_array(:,:), 'FontSize', 8);
xlabel('Sensor Names');
ylabel('Sensor Names');
title('Correlation Plot of PM Sensors');
